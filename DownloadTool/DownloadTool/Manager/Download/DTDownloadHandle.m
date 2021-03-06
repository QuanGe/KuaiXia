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
#import "DTGetVideoUrlHandle.h"

@implementation DTDownloadHandle

- (void)dealloc{
    NSLog(@"DTDownloadHandle ==> DTDownloadHandle");
}

//下载请求
+ (void)dt_downloadFileWithUrl:(NSString *)url block:(HandleBlack)block{
    if (url.length == 0) {
        if (block) {
            block(@"地址错误,请查看地址是否正确");
        }
        return;
    }
    
    //是否下载中
    if ([[DTDownManager shareInstance] hasDownload:url]) {
        if (block) {
            block(@"文件在下载列表中");
        }
        return;
    }
    
    //
    [[DTHTTPDownManager shareInstance] headRequestWithUrl:url complation:^(NSError * _Nullable error, id  _Nullable responseObject, NSURLResponse * _Nullable response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (block) {
                    block(@"下载失败,请查看地址是否正确");
                }
            } else {
                //开始下载
                [DTDownloadHandle doneDownloadWithUrl:url response:response block:block];
                
//                //判断类型
//                NSString *mimeType = [response MIMEType];
//                if ([[DTDownloadHandle dt_downloadMIMETypes] containsObject:mimeType]) {
//                    [DTDownloadHandle doneDownloadWithUrl:url response:response];
//
//                    if (block) {
//                        block(@"开始下载");
//                    }
//                } else {
//                    //不是下载链接
//                    if (block) {
//                        block(@"地址错误");
//                    }
//                }
            }
        });
    }];
}

//是下载链接
+ (void)doneDownloadWithUrl:(NSString*)url response:(NSURLResponse*)response block:(HandleBlack)block{
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
    NSString *msg = @"";
    if (obj.downloadStatus == DTWSLDownLoad_Loading) {
        msg = @"文件正在下载";
    } else {
        msg = [NSString stringWithFormat:@"%@-开始下载", fileName];
        [[DTDownManager shareInstance] startDowload:url withSuggestionName:fileName withMIMEType:mimeType cookie:cookieStr];
    }
    //回调
    if (block) {
        block(msg);
    }
}



#pragma mark - Helper
+ (NSArray *)dt_downloadMIMETypes {
    NSArray *downloadMIMETypes = nil;
    if (!downloadMIMETypes) {
        downloadMIMETypes = @[
            // 压缩文档
            @"application/x-rar-compressed",
            @"application/x-zip-compressed",
            @"application/epub+zip",
            @"application/zip",
            @"application/rar",
            @"application/x-compress",
            @"application/x-gzip",
            @"application/x-gtar",
            @"application/x-tar",
            // 数字证书
            @"application/x-x509-ca-cert",
            //其他二进制文档
            @"application/octet-stream",
            // WAP 媒体文档
            @"application/iphone-package-archive",
            @"application/vnd.android.package-archive",
            @"application/vnd.cab-com-archive",
            @"application/x-silverlight-app",
            @"application/vnd.symbian.install-archive",
            @"application/vnd.symbian.epoc/x-sisx-app",
            @"video/mp4",
        ];
    }
    
    return downloadMIMETypes;
}




//开始下载
+ (void)startDownList{
    NSArray *list = [[DTDoownloadDBHelper sharedDownDB] getAllItems];
    for (DTDownloadModel *model in list) {
        if (model.downloadStatus != DTWSLDownLoad_Complete) {
            NSLog(@"开始下载: %@", model.downloadFileName);
            [[DTDownManager shareInstance] startDowload:model.downloadUrl withSuggestionName:model.downloadFileName withMIMEType:model.downloadType cookie:model.downloadCookie];
        }
    }
}

@end
