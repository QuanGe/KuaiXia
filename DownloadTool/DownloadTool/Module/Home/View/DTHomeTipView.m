//
//  DTHomeTipView.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/27.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTHomeTipView.h"
#import "DTCommonHelper.h"

@interface DTHomeTipView()

@property (nonatomic, strong) UILabel *dateTextLabel;
@property (nonatomic, strong) UILabel *tipTextLabel;

@end

@implementation DTHomeTipView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupTipViewUI];
    }
    return self;
}

- (void)setupTipViewUI{
    self.backgroundColor = kZIColor;
    
    [self.dateTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self).offset(10);
        make.height.mas_equalTo(25);
    }];
    [self.tipTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.dateTextLabel);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.dateTextLabel.mas_bottom);
    }];
}


#pragma mark - Lazy
- (UILabel *)dateTextLabel{
    if (!_dateTextLabel) {
        _dateTextLabel = [[UILabel alloc] init];
        _dateTextLabel.textColor = [UIColor whiteColor];
        _dateTextLabel.textAlignment = NSTextAlignmentRight;
        _dateTextLabel.font = [UIFont boldSystemFontOfSize:15];
        
        //获取日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyy年MM月dd日"];
        NSString *result = [formatter stringFromDate:[NSDate date]];
        
        _dateTextLabel.text = result;
        
        [self addSubview:_dateTextLabel];
    }
    return _dateTextLabel;
}

- (UILabel *)tipTextLabel{
    if (!_tipTextLabel) {
        _tipTextLabel = [[UILabel alloc] init];
        _tipTextLabel.textColor = [UIColor whiteColor];
        _tipTextLabel.textAlignment = NSTextAlignmentRight;
        _tipTextLabel.font = [UIFont boldSystemFontOfSize:24];
        _tipTextLabel.text = [DTCommonHelper getHellowText];
        [self addSubview:_tipTextLabel];
    }
    return _tipTextLabel;
}

@end
