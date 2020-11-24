//
//  AppDelegate+DTHUD.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "AppDelegate+DTHUD.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation AppDelegate (DTHUD)

- (void)setupHUD{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:DTRGB(90, 153, 237)];
    [SVProgressHUD setImageViewSize:CGSizeZero];
}

@end
