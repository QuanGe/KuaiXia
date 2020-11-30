//
//  DTHistoryDBHelper.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/30.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTHistoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DTHistoryDBHelper : NSObject

+ (instancetype)sharedHistoryDB;

/**获取全部*/
- (NSArray *)getAllItems;

/**删除全部*/
- (void)deleteAllItem;

/**保存*/
- (void)saveUrl:(NSString*)url title:(NSString*)title;

/**删除*/
- (void)deleteItem:(DTHistoryModel *)item;

@end

NS_ASSUME_NONNULL_END
