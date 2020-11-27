//
//  DTWebView.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTWebView.h"

@implementation DTWebView

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration{
    if (self = [super initWithFrame:frame configuration:configuration]) {
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        self.allowsBackForwardNavigationGestures = YES;
    }
    return self;
}

@end
