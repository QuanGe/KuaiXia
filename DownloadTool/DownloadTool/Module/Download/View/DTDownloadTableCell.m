//
//  DTDownloadTableCell.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTDownloadTableCell.h"
#import "DTDownloadModel.h"
#import "DTDoownloadDBHelper.h"

const static CGFloat unit = 1048576.;

@interface DTDownloadTableCell()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *textTitleLabel;          //文件名
@property (nonatomic, strong) UILabel *downloadSizeLabel;       //文件大小
@property (nonatomic, strong) UIProgressView *progressView;     //进度条

@end

@implementation DTDownloadTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (CGFloat)getDownCellHeight{
    return 60;
}

+ (instancetype)cellDownloadTableWithTable:(UITableView*)tableView{
    static NSString *CellIdentifier = @"DTDownloadTableCell";
    DTDownloadTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DTDownloadTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
    [self.downloadSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textTitleLabel);
        make.centerY.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.lineView);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.lineView);
    }];
}

#pragma mark - Method
- (void)setItemModel:(DTDownloadModel *)itemModel{
    _itemModel = itemModel;
    
    //文件名
    self.textTitleLabel.text = [NSString stringWithFormat:@"%@", itemModel.downloadFileName];
    //进度条
    self.progressView.progress = (itemModel.downloadTotleSize == 0 ? 0 : (CGFloat)itemModel.downloadAlreadySize / itemModel.downloadTotleSize);
    //cell
    [self reloadCell];
}

//刷新cell
- (void)reloadCell{
    CGFloat totalSize = (CGFloat)self.itemModel.downloadTotleSize;
    NSString *sizeStr = totalSize > 0 ? [NSString stringWithFormat:@"%.1fM", totalSize / unit] : @"未知";
    
    //下载的各种状态
    if (self.itemModel.downloadStatus == DTWSLDownLoad_Pause) { //暂停
        self.downloadSizeLabel.text = [NSString stringWithFormat:@"%.1fM/%@ | 已暂停", (CGFloat)self.itemModel.downloadAlreadySize / unit, sizeStr];
        
    } else if (self.itemModel.downloadStatus == DTWSLDownLoad_Loading) { //下载中
        self.downloadSizeLabel.text = [NSString stringWithFormat:@"%.1fM/%@", (CGFloat)self.itemModel.downloadAlreadySize / unit, sizeStr];
        
    } else if (self.itemModel.downloadStatus == DTWSLDownLoad_Failed) { //失败
        self.downloadSizeLabel.text = @"下载失败,请重试";
        
    } else { //完成
        self.downloadSizeLabel.text = [NSString stringWithFormat:@"%.1fM/%@", (CGFloat)self.itemModel.downloadAlreadySize / unit, sizeStr];
    }
}

//进度和下载速度
- (void)setProgressWithProgress:(int64_t)progress speed:(double)speed{
    self.itemModel.downloadAlreadySize = progress;
    
    //判断model中的大小是否小于0，小于，去数据库中查找文件，获取大小
    if (self.itemModel.downloadTotleSize <= 0) {
        DTDownloadModel *model = [[DTDoownloadDBHelper sharedDownDB] getSelModelUrl:self.itemModel.downloadUrl];
        if (model.downloadTotleSize > 0) {
            self.itemModel.downloadTotleSize = model.downloadTotleSize;
        }
    }
    
    //进度
    CGFloat totalSize = (CGFloat)self.itemModel.downloadTotleSize;
    self.progressView.progress = (CGFloat)progress / self.itemModel.downloadTotleSize;
    NSString *sizeStr = totalSize > 0 ? [NSString stringWithFormat:@"%.1fM", totalSize / unit] : @"未知";
    self.downloadSizeLabel.text = [NSString stringWithFormat:@"%.1fM/%@", (CGFloat)self.itemModel.downloadAlreadySize / unit, sizeStr];
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

- (UILabel *)downloadSizeLabel{
    if (!_downloadSizeLabel) {
        _downloadSizeLabel = [[UILabel alloc] init];
        _downloadSizeLabel.textColor = DTRGB(174, 173, 174);
        _downloadSizeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_downloadSizeLabel];
    }
    return _downloadSizeLabel;
}

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressTintColor = DTHexColor(0x00C853);
        _progressView.trackTintColor = DTRGB(245, 245, 245);
        [self.contentView addSubview:_progressView];
    }
    return _progressView;;
}

@end
