//
//  DTSeatchHistoryDBHelper.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTSeatchHistoryDBHelper.h"
#import <YTKKeyValueStore/YTKKeyValueStore.h>
#import <YYKit/YYKit.h>
#import "DTCommonHelper.h"

#define DBName_SearchHistory    @"SearchHistory.db"
#define TBName_SearchHistory    @"SearchHistory_table"

@interface DTSeatchHistoryDBHelper(){
    YTKKeyValueStore *_store;
}

@end

@implementation DTSeatchHistoryDBHelper

+ (instancetype)sharedDB {
    static DTSeatchHistoryDBHelper *db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[DTSeatchHistoryDBHelper alloc] init];
        [db openDB];
    });
    return db;
}

- (void)openDB {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [DTCommonHelper hasHideDBFile], DBName_SearchHistory];
    _store = [[YTKKeyValueStore alloc] initDBWithName:path];
    [_store createTableWithName:TBName_SearchHistory];
}


/**获取全部*/
- (NSArray *)getAllItems{
    NSArray *arr = [_store getAllItemsFromTable:TBName_SearchHistory];
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:arr];
    NSArray *reverseArr = [[tmpArr reverseObjectEnumerator] allObjects];
    
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
    [_store clearTable:TBName_SearchHistory];
}

/**保存*/
- (void)saveItem:(DTSeatchHistoryModel *)item{
    NSDictionary *dic = [item modelToJSONObject];
    if (dic && item.title.length > 0) {
        [_store putObject:dic withId:item.title intoTable:TBName_SearchHistory];
    }
}

/**删除*/
- (void)deleteItem:(DTSeatchHistoryModel *)item{
    [_store deleteObjectById:item.title fromTable:TBName_SearchHistory];
}

@end
