//
//  DTDownloadViewController.m
//  DownloadTool
//
//  Created by wsl on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTDownloadViewController.h"
#import "DTDownloadHandle.h"
#import "DTDownManager.h"

@interface DTDownloadViewController () <DTDownManagerDelegate>

@end

@implementation DTDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"传输";
    
    //
    [DTDownManager shareInstance].delegate = self;
    [DTDownloadHandle startDownList];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [DTDownloadHandle dt_downloadFileWithUrl:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"];
}

#pragma mark - DTDownManagerDelegate
/**开始下载*/
- (void)downloadStarted:(DTDownloadObject *)downloadTask{
    NSLog(@"开始下载");
}
/**下载完成*/
- (void)downloadCompleted:(DTDownloadObject *)downloadTask{
    NSLog(@"下载完成");
}
/**下载失败*/
- (void)downloadFailed:(DTDownloadObject *)downloadTask{
    NSLog(@"下载失败");
}
/**下载暂停*/
- (void)downloadPause:(DTDownloadObject *)downloadTask{
    NSLog(@"下载暂停");
}
/**下载速度*/
- (void)downloading:(DTDownloadObject *)downloadTask withSize:(NSNumber *)receiveDatelength withSpeed:(NSNumber *)speed{
    NSLog(@"下载速度");
    CGFloat downSpeed = [speed doubleValue];
    if(downSpeed > 950){
        downSpeed = downSpeed/1024;
        NSLog(@"下载速度: %.1fM/s", downSpeed);
    } else {
        NSLog(@"下载速度: %.1fk/s", downSpeed);
    }
}

@end
