//
//  DTSeatchHistoryDBHelper.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTSeatchHistoryDBHelper.h"
#import "DTDBManager.h"
#import "DTCommonHelper.h"

#define TBName_SearchHistory    @"SearchHistory_table"

@interface DTSeatchHistoryDBHelper()

@end

@implementation DTSeatchHistoryDBHelper

+ (instancetype)sharedSearchDB {
    static DTSeatchHistoryDBHelper *db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[DTSeatchHistoryDBHelper alloc] init];
        [db openDB];
    });
    return db;
}

- (void)openDB {
    [[DTDBManager sharedDTDB] openDBTableName:TBName_SearchHistory];
}


/**获取全部*/
- (NSArray *)getAllItems{
    NSArray *reverseArr = [[DTDBManager sharedDTDB] getAllItemsTableName:TBName_SearchHistory];
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (YTKKeyValueItem *yyItem in reverseArr) {
        NSDictionary *obj = yyItem.itemObject;
        DTSeatchHistoryModel *item = [DTSeatchHistoryModel modelWithDictionary:obj];
        [arrM addObject:item];
    }
    return arrM.copy;
}

/**删除全部*/
- (void)deleteAllItem{
    [[DTDBManager sharedDTDB] deleteAllItemTableName:TBName_SearchHistory];
}

/**保存*/
- (void)saveItem:(DTSeatchHistoryModel *)item{
    NSDictionary *dic = [item modelToJSONObject];
    if (dic && item.title.length > 0) {
        [[DTDBManager sharedDTDB]saveItem:dic key:item.title tableName:TBName_SearchHistory];
    }
}

/**删除*/
- (void)deleteItem:(DTSeatchHistoryModel *)item{
    [[DTDBManager sharedDTDB] deleteItemKey:item.title tableName:TBName_SearchHistory];
}

@end
