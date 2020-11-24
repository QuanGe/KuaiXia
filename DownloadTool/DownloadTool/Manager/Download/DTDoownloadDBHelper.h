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

+ (instancetype)sharedDB;

//获取全部
- (NSArray *)getAllItems;
//删除全部
- (void)deleteAllItem;
//保存
- (void)saveItem:(DTDownloadModel *)item;
//删除
- (void)deleteItem:(DTDownloadModel *)item;
//获取制定的
- (DTDownloadModel*)getSelModelUrl:(NSString*)downmodelUrl;

@end

NS_ASSUME_NONNULL_END
