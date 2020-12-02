//
//  DTM3u8Handler.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/12/2.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^M3u8HandleBlack)(NSError *__nullable error, NSArray *__nullable m3u8List);

@interface DTM3u8Handler : NSObject

/**解码M3U8*/
+ (void)praseUrl:(NSString *)urlStr handleBlcok:(M3u8HandleBlack)handleBlock;


/**下载完毕后，把所有的ts合并成一个，文件是m3u8urlMD5地址文件+文件.ts*/
+ (void)combM3u8Url:(NSString*)urlStr m3u8List:(NSArray*)m3u8List;

@end

NS_ASSUME_NONNULL_END
