//
//  DTDownloadHandle.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DTDownloadHandle : NSObject

//下载请求
+ (void)dt_downloadFileWithUrl:(NSString *)url;

//开始下载
+ (void)startDownList;

@end

NS_ASSUME_NONNULL_END
