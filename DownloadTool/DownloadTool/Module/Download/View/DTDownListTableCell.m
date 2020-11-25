//
//  DTDownListTableCell.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTDownListTableCell.h"
#import "DTDownloadModel.h"
#import "DTCommonHelper.h"

@interface DTDownListTableCell()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *textTitleLabel;
@property (nonatomic, strong) UILabel *dateTextLabel;

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
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(25);
    }];
    [self.textTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lineView);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.centerY.equalTo(self.contentView).offset(-10);
    }];
    [self.dateTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textTitleLabel);
        make.centerY.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.lineView);
    }];
}

#pragma mark - Model
- (void)setItemModel:(DTDownloadModel *)itemModel{
    _itemModel = itemModel;
    
    //文件名
    self.textTitleLabel.text = [NSString stringWithFormat:@"%@", itemModel.downloadFileName];
    
    //日期和大小
    NSString *dateStr = [DTCommonHelper convertStrToTime:itemModel.createdDate];
    CGFloat size = itemModel.downloadTotleSize;
    //判断数据库中的大小是否为0，为0根据路径获取文件的大小
    if (size <= 0) {
        size = [DTCommonHelper getFileSizeWithFilePath:itemModel.downloadSavePath];
    }
    NSString *fileSize = [DTCommonHelper getContentSizeWithTotalSize:size];
    
    self.dateTextLabel.text = [NSString stringWithFormat:@"%@ %@", dateStr, fileSize];
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
        _iconImageView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
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

- (UILabel *)dateTextLabel{
    if (!_dateTextLabel) {
        _dateTextLabel = [[UILabel alloc] init];
        _dateTextLabel.textColor = DTRGB(174, 173, 174);
        _dateTextLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_dateTextLabel];
    }
    return _dateTextLabel;
}

@end
