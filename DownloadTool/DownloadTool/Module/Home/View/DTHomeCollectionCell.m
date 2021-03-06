//
//  DTHomeCollectionCell.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/27.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTHomeCollectionCell.h"

@interface DTHomeCollectionCell()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *textTitleLabel;

@end

@implementation DTHomeCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setCollectionViewUI];
    }
    return self;
}

- (void)setCollectionViewUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.masksToBounds = YES;
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.width.height.mas_equalTo(40);
    }];
    [self.textTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.iconImageView);
    }];
}



#pragma mark - Lazy
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _iconImageView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

- (UILabel *)textTitleLabel{
    if (!_textTitleLabel) {
        _textTitleLabel = [[UILabel alloc] init];
        _textTitleLabel.textColor = [UIColor blackColor];
        _textTitleLabel.textAlignment = NSTextAlignmentLeft;
        _textTitleLabel.font = [UIFont systemFontOfSize:15];
        _textTitleLabel.text = @"标题";
        [self.contentView addSubview:_textTitleLabel];
    }
    return _textTitleLabel;
}

@end
