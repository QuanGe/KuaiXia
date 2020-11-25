//
//  DTSeatchHistoryDBHelper.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTSeatchHistoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DTSeatchHistoryDBHelper : NSObject

+ (instancetype)sharedDB;

/**获取全部*/
- (NSArray *)getAllItems;

/**删除全部*/
- (void)deleteAllItem;

/**保存*/
- (void)saveItem:(DTSeatchHistoryModel *)item;

/**删除*/
- (void)deleteItem:(DTSeatchHistoryModel *)item;

@end

NS_ASSUME_NONNULL_END
