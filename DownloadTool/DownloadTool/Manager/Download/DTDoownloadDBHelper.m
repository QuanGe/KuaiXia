//
//  DTDoownloadDBHelper.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTDoownloadDBHelper.h"
#import <YTKKeyValueStore/YTKKeyValueStore.h>
#import <YYKit/YYKit.h>

#define DBName_DownloadHistory    @"DownloadHistory.db"
#define TBName_DownloadHistory    @"DownloadHistory_table"

@interface DTDoownloadDBHelper(){
    YTKKeyValueStore *_store;
}

@end

@implementation DTDoownloadDBHelper

+ (instancetype)sharedDB {
    static DTDoownloadDBHelper *db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[DTDoownloadDBHelper alloc] init];
        [db openDB];
    });
    return db;
}

- (void)openDB {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self hasHideFile], DBName_DownloadHistory];
    _store = [[YTKKeyValueStore alloc] initDBWithName:path];
    [_store createTableWithName:TBName_DownloadHistory];
}

#pragma mark - DB
//保存
- (void)saveItem:(DTDownloadModel *)item{
    NSDictionary *dic = [item modelToJSONObject];
    [_store putObject:dic withId:item.downloadUrl intoTable:TBName_DownloadHistory];
}

//删除
- (void)deleteItem:(DTDownloadModel *)item{
    [_store deleteObjectById:item.downloadUrl fromTable:TBName_DownloadHistory];
}

//删除全部
- (void)deleteAllItem{
    [_store clearTable:TBName_DownloadHistory];
}

//获取全部
- (NSArray *)getAllItems {
    NSArray *arr = [_store getAllItemsFromTable:TBName_DownloadHistory];
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:arr];
    NSArray *reverseArr = [[tmpArr reverseObjectEnumerator] allObjects];
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (YTKKeyValueItem *yyItem in reverseArr) {
        NSDictionary *obj = yyItem.itemObject;
        DTDownloadModel *item = [DTDownloadModel modelWithDictionary:obj];
        [arrM addObject:item];
    }
    return arrM.copy;
}

//获取制定的
- (DTDownloadModel*)getSelModelUrl:(NSString*)downmodelUrl{
    NSDictionary *dict = [_store getObjectById:downmodelUrl fromTable:TBName_DownloadHistory];
    return [DTDownloadModel modelWithDictionary:dict];
}

#pragma mark - Helper
//下载文件夹路径
- (NSString *)hasHideFile{
    NSString *path_document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *hidePath = [path_document stringByAppendingPathComponent:@".DB"];
    
    //创建一个隐藏的文件夹
    if ([[NSFileManager defaultManager] fileExistsAtPath:hidePath] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:hidePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return @".downloadFile";
}
@end
