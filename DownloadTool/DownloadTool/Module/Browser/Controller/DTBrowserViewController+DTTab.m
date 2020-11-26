//
//  DTBrowserViewController+DTTab.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/26.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTBrowserViewController+DTTab.h"

@implementation DTBrowserViewController (DTTab)

- (void)tabLeftTab:(DTBrowserTabView *)tabView{
    NSLog(@"tabLeftTab");
}

- (void)tabRightTab:(DTBrowserTabView *)tabView{
    NSLog(@"tabRightTab");
}

- (void)tabHomeTab:(DTBrowserTabView *)tabView{
    NSLog(@"tabHomeTab");
}

- (void)tabMoreTab:(DTBrowserTabView *)tabView{
    NSLog(@"tabMoreTab");
}

- (void)tabMenuTab:(DTBrowserTabView *)tabView{
    NSLog(@"tabMenuTab");
}

@end
