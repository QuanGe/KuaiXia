//
//  DTHistoryTableViewCell.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/30.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTHistoryTableViewCell.h"
#import "DTHistoryModel.h"

@interface DTHistoryTableViewCell()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *textTitleLabel;
@property (nonatomic, strong) UILabel *urlTitleLabel;
@property (nonatomic, strong) UIImageView *rowImgView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation DTHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getHistoryCellHeight{
    return 60;
}

+ (instancetype)cellHistoryTableWithTable:(UITableView*)tableView{
    static NSString *CellIdentifier = @"DTHistoryTableViewCell";
    DTHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DTHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(24);
    }];
    [self.rowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(12);
        make.centerY.equalTo(self.contentView);
    }];
    [self.textTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.right.equalTo(self.rowImgView.mas_left).offset(-10);
        make.centerY.equalTo(self.contentView).offset(-10);
    }];
    [self.urlTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.textTitleLabel);
        make.top.equalTo(self.textTitleLabel.mas_bottom).offset(5);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}


#pragma mark - Model
- (void)setModel:(DTHistoryModel *)model{
    _model = model;
    
    self.textTitleLabel.text = model.title;
    self.urlTitleLabel.text = model.url;
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
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
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
        _textTitleLabel.font = [UIFont systemFontOfSize:15];
        _textTitleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_textTitleLabel];
    }
    return _textTitleLabel;
}

- (UILabel *)urlTitleLabel{
    if (!_urlTitleLabel) {
        _urlTitleLabel = [[UILabel alloc] init];
        _urlTitleLabel.font = [UIFont systemFontOfSize:12];
        _urlTitleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_urlTitleLabel];
    }
    return _urlTitleLabel;
}

@end
