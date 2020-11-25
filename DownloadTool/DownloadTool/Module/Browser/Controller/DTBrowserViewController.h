//
//  DTBrowserViewController.h
//  DownloadTool
//
//  Created by wsl on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTBaseViewController.h"
#import "DTWebView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DTBrowserViewController : DTBaseViewController

@property (nonatomic, strong) DTWebView *webView;

@property (nonatomic, copy) NSString *webTitle;    //标题
@property (nonatomic, copy) NSURL *webUrl;      //连接

- (void)openUrl:(NSString*)url;

@end

NS_ASSUME_NONNULL_END
