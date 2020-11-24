//
//  DTDownListTableCell.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTDownListTableCell.h"

@interface DTDownListTableCell()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *textTitleLabel;
@property (nonatomic, strong) UILabel *dateTextLabel;
@property (nonatomic, strong) UILabel *sizeTextLabel;

@end

@implementation DTDownListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getListCellHeight{
    return 70;;
}

+ (instancetype)cellListTableWithTable:(UITableView*)tableView{
    static NSString *CellIdentifier = @"DTDownListTableCell";
    DTDownListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DTDownListTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupCellViewUI];
    }
    return self;
}

- (void)setupCellViewUI{
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}



#pragma mark - Lazy
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = DTRGB(246, 246, 246);
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

@end
