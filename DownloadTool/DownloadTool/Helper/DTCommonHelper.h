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

/**时间戳转时间*/
+ (NSString *)convertStrToTime:(int64_t)timeVal;

/**根据路径获取文件大小*/
+ (CGFloat)getFileSizeWithFilePath:(NSString*)filePath;

/**获取数字的MB,GB,KB*/
+ (NSString *)getContentSizeWithTotalSize:(CGFloat)totalSize;

/**下载文件夹路径*/
+ (NSString *)hasHideDBFile;

/**判断是否为url*/
+ (BOOL)isUrl:(NSString*)url;

/**根据时间获取问候*/
+ (NSString *)getHellowText;

@end

NS_ASSUME_NONNULL_END
