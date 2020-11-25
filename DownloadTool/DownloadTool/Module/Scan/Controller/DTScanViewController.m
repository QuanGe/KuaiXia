//
//  DTScanViewController.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTScanViewController.h"

@interface DTScanViewController ()

@property (nonatomic, strong) UILabel *textTitleLabel;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation DTScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupScanViewUI];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)setupScanViewUI{
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view).offset(LL_SafeAreaTopStatusBar + 10);
        make.width.height.mas_equalTo(25);
    }];
    [self.textTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.closeButton.mas_left);
        make.centerY.equalTo(self.closeButton);
    }];
}

- (void)clickCloseButton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Lazy
- (UILabel *)textTitleLabel{
    if (!_textTitleLabel) {
        _textTitleLabel = [[UILabel alloc] init];
        _textTitleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        _textTitleLabel.textColor = [UIColor whiteColor];
        _textTitleLabel.text = @"扫一扫";
        _textTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_textTitleLabel];
    }
    return _textTitleLabel;
}

- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"scan_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(clickCloseButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_closeButton];
    }
    return _closeButton;
}


@end
