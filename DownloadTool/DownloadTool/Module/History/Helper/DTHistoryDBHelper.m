//
//  DTHistoryDBHelper.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/30.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTHistoryDBHelper.h"
#import "DTDBManager.h"

#define TBName_DTHistory    @"DTHistory_table"

@interface DTHistoryDBHelper()

@end

@implementation DTHistoryDBHelper

+ (instancetype)sharedHistoryDB {
    static DTHistoryDBHelper *db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[DTHistoryDBHelper alloc] init];
        [db openDB];
    });
    return db;
}

- (void)openDB {
    [[DTDBManager sharedDTDB] openDBTableName:TBName_DTHistory];
}


/**获取全部*/
- (NSArray *)getAllItems{
    NSArray *reverseArr = [[DTDBManager sharedDTDB] getAllItemsTableName:TBName_DTHistory];
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (YTKKeyValueItem *yyItem in reverseArr) {
        NSDictionary *obj = yyItem.itemObject;
        DTHistoryModel *item = [DTHistoryModel modelWithDictionary:obj];
        [arrM addObject:item];
    }
    return arrM.copy;
}

/**删除全部*/
- (void)deleteAllItem{
    [[DTDBManager sharedDTDB] deleteAllItemTableName:TBName_DTHistory];
}

/**保存*/
- (void)saveUrl:(NSString*)url title:(NSString*)title{
    DTHistoryModel *model = [[DTHistoryModel alloc] init];
    model.title = title;
    model.url = url;
    model.createdDate = [[NSDate date] timeIntervalSince1970];
    
    NSDictionary *dic = [model modelToJSONObject];
    if (dic && model.url.length > 0) {
        [[DTDBManager sharedDTDB]saveItem:dic key:model.url tableName:TBName_DTHistory];
    }
}

/**删除*/
- (void)deleteItem:(DTHistoryModel *)item{
    [[DTDBManager sharedDTDB] deleteItemKey:item.url tableName:TBName_DTHistory];
}


@end
