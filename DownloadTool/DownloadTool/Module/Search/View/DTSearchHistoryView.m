//
//  DTSearchHistoryView.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTSearchHistoryView.h"
#import "DTSeatchHistoryDBHelper.h"

@interface DTSearchHistoryView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *historyTableView;
@property (nonatomic, strong) NSArray *hisyoryList;

@end

@implementation DTSearchHistoryView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupHisViewUI];
    }
    return self;
}

- (void)setupHisViewUI{
    [self.historyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.hisyoryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DTSearchHistoryTableCell *cell = [DTSearchHistoryTableCell cellHistoryTableWithTable:tableView];
    
    cell.itemModel = self.hisyoryList[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [DTSearchHistoryTableCell getHistoryCellHeight];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self endEditing:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DTSeatchHistoryModel *itemModel = self.hisyoryList[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(didSelectUrl:)]) {
        [self.delegate didSelectUrl:itemModel.title];
    }
}

#pragma mark - Lazy
- (UITableView *)historyTableView{
    if (!_historyTableView) {
        _historyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _historyTableView.delegate = self;
        _historyTableView.dataSource = self;
        _historyTableView.backgroundColor = [UIColor whiteColor];
        _historyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_historyTableView];
    }
    return _historyTableView;
}

- (NSArray *)hisyoryList{
    if (!_hisyoryList) {
        _hisyoryList = [[DTSeatchHistoryDBHelper sharedDB] getAllItems];
    }
    return _hisyoryList;
}

@end




@interface DTSearchHistoryTableCell()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *textTitleLabel;
@property (nonatomic, strong) UIImageView *rowImgView;

@end


@implementation DTSearchHistoryTableCell

+ (CGFloat)getHistoryCellHeight{
    return 55;
}

+ (instancetype)cellHistoryTableWithTable:(UITableView*)tableView{
    static NSString *CellIdentifier = @"DTSearchHistoryTableCell";
    DTSearchHistoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DTSearchHistoryTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
        make.width.height.mas_equalTo(16);
    }];
    [self.textTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView);
        make.right.equalTo(self.rowImgView.mas_left).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];
}

#pragma mark - Model
- (void)setItemModel:(DTSeatchHistoryModel *)itemModel{
    _itemModel = itemModel;
    
    self.textTitleLabel.text = itemModel.title;
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

- (UILabel *)textTitleLabel{
    if (!_textTitleLabel) {
        _textTitleLabel = [[UILabel alloc] init];
        _textTitleLabel.font = [UIFont systemFontOfSize:15];
        _textTitleLabel.textColor = kZIColor;
        [self.contentView addSubview:_textTitleLabel];
    }
    return _textTitleLabel;
}

- (UIImageView *)rowImgView{
    if (!_rowImgView) {
        _rowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_row"]];
        [self.contentView addSubview:_rowImgView];
    }
    return _rowImgView;
}

@end
