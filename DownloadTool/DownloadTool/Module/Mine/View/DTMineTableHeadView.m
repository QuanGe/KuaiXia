//
//  DTMineTableHeadView.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/27.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTMineTableHeadView.h"

@interface DTMineTableHeadView()

@property (nonatomic, strong) UILabel *textTitleLabel;

@end

@implementation DTMineTableHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupHeadViewUI];
    }
    return self;
}

- (void)setupHeadViewUI{
    [self.textTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-10);
    }];
}

- (void)setText:(NSString *)text{
    _text = text;
    self.textTitleLabel.text = text;
}

#pragma mark - Lazy
- (UILabel *)textTitleLabel{
    if (!_textTitleLabel) {
        _textTitleLabel = [[UILabel alloc] init];
        _textTitleLabel.textColor = [UIColor blackColor];
        _textTitleLabel.font = [UIFont boldSystemFontOfSize:25];
        [self addSubview:_textTitleLabel];
    }
    return _textTitleLabel;
}


@end
