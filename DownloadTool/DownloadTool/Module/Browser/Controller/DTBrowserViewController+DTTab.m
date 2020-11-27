//
//  DTBrowserViewController+DTTab.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/26.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTBrowserViewController+DTTab.h"
#import "DTMenuViewController.h"
#import "DTMoreTabViewController.h"

@implementation DTBrowserViewController (DTTab)

//后退
- (void)tabLeftTab:(DTBrowserTabView *)tabView{
    if ([self.webDTView canGoBack]) {
        [self.webDTView goBack];
    }
}

//前进
- (void)tabRightTab:(DTBrowserTabView *)tabView{
    if ([self.webDTView canGoForward]) {
        [self.webDTView goForward];
    }
}

//首页
- (void)tabHomeTab:(DTBrowserTabView *)tabView{
    NSLog(@"tabHomeTab");
}

//多标签
- (void)tabMoreTab:(DTBrowserTabView *)tabView{
    DTMoreTabViewController *tabVC = [[DTMoreTabViewController alloc] init];
    tabVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:tabVC animated:YES completion:nil];
}

//菜单
- (void)tabMenuTab:(DTBrowserTabView *)tabView{
    DTMenuViewController *menuVC = [[DTMenuViewController alloc] init];
    [self presentViewController:menuVC animated:YES completion:nil];
}

@end
