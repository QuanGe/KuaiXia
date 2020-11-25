//
//  DTBrowserAdressView.m
//  DownloadTool
//
//  Created by WSL on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTBrowserAdressView.h"

@interface DTBrowserAdressView()

@property (nonatomic, strong) UIView *backMaskView;
@property (nonatomic, strong) UIButton *backMaskButton;
@property (nonatomic, strong) UIButton *refreshOrStopButton;
@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UIButton *backPopButton; //返回按钮

@end

@implementation DTBrowserAdressView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupViewUI];
    }
    return self;
}

- (void)setupViewUI{
    self.backgroundColor = [UIColor whiteColor];
    [self.backPopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(50);
    }];
    [self.backMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.height.bottom.equalTo(self.backPopButton);
        make.left.equalTo(self.backPopButton.mas_right).offset(15);
    }];
    [self.refreshOrStopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backMaskView).offset(-10);
        make.top.bottom.equalTo(self.backMaskView);
        make.width.mas_equalTo(30);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backMaskView).offset(10);
        make.right.equalTo(self.refreshOrStopButton.mas_left).offset(-10);
        make.centerY.equalTo(self.backMaskView);
    }];
}

#pragma mark - Content



#pragma mark - Click
//返回
- (void)clickBackPopButton{
    if ([self.delegate respondsToSelector:@selector(didBackButtonView:)]) {
        [self.delegate didBackButtonView:self];
    }
}
//地址
- (void)clickBackMaskButton{
    if ([self.delegate respondsToSelector:@selector(didAdressButtonView:)]) {
        [self.delegate didAdressButtonView:self];
    }
}
//刷新
- (void)clickRefreshStopButton{
    if ([self.delegate respondsToSelector:@selector(didRefreshButtonView:)]) {
        [self.delegate didRefreshButtonView:self];
    }
}

#pragma mark - Lazy
- (UIButton *)backPopButton{
    if (!_backPopButton) {
        _backPopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backPopButton.layer.cornerRadius = 15;
        _backPopButton.layer.masksToBounds = YES;
        _backPopButton.layer.borderColor = kBaseColor.CGColor;
        _backPopButton.layer.borderWidth = 1;
        _backPopButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_backPopButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backPopButton setTitleColor:kZIColor forState:UIControlStateNormal];
        [_backPopButton addTarget:self action:@selector(clickBackPopButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backPopButton];
    }
    return _backPopButton;
}

- (UIView *)backMaskView{
    if (!_backMaskView) {
        _backMaskView = [[UIView alloc] init];
        _backMaskView.backgroundColor = kBackViewColor;
        _backMaskView.layer.cornerRadius = 15;
        _backMaskView.layer.masksToBounds = YES;
        _backMaskView.layer.borderColor = kBaseColor.CGColor;
        _backMaskView.layer.borderWidth = 1;
        [self addSubview:_backMaskView];
    }
    return _backMaskView;
}

- (UIButton *)backMaskButton{
    if (!_backMaskButton) {
        _backMaskButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backMaskButton addTarget:self action:@selector(clickBackMaskButton) forControlEvents:UIControlEventTouchUpInside];
        [self.backMaskView addSubview:_backMaskButton];
        
    }
    return _backMaskButton;
}

- (UIButton *)refreshOrStopButton{
    if (!_refreshOrStopButton) {
        _refreshOrStopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshOrStopButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_refreshOrStopButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [_refreshOrStopButton addTarget:self action:@selector(clickRefreshStopButton) forControlEvents:UIControlEventTouchUpInside];
        [self.backMaskView addSubview:_refreshOrStopButton];
    }
    return _refreshOrStopButton;
}

- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = [UIColor blackColor];
        _addressLabel.font = [UIFont systemFontOfSize:13];
        [self.backMaskView addSubview:_addressLabel];
    }
    return _addressLabel;
}

@end
