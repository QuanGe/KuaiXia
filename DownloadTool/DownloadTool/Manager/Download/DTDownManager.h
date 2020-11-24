//
//  DTDownManager.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTDownloadObject.h"

NS_ASSUME_NONNULL_BEGIN

@class DTDownloadModel;
@protocol DTDownManagerDelegate <NSObject>

@optional
/**开始下载*/
- (void)downloadStarted:(DTDownloadObject *)downloadTask;
/**下载完成*/
- (void)downloadCompleted:(DTDownloadObject *)downloadTask;
/**下载失败*/
- (void)downloadFailed:(DTDownloadObject *)downloadTask;
/**下载暂停*/
- (void)downloadPause:(DTDownloadObject *)downloadTask;
/**下载速度*/
- (void)downloading:(DTDownloadObject *)downloadTask withSize:(NSNumber *)receiveDatelength withSpeed:(NSNumber *)speed;

@end

@interface DTDownManager : NSObject

@property (weak, nonatomic) id<DTDownManagerDelegate> delegate;

+ (instancetype)shareInstance;

/**
 *  开始下载
 * @param downloadUrl 下载链接
 * @param fileName 文件名字
 * @param mimeType 文件类型
 * @param cookie 文件Cookie
 */
- (void)startDowload:(NSString *)downloadUrl withSuggestionName:(NSString *)fileName withMIMEType:(NSString *)mimeType cookie:(NSString *)cookie;

/**暂停下载*/
- (void)pauseDownload:(DTDownloadModel *)fileModel;
/**杀死app前，下载列表暂停*/
- (void)pauseDownloadList;


/**根据url判断是否在下载列表中*/
- (BOOL)hasDownload:(NSString *)downloadUrl;
/**根据url去查找下载任务*/
- (DTDownloadObject *)findDownloadObjectByUrl:(NSString *)url;
/**根据url删除任务*/
- (void)removeDownloadTasFile:(NSString *)downloadUrl;

/**移除文件*/
- (void)removeDownloadFile:(NSString *)downloadUrl;
- (void)removeDownloadFile:(NSString *)downloadUrl completion: (void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
