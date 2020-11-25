//
//  DTSearchToolView.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTSearchToolView.h"

@interface DTSearchToolView() <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation DTSearchToolView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupToolViewUI];
    }
    return self;
}

- (void)setupToolViewUI{
    self.backgroundColor = [UIColor whiteColor];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-5);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(60);
    }];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.bottom.height.mas_equalTo(self.cancelButton);
        make.right.equalTo(self.cancelButton.mas_left).offset(-15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.searchTextField becomeFirstResponder];
}

#pragma mark - Adress
- (void)setAddressStr:(NSString *)addressStr{
    _addressStr = addressStr;
    self.searchTextField.text = addressStr;
}

#pragma mark - Click
- (void)clickDisInput{
    [self endEditing:YES];
}

//取消
- (void)clickCancelBuutton{
    [self clickDisInput];
    if ([self.delegate respondsToSelector:@selector(cancelInputView:)]) {
        [self.delegate cancelInputView:self];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self clickDisInput];
    if ([self.delegate respondsToSelector:@selector(searchDoneInputText:)]) {
        [self.delegate searchDoneInputText:textField.text];
    }
    return YES;
}



#pragma mark - Lazy
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = DTRGB(246, 246, 246);
        [self addSubview:_lineView];
    }
    return _lineView;
}

- (UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.delegate = self;
        _searchTextField.backgroundColor = kBackViewColor;
        _searchTextField.font = [UIFont systemFontOfSize:15];
        _searchTextField.textColor = [UIColor blackColor];
        _searchTextField.placeholder = @"输入搜索内容或链接";
        _searchTextField.layer.cornerRadius = 17;
        _searchTextField.layer.masksToBounds = YES;
        _searchTextField.layer.borderWidth = 1;
        _searchTextField.returnKeyType = UIReturnKeyGo;
        _searchTextField.layer.borderColor = kBaseColor.CGColor;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.clearButtonMode = UITextFieldViewModeAlways;
        _searchTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [self addSubview:_searchTextField];
    }
    return _searchTextField;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _cancelButton.layer.cornerRadius = 17;
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.layer.borderWidth = 1;
        _cancelButton.layer.borderColor = kBaseColor.CGColor;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:kZIColor forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(clickCancelBuutton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
    }
    return _cancelButton;
}

@end
