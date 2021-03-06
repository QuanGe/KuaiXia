//
//  DTDownInputController.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTDownInputController.h"
#import "DTTextView.h"
#import "DTDownloadHandle.h"
#import "DTGetVideoUrlHandle.h"

@interface DTDownInputController ()

@property (nonatomic, strong) DTTextView *inputTextView;
@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) UIButton *webButton;

@end

@implementation DTDownInputController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"创建下载";
    
    [self setupViewUI];
}

- (void)setupViewUI{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(clickCloseButton)];
    
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(200);
    }];
    [self.webButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputTextView);
        make.top.equalTo(self.inputTextView.mas_bottom).offset(20);
        make.height.mas_equalTo(48);
    }];
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.inputTextView);
        make.width.height.top.equalTo(self.webButton);
        make.left.equalTo(self.webButton.mas_right).offset(40);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark - Click
- (void)clickCloseButton{
    if (self.inputBlock) {
        self.inputBlock();
    }
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//下载
- (void)clickDownloadButton{
    [self.view endEditing:YES];
    [self startDownloadWithUrl:self.inputTextView.text];
}

//根据连接获取地址
- (void)clickWebButton{
    [self.view endEditing:YES];
    if (self.inputTextView.text.length == 0) {
        [DTProgressHUDHelper showMessage:@"地址不可为空"];
        return;
    }
    
    [DTProgressHUDHelper show];
    
    __weak __typeof(self) weakSelf = self;
    [[DTGetVideoUrlHandle shared] getVideoUrlWithUrl:self.inputTextView.text completaion:^(NSString * _Nullable videoUrl) {
        [DTProgressHUDHelper dissMiss];
        
        if (videoUrl.length == 0) {
            [DTProgressHUDHelper showMessage:@"没有找到资源"];
        } else {
            weakSelf.inputTextView.text = videoUrl;
            [DTProgressHUDHelper showMessage:@"资源已找到"];
        }
    }];
}


#pragma mark - Download
- (void)startDownloadWithUrl:(NSString*)url{
    if (url.length == 0) {
        [DTProgressHUDHelper showMessage:@"地址不可为空"];
        return;
    }
    
    [DTProgressHUDHelper show];
    
    
    [DTDownloadHandle dt_downloadFileWithUrl:url block:^(NSString * _Nullable message) {
        [DTProgressHUDHelper dissMiss];
        [DTProgressHUDHelper showMessage:message];
    }];
}





#pragma mark - lazy
- (DTTextView *)inputTextView{
    if (!_inputTextView) {
        _inputTextView = [[DTTextView alloc] init];
        _inputTextView.placeholder = @"请输入下载链接";
        _inputTextView.placeColor = DTRGB(163, 166, 177);
        _inputTextView.backgroundColor = DTRGB(236, 236, 236);
        _inputTextView.layer.cornerRadius = 10;
        _inputTextView.layer.masksToBounds = YES;
        _inputTextView.layer.borderColor = kBaseColor.CGColor;
        _inputTextView.layer.borderWidth = 0.5;
        _inputTextView.keyboardType = UIKeyboardTypeURL;
        [self.view addSubview:_inputTextView];
    }
    return _inputTextView;
}

- (UIButton *)downloadButton{
    if (!_downloadButton) {
        _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _downloadButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _downloadButton.backgroundColor = kBaseColor;
        _downloadButton.layer.cornerRadius = 24;
        _downloadButton.layer.masksToBounds = YES;
        [_downloadButton setTitle:@"开始下载" forState:UIControlStateNormal];
        [_downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_downloadButton addTarget:self action:@selector(clickDownloadButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_downloadButton];
    }
    return _downloadButton;
}

- (UIButton *)webButton{
    if (!_webButton) {
        _webButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _webButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _webButton.backgroundColor = kBaseColor;
        _webButton.layer.cornerRadius = 24;
        _webButton.layer.masksToBounds = YES;
        [_webButton setTitle:@"资源嗅探" forState:UIControlStateNormal];
        [_webButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_webButton addTarget:self action:@selector(clickWebButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_webButton];
    }
    return _webButton;
}


@end
