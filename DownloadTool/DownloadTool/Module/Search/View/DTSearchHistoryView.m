//
//  DTSearchHistoryView.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTSearchHistoryView.h"

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
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [DTSearchHistoryTableCell getHistoryCellHeight];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self endEditing:YES];
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
        _hisyoryList = [NSArray array];
    }
    return _hisyoryList;
}

@end




@interface DTSearchHistoryTableCell()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *textTitleLabel;

@end


@implementation DTSearchHistoryTableCell

+ (CGFloat)getHistoryCellHeight{
    return 70;;
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
        make.right.bottom.left.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    [self.textTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.lineView);
        make.centerY.equalTo(self.lineView);
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

- (UILabel *)textTitleLabel{
    if (!_textTitleLabel) {
        _textTitleLabel = [[UILabel alloc] init];
        _textTitleLabel.font = [UIFont systemFontOfSize:15];
        _textTitleLabel.textColor = kZIColor;
        [self.contentView addSubview:_textTitleLabel];
    }
    return _textTitleLabel;
}

@end
