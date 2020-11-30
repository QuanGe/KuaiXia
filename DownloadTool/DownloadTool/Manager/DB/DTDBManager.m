//
//  DTDBManager.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/30.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTDBManager.h"

#define DBName_DownloadHistory    @"DownloadHistory.db"

@interface DTDBManager(){
    YTKKeyValueStore *_store;
}

@end

@implementation DTDBManager

+ (instancetype)sharedDTDB {
    static DTDBManager *db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[DTDBManager alloc] init];
    });
    return db;
}

/**根据表名打开表*/
- (void)openDBTableName:(NSString*)tableName{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self hasHideFile], DBName_DownloadHistory];
    _store = [[YTKKeyValueStore alloc] initDBWithName:path];
    [_store createTableWithName:tableName];
}


/**获取全部*/
- (NSArray *)getAllItemsTableName:(NSString*)tableName{
    NSArray *arr = [_store getAllItemsFromTable:tableName];
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:arr];
    NSArray *reverseArr = [[tmpArr reverseObjectEnumerator] allObjects];

    return reverseArr;
}

/**删除全部*/
- (void)deleteAllItemTableName:(NSString*)tableName{
    [_store clearTable:tableName];
}

/**保存*/
- (void)saveItem:(NSDictionary *)item key:(NSString*)key tableName:(NSString*)tableName{
    [_store putObject:item withId:key intoTable:tableName];
}

/**删除制定*/
- (void)deleteItemKey:(NSString *)key tableName:(NSString*)tableName{
    [_store deleteObjectById:key fromTable:tableName];
}

/**根据指定的*/
- (NSDictionary *)getSelectKey:(NSString*)key tableName:(NSString*)tableName{
    NSDictionary *dict = [_store getObjectById:key fromTable:tableName];
    return dict;
}

#pragma mark - Helper
//下载文件夹路径
- (NSString *)hasHideFile{
    NSString *name = @".DB";
    NSString *path_document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *hidePath = [path_document stringByAppendingPathComponent:name];
    
    //创建一个隐藏的文件夹
    if ([[NSFileManager defaultManager] fileExistsAtPath:hidePath] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:hidePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return name;
}

@end
