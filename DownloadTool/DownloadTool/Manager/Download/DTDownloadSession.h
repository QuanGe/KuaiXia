//
//  DTDownloadSession.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, DOWNLOADSTATUS) {
    CONNECTION_WILL_DOWNLOAD = 0,       //将要开始
    CONNECTION_DOWNLOADING,             //下载中
    CONNECTION_DOWNLOAD_COMPLETE,       //完成
    CONNECTION_DOWNLOAD_FAILED          //失败
};

@class DTDownloadSession;
@protocol DTDownloadSessionDelegate <NSObject>

@optional
/**请求结果*/
- (void)didReceiveRespond:(NSURLSessionDataTask*)task withRespondSize:(long long)fileSize;
/**返回数据*/
- (void)didReceiveData:(NSURLSessionDataTask*)task withFileSize:(long long)fileSize withSpeed:(double)speed;
/**下载完成*/
- (void)didFinishDownload:(NSURLSessionTask*)task withFileSize:(long long)fileSize;
/**下载失败*/
- (void)failedDownload:(NSURLSessionTask*)task withFileSize:(long long)fileSize;

@end

@interface DTDownloadSession : NSObject

@property (nonatomic, weak)   id<DTDownloadSessionDelegate> delegate;
@property (assign, nonatomic) DOWNLOADSTATUS downloadStatus;

/**
 请求， 文件保存路径
 */
- (id)initWithRequest:(NSURLRequest*)request filePath:(NSString *)path;

/**
 当前文件大小
 */
- (long long)currentFileSize;

/**开始*/
- (void)startDownload;

/**取消*/
- (void)cancelDownload;

@end

NS_ASSUME_NONNULL_END
