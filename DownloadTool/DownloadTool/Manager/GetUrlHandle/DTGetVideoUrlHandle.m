//
//  DTGetVideoUrlHandle.m
//  DownloadTool
//
//  Created by wsl on 2020/11/23.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTGetVideoUrlHandle.h"
#import <WebKit/WebKit.h>

static NSString *khandleVideoInfo = @"handleVideoInfo";

@interface DTGetVideoUrlHandle() <WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *contentWebView;
@property (nonatomic, copy)   CompletaionBlack getBlock;

@end

@implementation DTGetVideoUrlHandle

+ (instancetype)shared{
    static DTGetVideoUrlHandle *_handle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _handle = [[DTGetVideoUrlHandle alloc] init];
    });
    return _handle;
}

- (void)getVideoUrlWithUrl:(NSString*)url completaion:(CompletaionBlack)completaion{
    self.getBlock = completaion;
    
    [self.contentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSString *name = message.name;
    
    //获取视频
    if ([name isEqualToString:khandleVideoInfo]) {
        if (self.getBlock) {
            self.getBlock(message.body);
        }
    }
}


#pragma mark - Lazy
- (WKWebView *)contentWebView{
    if (!_contentWebView) {
        //js发送消息
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        [userContentController addScriptMessageHandler:self name:@"handleVideoInfo"];
        
        // js注入，
        /*
         setInterval    循环开始
         clearInterval  停止
         */
        NSString *javaScriptSource = @"var interval;\
        function videoAddListenerFB() {\
            var obj = document.querySelector('video');\
            window.webkit.messageHandlers.handleVideoInfo.postMessage(obj.src);\
            clearInterval(interval);\
        }\
        interval = setInterval('videoAddListenerFB()', 400);";
        WKUserScript *userScript = [[WKUserScript alloc] initWithSource:javaScriptSource injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [userContentController addUserScript:userScript];
        
        // WKWebView的配置
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
        
        _contentWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _contentWebView.UIDelegate = self;
    }
    return _contentWebView;
}


@end
