//
//  DTDoownloadDBHelper.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTDownloadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DTDoownloadDBHelper : NSObject

+ (instancetype)sharedDownDB;

/**获取全部*/
- (NSArray *)getAllItems;
/**获取下载完的*/
- (NSArray *)getSucessItems;
/**获取非下载完的*/
- (NSArray *)getLoadingItems;
/**删除全部*/
- (void)deleteAllItem;
/**保存*/
- (void)saveItem:(DTDownloadModel *)item;
/**删除*/
- (void)deleteItem:(DTDownloadModel *)item;
/**根据url获取model*/
- (DTDownloadModel*)getSelModelUrl:(NSString*)downmodelUrl;

@end

NS_ASSUME_NONNULL_END
