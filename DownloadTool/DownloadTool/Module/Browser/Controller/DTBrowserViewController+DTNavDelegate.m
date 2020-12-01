//
//  DTBrowserViewController+DTNavDelegate.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/26.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTBrowserViewController+DTNavDelegate.h"
#import "DTHistoryDBHelper.h"

@implementation DTBrowserViewController (DTNavDelegate)

//MARK: - 决定是允许还是取消导航；
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURLRequest *request = navigationAction.request;
    
    NSURL *URL = request.URL;
    NSString *scheme = URL.scheme.lowercaseString;
    
    BOOL isCancel = NO;
    if ([scheme isEqualToString:@"about"]) {
        if ([URL.resourceSpecifier isEqualToString:@"blank"]) {
            isCancel = NO;
        } else if ([URL.resourceSpecifier isEqualToString:@"back"]) {
            isCancel = YES;
        } else if ([URL.resourceSpecifier isEqualToString:@"reload"]) {
            isCancel = YES;
        }

    } else if ([scheme isEqualToString:@"facetime"]) {//禁止facetime
        isCancel = YES;
        
    } else if ([URL.host isEqualToString:@"itunes.apple.com"]) {
        isCancel = YES;
    }
    
    if (isCancel) {
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

//MARK: - 决定在知道响应后是允许还是取消导航；
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}


//MARK: - WebView开始接受web内容时触发
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    
}

//MARK: - 当WebView开始加载Web内容时触发；
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}

//MARK: - 当Web视图收到服务器重定向时调用；
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}

//MARK: - 加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    //历史记录
    if (self.webUrl.absoluteString.length > 0 && self.webTitle.length > 0) {
        [[DTHistoryDBHelper sharedHistoryDB] saveUrl:self.webUrl.absoluteString title:self.webTitle];
    }
}

//MARK: - 当Web视图正在加载内容时发生错误时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.adressView updateAdressProgress:1];
}

//MARK: - 跳转失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.adressView updateAdressProgress:1];
}

//MARK: - web内容处理中断时会触发
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
}

//MARK: - 当Web视图需要响应身份验证询时调用
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}


@end
