//
//  DTHomeSearchView.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTHomeSearchView.h"

@interface DTHomeSearchView()

@property (nonatomic, strong) UIView *searchMaskView;
@property (nonatomic, strong) UIImageView *searchImgView;
@property (nonatomic, strong) UILabel *searchTxtLabel;
@property (nonatomic, strong) UIButton *searMaskButton;
@property (nonatomic, strong) UIButton *scanButton;

@end

@implementation DTHomeSearchView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupViewUI];
    }
    return self;
}

- (void)setupViewUI{
    self.backgroundColor = [UIColor whiteColor];
    [self.scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.width.height.mas_equalTo(35);
        make.bottom.equalTo(self).offset(-5);
    }];
    [self.searchMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.height.centerY.equalTo(self.scanButton);
        make.right.equalTo(self.scanButton.mas_left).offset(-20);
    }];
    [self.searchImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchMaskView).offset(10);
        make.centerY.equalTo(self.searchMaskView);
        make.width.height.mas_equalTo(16);
    }];
    [self.searchTxtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchImgView.mas_right).offset(10);
        make.right.equalTo(self.searchMaskView).offset(-10);
        make.centerY.equalTo(self.searchImgView);
    }];
    [self.searMaskButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.searchMaskView);
    }];
}

#pragma mark - Click
//搜索
- (void)clickSearMaskButton{
    if (self.clickSearchBlock) {
        self.clickSearchBlock();
    }
}
//二维码
- (void)clickScanButton{
    if (self.clickScanBlock) {
        self.clickScanBlock();
    }
}

#pragma mark - Lazy
- (UIView *)searchMaskView{
    if (!_searchMaskView) {
        _searchMaskView = [[UIView alloc] init];
        _searchMaskView.layer.cornerRadius = 17;
        _searchMaskView.layer.masksToBounds = YES;
        _searchMaskView.layer.borderColor = kBaseColor.CGColor;
        _searchMaskView.layer.borderWidth = 1;
        _searchMaskView.backgroundColor = kBackViewColor;
        [self addSubview:_searchMaskView];
    }
    return _searchMaskView;
}

- (UIImageView *)searchImgView{
    if (!_searchImgView) {
        _searchImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_search"]];
        [self.searchMaskView addSubview:_searchImgView];
    }
    return _searchImgView;
}

- (UILabel *)searchTxtLabel{
    if (!_searchTxtLabel) {
        _searchTxtLabel = [[UILabel alloc] init];
        _searchTxtLabel.font = [UIFont systemFontOfSize:13];
        _searchTxtLabel.textColor = [UIColor blackColor];
        _searchTxtLabel.text = @"搜索或输入网址";
        [self.searchMaskView addSubview:_searchTxtLabel];
    }
    return _searchTxtLabel;
}

- (UIButton *)scanButton{
    if (!_scanButton) {
        _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanButton setImage:[UIImage imageNamed:@"home_scan"] forState:UIControlStateNormal];
        [_scanButton addTarget:self action:@selector(clickScanButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_scanButton];
    }
    return _scanButton;
}

- (UIButton *)searMaskButton{
    if (!_searMaskButton) {
        _searMaskButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searMaskButton addTarget:self action:@selector(clickSearMaskButton) forControlEvents:UIControlEventTouchUpInside];
        [self.searchMaskView addSubview:_searMaskButton];
    }
    return _searMaskButton;
}

@end
