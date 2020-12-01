//
//  DTYellContentView.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/12/1.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTYellContentView.h"

@interface DTYellContentView()

@property (nonatomic, strong) UILabel *dateTxtLabel;
@property (nonatomic, strong) UILabel *chineseDateLabel;
@property (nonatomic, strong) UILabel *yiTxtLabel;
@property (nonatomic, strong) UILabel *jiTxtLabel;

@end

@implementation DTYellContentView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setContentViewUI];
    }
    return self;
}

- (void)setContentViewUI{
    [self.dateTxtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(20);
    }];
    [self.chineseDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.dateTxtLabel);
        make.top.equalTo(self.dateTxtLabel.mas_bottom);
    }];
    [self.yiTxtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.dateTxtLabel);
        make.top.equalTo(self.chineseDateLabel.mas_bottom).offset(10);
    }];
    [self.jiTxtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.right.equalTo(self.dateTxtLabel);
        make.top.equalTo(self.yiTxtLabel.mas_bottom).offset(10);
    }];
}

- (void)yellowContentWithDate:(NSString*)selDate chinese:(NSString *)chinseDate yiList:(NSArray*)yiList jiList:(NSArray*)jiList{
    self.dateTxtLabel.text = selDate;
    self.chineseDateLabel.text = [NSString stringWithFormat:@"农历%@", chinseDate];
    self.yiTxtLabel.text = [NSString stringWithFormat:@"宜:%@", [self getTxtContentWithList:yiList]];
    self.jiTxtLabel.text = [NSString stringWithFormat:@"忌:%@", [self getTxtContentWithList:jiList]];
}

- (NSString*)getTxtContentWithList:(NSArray*)list{
    NSMutableString *strM = [NSMutableString string];
    for (NSString *str in list) {
        [strM appendFormat:@" %@", str];
    }
    return strM.copy;
}

#pragma mark - Lazy
- (UILabel *)dateTxtLabel{
    if (!_dateTxtLabel) {
        _dateTxtLabel = [[UILabel alloc] init];
        _dateTxtLabel.textColor = [UIColor grayColor];
        _dateTxtLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_dateTxtLabel];
    }
    return _dateTxtLabel;
}

- (UILabel *)chineseDateLabel{
    if (!_chineseDateLabel) {
        _chineseDateLabel = [[UILabel alloc] init];
        _chineseDateLabel.textColor = [UIColor blackColor];
        _chineseDateLabel.font = [UIFont boldSystemFontOfSize:30];
        [self addSubview:_chineseDateLabel];
    }
    return _chineseDateLabel;
}

- (UILabel *)yiTxtLabel{
    if (!_yiTxtLabel) {
        _yiTxtLabel = [[UILabel alloc] init];
        _yiTxtLabel.textColor = [UIColor blackColor];
        _yiTxtLabel.font = [UIFont systemFontOfSize:16];
        _yiTxtLabel.numberOfLines = 0;
        [self addSubview:_yiTxtLabel];
    }
    return _yiTxtLabel;
}

- (UILabel *)jiTxtLabel{
    if (!_jiTxtLabel) {
        _jiTxtLabel = [[UILabel alloc] init];
        _jiTxtLabel.textColor = [UIColor blackColor];
        _jiTxtLabel.font = [UIFont systemFontOfSize:16];
        _jiTxtLabel.numberOfLines = 0;
        [self addSubview:_jiTxtLabel];
    }
    return _jiTxtLabel;
}

@end
