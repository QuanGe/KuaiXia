//
//  DTHomeViewController.m
//  DownloadTool
//
//  Created by wsl on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTHomeViewController.h"

@interface DTHomeViewController ()

@end

@implementation DTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"首页";
    
    [self setupViewUI];
}

- (void)setupViewUI{
    self.navigationItem.leftBarButtonItem = nil;
    
}

@end
