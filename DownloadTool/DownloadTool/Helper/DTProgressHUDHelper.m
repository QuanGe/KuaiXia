//
//  DTProgressHUDHelper.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTProgressHUDHelper.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation DTProgressHUDHelper

+ (void)show{
    [SVProgressHUD show];
}

+ (void)dissMiss{
    [SVProgressHUD dismiss];
}

+ (void)showMessage:(NSString*)message{
    [DTProgressHUDHelper showMessage:message time:1];
}

+ (void)showLongMessage:(NSString*)message{
    [DTProgressHUDHelper showMessage:message time:3];
}

+ (void)showMessage:(NSString*)message time:(CGFloat)time{
    [SVProgressHUD showSuccessWithStatus:message];
    [SVProgressHUD dismissWithDelay:time];
}

@end
