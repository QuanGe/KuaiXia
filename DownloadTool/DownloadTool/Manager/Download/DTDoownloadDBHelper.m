//
//  DTDoownloadDBHelper.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTDoownloadDBHelper.h"
#import "DTDBManager.h"

#define TBName_DownloadHistory    @"DownloadHistory_table"

@interface DTDoownloadDBHelper()
@end

@implementation DTDoownloadDBHelper

+ (instancetype)sharedDownDB {
    static DTDoownloadDBHelper *db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[DTDoownloadDBHelper alloc] init];
        [db openDB];
    });
    return db;
}

- (void)openDB{
    [[DTDBManager sharedDTDB] openDBTableName:TBName_DownloadHistory];
}

#pragma mark - DB
//保存
- (void)saveItem:(DTDownloadModel *)item{
    NSDictionary *dic = [item modelToJSONObject];
    if (dic && item.downloadUrl.length > 0) {
        [[DTDBManager sharedDTDB] saveItem:dic key:item.downloadUrl tableName:TBName_DownloadHistory];
    }
}

//删除
- (void)deleteItem:(DTDownloadModel *)item{
    [[DTDBManager sharedDTDB] deleteItemKey:item.downloadUrl tableName:TBName_DownloadHistory];
}

//删除全部
- (void)deleteAllItem{
    [[DTDBManager sharedDTDB] deleteAllItemTableName:TBName_DownloadHistory];
}

//获取全部
- (NSArray *)getAllItems {
    NSArray *reverseArr = [[DTDBManager sharedDTDB] getAllItemsTableName:TBName_DownloadHistory];
    
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
    NSDictionary *dict = [[DTDBManager sharedDTDB] getSelectKey:downmodelUrl tableName:TBName_DownloadHistory];
    return [DTDownloadModel modelWithDictionary:dict];
}

/**获取下载完的*/
- (NSArray *)getSucessItems{
    NSArray *reverseArr = [[DTDBManager sharedDTDB] getAllItemsTableName:TBName_DownloadHistory];
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (YTKKeyValueItem *yyItem in reverseArr) {
        NSDictionary *obj = yyItem.itemObject;
        DTDownloadModel *item = [DTDownloadModel modelWithDictionary:obj];
        if (item.downloadStatus == DTWSLDownLoad_Complete) {
            [arrM addObject:item];
        }
    }
    return arrM.copy;
}

/**获取非下载完的*/
- (NSArray *)getLoadingItems{
    NSArray *reverseArr = [[DTDBManager sharedDTDB] getAllItemsTableName:TBName_DownloadHistory];
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (YTKKeyValueItem *yyItem in reverseArr) {
        NSDictionary *obj = yyItem.itemObject;
        DTDownloadModel *item = [DTDownloadModel modelWithDictionary:obj];
        if (item.downloadStatus != DTWSLDownLoad_Complete) {
            [arrM addObject:item];
        }
    }
    
    return arrM.copy;
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
