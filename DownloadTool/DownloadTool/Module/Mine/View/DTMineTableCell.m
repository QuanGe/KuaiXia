//
//  DTMineTableCell.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTMineTableCell.h"

@interface DTMineTableCell()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *textTitleLabel;
@property (nonatomic, strong) UIImageView *rowImgView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation DTMineTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (CGFloat)getMineCellHeight{
    return 55;
}

+ (instancetype)cellMineTableWithTable:(UITableView*)tableView{
    static NSString *CellIdentifier = @"DTMineTableCell";
    DTMineTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DTMineTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    [self.rowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lineView);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(12);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(25);
    }];
    [self.textTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rowImgView.mas_left).offset(-10);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
    }];
}

#pragma mark - Content
- (void)cellTitle:(NSString*)title imgName:(NSString*)imgName{
    self.textTitleLabel.text = title;
    self.iconImageView.image = [UIImage imageNamed:imgName];
}



#pragma mark - Lazy
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

- (UIImageView *)rowImgView{
    if (!_rowImgView) {
        _rowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_12_24_go7"]];
        [self.contentView addSubview:_rowImgView];
    }
    return _rowImgView;
}

- (UILabel *)textTitleLabel{
    if (!_textTitleLabel) {
        _textTitleLabel = [[UILabel alloc] init];
        _textTitleLabel.textColor = [UIColor blackColor];
        _textTitleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_textTitleLabel];
    }
    return _textTitleLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = DTRGB(246, 246, 246);
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}


@end
