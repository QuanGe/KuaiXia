//
//  DTDBManager.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/30.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YTKKeyValueStore/YTKKeyValueStore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DTDBManager : NSObject

+ (instancetype)sharedDTDB;

/**根据表名打开表*/
- (void)openDBTableName:(NSString*)tableName;

/**获取全部*/
- (NSArray *)getAllItemsTableName:(NSString*)tableName;

/**删除全部*/
- (void)deleteAllItemTableName:(NSString*)tableName;

/**保存*/
- (void)saveItem:(NSDictionary *)item key:(NSString*)key tableName:(NSString*)tableName;

/**删除指定的*/
- (void)deleteItemKey:(NSString *)key tableName:(NSString*)tableName;

/**根据指定的*/
- (NSDictionary *)getSelectKey:(NSString*)key tableName:(NSString*)tableName;

@end

NS_ASSUME_NONNULL_END
