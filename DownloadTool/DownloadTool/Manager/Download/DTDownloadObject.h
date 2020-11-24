//
//  DTDownloadObject.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTDownloadModel.h"

NS_ASSUME_NONNULL_BEGIN

@class DTDownManager;
@interface DTDownloadObject : NSObject

@property (nonatomic, readonly) WWSLDownLoadStatus downloadStatus;  //下载状态
@property (nonatomic, strong  ) NSString          *fileName;        //文件名字
@property (nonatomic, strong  ) NSString          *downloadUrl;     //下载url

/**
 * @param url 下载url
 * @param fileName 文件名字
 * @param mimeType  文件类型
 * @param cookie  cookie
 * @param manager 下载manager
 * @param completion 回调
 */
- (id)initWithUrl:(NSString *)url withSuggestionName:(NSString *)fileName withMIMEType:(NSString *)mimeType cookie:(NSString *)cookie manager:(DTDownManager *)manager completion:(dispatch_block_t)completion;

/**开始下载*/
- (void)startDownload;
/**暂停下载*/
- (void)pauseDownload;

@end

NS_ASSUME_NONNULL_END
