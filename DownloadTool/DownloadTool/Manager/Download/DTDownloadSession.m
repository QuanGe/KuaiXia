//
//  DTDownloadSession.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTDownloadSession.h"

@interface DTDownloadSession() <NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSessionDataTask *downloadTask;
@property (nonatomic, strong) NSString       *savePath;             //保存的路径
@property (nonatomic, strong) NSOutputStream *outputStream;         //写数据，用来继续下载

@property (nonatomic, assign) long long      downloadFileSize;      //下载大小
@property (nonatomic, assign) long long      originloadFileSize;    //已经的大小
@property (nonatomic, assign) NSTimeInterval beginTimeStamp;        //开始时间
@property (nonatomic, assign) BOOL           isCancel;              //判断是否是手动取消

@end

@implementation DTDownloadSession

- (id)initWithRequest:(NSURLRequest*)request filePath:(NSString *)path {
    if (self = [super init]) {
        self.savePath = path;
        self.downloadStatus = CONNECTION_WILL_DOWNLOAD;
        self.originloadFileSize = self.downloadFileSize;
        self.downloadFileSize = [self currentFileSize];
        
        //
        NSMutableURLRequest *realRequest = [request mutableCopy];
        NSFileManager* manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:path]){
            long long fileSize = [[manager attributesOfItemAtPath:path error:nil] fileSize];
            if (fileSize > 0) {
                NSString *rangeValue = [NSString stringWithFormat:@"bytes=%lld-", fileSize];
                [realRequest setValue:rangeValue forHTTPHeaderField:@"RANGE"];
            }
        }
        
        //设置session
        NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];

        //创建下载任务
        self.downloadTask = [session dataTaskWithRequest:realRequest];
    }
    return self;
}

- (void)dealloc{
    self.downloadStatus = CONNECTION_DOWNLOAD_COMPLETE;
    if (self.outputStream) {
        [self.outputStream close];
    }
    self.outputStream = nil;
}

#pragma mark - Start & Stop
//开始
- (void)startDownload{
    self.isCancel = NO;
    self.downloadStatus = CONNECTION_WILL_DOWNLOAD;
    [self.downloadTask resume];
}

//取消
- (void)cancelDownload{
    self.isCancel = YES;
    self.downloadStatus = CONNECTION_DOWNLOAD_FAILED;
    
    [self.outputStream close];
    self.outputStream = nil;
    
    [self.downloadTask cancel];
    self.downloadTask = nil;
}


#pragma mark - NSURLSessionDelegate
//请求响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    
    //判断是否在下载列表中
    if (self.downloadStatus != CONNECTION_WILL_DOWNLOAD) {
        completionHandler(NSURLSessionResponseCancel);
        return;
    }
    
    //判读是否有response
    if (response) {
        if (self.outputStream) {
            [self.outputStream close];
            self.outputStream = nil;
        }
        
        //判断返回的文件大小
        long long realFileSize = [self getFileSize:response];
        if (realFileSize < 0) {
            [self cancelDownload];
            
            if ([self.delegate respondsToSelector:@selector(failedDownload:withFileSize:)]) {
                [self.delegate failedDownload:dataTask withFileSize:[self currentFileSize]];
            }
        } else {
            //下载，
            self.downloadStatus = CONNECTION_DOWNLOADING;
            self.outputStream = [NSOutputStream outputStreamToFileAtPath:self.savePath append:YES];
            [self.outputStream open];
            
            //请求成功，返回文件的大小
            if ([self.delegate respondsToSelector:@selector(didReceiveRespond:withRespondSize:)]) {
                [self.delegate didReceiveRespond:dataTask withRespondSize:realFileSize];
            }
            //开始时间
            self.beginTimeStamp = [[NSDate date] timeIntervalSince1970];
        }
    } else {
        //失败，取消
        [self cancelDownload];
        if ([self.delegate respondsToSelector:@selector(failedDownload:withFileSize:)]) {
            [self.delegate failedDownload:dataTask withFileSize:[self currentFileSize]];
        }
        completionHandler(NSURLSessionResponseCancel);
        return;
    }
    
    //
    completionHandler(NSURLSessionResponseAllow);
}

//返回的数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    //判断状态
    if (self.downloadStatus != CONNECTION_DOWNLOADING) {
        return;
    }
    
    //获取时间差
    NSTimeInterval currentTimeStamp = [[NSDate date] timeIntervalSince1970];
    double deltaTime = currentTimeStamp - self.beginTimeStamp;
    if (deltaTime <= 0) {
        deltaTime = 1;
    }
    
    //判断写入的数据
    if (self.outputStream) {
        uint8_t *readBytes = (uint8_t *)[data bytes];
        NSInteger writelength = [self.outputStream write:readBytes maxLength:data.length];
        if (writelength == -1) {
            [self cancelDownload];
        }
    }
    
    //
    if ([self.delegate respondsToSelector:@selector(didReceiveData:withFileSize:withSpeed:)]) {
        self.downloadFileSize += data.length;
        //下载速度
        double downloadSpeed = (self.downloadFileSize - self.originloadFileSize) / (deltaTime * 1024);
        [self.delegate didReceiveData:dataTask withFileSize:[self currentFileSize] withSpeed:downloadSpeed];
    }
}

//完成或失败
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    //判断是否下载失败
    if (error) {
        //手动取消
        if (self.isCancel) {
            return;
        }
        
        //失败
        if ([self.delegate respondsToSelector:@selector(failedDownload:withFileSize:)]) {
            [self.delegate failedDownload:task withFileSize:[self currentFileSize]];
        }
    } else {
        //关闭
        if (self.outputStream) {
            [self.outputStream close];
        }
        self.outputStream = nil;
        
        //判断是否失败
        if (self.downloadStatus == CONNECTION_DOWNLOAD_FAILED) {
            return;
        }
        
        //完成
        self.downloadStatus = CONNECTION_DOWNLOAD_COMPLETE;
        if ([self.delegate respondsToSelector:@selector(didFinishDownload:withFileSize:)]) {
            [self.delegate didFinishDownload:task withFileSize:[self currentFileSize]];
        }
    }
}

#pragma mark - helper
//获取文件的大小
- (long long)getFileSize:(NSURLResponse *)response {
    if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
        return 0;
    }
    NSDictionary *fields = [(NSHTTPURLResponse *)response allHeaderFields];
    if (fields) {
        NSString *lengthString = [fields objectForKey:@"Content-Length"];
        NSString *rangeString = [fields objectForKey:@"Content-Range"];
        if (lengthString) {
            if (!rangeString) {
                return [lengthString longLongValue];
            } else {
                NSArray *rangeStrings = [rangeString componentsSeparatedByString:@"/"];
                if (rangeStrings.count != 2) {
                    return [lengthString longLongValue];
                }
                else {
                    return [rangeStrings[1] longLongValue];
                }
            }
        } else if (rangeString) {
            NSArray *rangeStrings = [rangeString componentsSeparatedByString:@"/"];
            if (rangeStrings.count != 2) {
                return 0;
            }
            else {
                return [rangeStrings[1] longLongValue];
            }
        } else {
            return 0;
        }
    }
    return -1;
}

- (long long)currentFileSize {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:self.savePath]){
        return [[manager attributesOfItemAtPath:self.savePath error:nil] fileSize];
    }
    return 0;
}



@end
