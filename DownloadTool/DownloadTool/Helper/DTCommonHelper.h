//
//  DTCommonHelper.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DTCommonHelper : NSObject

/**根据url 获取临时文件的路径*/
+ (NSString *)getTempFilepathWithUrl:(NSString*)url;

/**根据url 获取保存文件的路径 */
+ (NSString *)getSaveFilepathWithUrl:(NSString*)url;


@end

NS_ASSUME_NONNULL_END
