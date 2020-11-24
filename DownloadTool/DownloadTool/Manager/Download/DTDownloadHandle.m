//
//  DTDownloadHandle.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTDownloadHandle.h"
#import "DTHTTPDownManager.h"
#import "DTDownManager.h"
#import "DTDoownloadDBHelper.h"

@implementation DTDownloadHandle

- (void)dealloc{
    NSLog(@"DTDownloadHandle ==> DTDownloadHandle");
}

//下载请求
+ (void)dt_downloadFileWithUrl:(NSString *)url{
    if (url.length == 0) {
        return;
    }
    
    //是否下载中
    if ([[DTDownManager shareInstance] hasDownload:url]) {
        NSLog(@"文件在下载列表中");
        return;
    }
    
    //
    [[DTHTTPDownManager shareInstance] headRequestWithUrl:url complation:^(NSError * _Nullable error, id  _Nullable responseObject, NSURLResponse * _Nullable response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"下载失败");
            } else {
                //从response中获取
                NSString *mimeType = [response MIMEType];
                
                //cookie
                NSURL *URL = [NSURL URLWithString:url];
                NSMutableString *cookieStr = [[NSMutableString alloc] init];
                for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:URL]) {
                    [cookieStr appendFormat:@"%@=%@;", cookie.name, cookie.value];
                }
                
                //获取文件的名字
                NSString *fileName = [response suggestedFilename];
                const char *byte = NULL;
                byte = [fileName cStringUsingEncoding:NSISOLatin1StringEncoding];
                if(byte){
                    fileName = [[NSString alloc] initWithCString:byte encoding: NSUTF8StringEncoding];
                }
                fileName = [fileName stringByRemovingPercentEncoding];
                
                //判断是否下载
                DTDownloadObject *obj = [[DTDownManager shareInstance] findDownloadObjectByUrl:url];
                if (obj.downloadStatus == WWSLDownLoad_Loading) {
                    NSLog(@"文件正在下载");
                } else {
                    NSLog(@"%@-开始下载", fileName);
                    [[DTDownManager shareInstance] startDowload:url withSuggestionName:fileName withMIMEType:mimeType cookie:cookieStr];
                }
            }
        });
    }];
}

//开始下载
+ (void)startDownList{
    NSArray *list = [[DTDoownloadDBHelper sharedDB] getAllItems];
    for (DTDownloadModel *model in list) {
        if (model.downloadStatus != WWSLDownLoad_Complete) {
            NSLog(@"开始下载: %@", model.downloadFileName);
            [[DTDownManager shareInstance] startDowload:model.downloadUrl withSuggestionName:model.downloadFileName withMIMEType:model.downloadType cookie:model.downloadCookie];
        }
    }
}

@end
