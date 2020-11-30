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
#import "DTHistoryViewController.h"
#import "DTNavigationController.h"
#import <Photos/Photos.h>
#import "DTProgressHUDHelper.h"

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

//菜单->历史记录
- (void)tabMenuTab:(DTBrowserTabView *)tabView{
    DTHistoryViewController *historyVC = [[DTHistoryViewController alloc] init];
    
    __weak __typeof(self) weakSelf = self;
    historyVC.selHistoryBlock = ^(NSString * _Nonnull url) {
        [weakSelf openUrl:url];
    };
    
    DTNavigationController *navVC = [[DTNavigationController alloc] initWithRootViewController:historyVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

//web页截图
- (void)tabScreenTab:(DTBrowserTabView *)tabView{
//    [DTProgressHUDHelper show];
//    __weak __typeof(self) weakSelf = self;
//    [self.webDTView snapContentWithCompletion:^(UIImage * _Nonnull snapImg) {
//        [weakSelf saveScreenImage:snapImg];
//    }];
}

//保存图片
- (void)saveScreenImage:(UIImage *)image{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(completedWithImage:error:context:), NULL);
}

- (void)completedWithImage:(UIImage *)image error:(NSError *)error context:(void *)contextInfo{
    [DTProgressHUDHelper dissMiss];
    NSString *toast = (!image || error)? [NSString stringWithFormat:@"保存图片失败 , 错误：%@",error] : @"保存图片成功";
    NSLog(@"%@",toast);
    [DTProgressHUDHelper showMessage:toast];
}

@end
