//
//  DTHTTPDownManager.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTHTTPDownManager.h"

@interface DTHTTPDownManager() <NSURLSessionDelegate>

@end

@implementation DTHTTPDownManager

+ (instancetype)shareInstance{
    static DTHTTPDownManager *_manager = nil;
    static dispatch_once_t __onceToken;
    dispatch_once(&__onceToken, ^{
        _manager = [[DTHTTPDownManager alloc] init];
    });
    return _manager;
}

//head请求
- (NSURLSessionDataTask *)headRequestWithUrl:(NSString*)url complation:(SessionDownBlack)complation{
    
     NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
     configuration.connectionProxyDictionary = @{};
     
     NSOperationQueue *queue = [[NSOperationQueue alloc] init];
     queue.maxConcurrentOperationCount = 10;
     
     //
     NSURLSession *sessionManager = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:queue];
     
     //
     NSMutableURLRequest *requestM = [[NSMutableURLRequest alloc] init];
     [requestM setURL:[NSURL URLWithString:url]];
     [requestM setHTTPMethod:@"HEAD"];
     requestM.timeoutInterval = 15;
     
     //request
     NSURLSessionDataTask *task = [sessionManager dataTaskWithRequest:requestM completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         if (complation) {
             complation(error, data, response);
         }
     }];
     [task resume];
     
     return task;
}


@end
