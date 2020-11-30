//
//  DTHistoryViewController.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/30.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTHistoryViewController.h"
#import "DTHistoryTableViewCell.h"
#import "DTHistoryDBHelper.h"

@interface DTHistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *historyTableView;
@property (nonatomic, strong) NSMutableArray *historyListM;

@end

@implementation DTHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"历史记录";
    
    [self setupHistoryViewUI];
}

- (void)setupHistoryViewUI{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(clickCloseButton)];
    [self.historyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)clickCloseButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.historyListM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DTHistoryTableViewCell *cell = [DTHistoryTableViewCell cellHistoryTableWithTable:tableView];
    
    DTHistoryModel *model = self.historyListM[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [DTHistoryTableViewCell getHistoryCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DTHistoryModel *model = self.historyListM[indexPath.row];
    
    if (self.selHistoryBlock) {
        self.selHistoryBlock(model.url);
    }
    
    [self clickCloseButton];
}

 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
     return YES;
 }

 - (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
     // 定义左滑功能为删除
     UITableViewRowAction * actionDeleate = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleNormal) title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
         // 删除的具体操作
         [self tableDeleteSelectIndex:indexPath];
     }];
     actionDeleate.backgroundColor = [UIColor whiteColor];
     return @[actionDeleate];
 }

- (void)tableDeleteSelectIndex:(NSIndexPath*)indexPath{
    DTHistoryModel *model = self.historyListM[indexPath.row];
    [self.historyListM removeObject:model];
    
    [[DTHistoryDBHelper sharedHistoryDB] deleteItem:model];
    [self.historyTableView reloadData];
}


#pragma mark - Lazy
- (UITableView *)historyTableView{
    if (!_historyTableView) {
        _historyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _historyTableView.delegate = self;
        _historyTableView.dataSource = self;
        _historyTableView.backgroundColor = kBackViewColor;
        _historyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_historyTableView];
    }
    return _historyTableView;
}

- (NSMutableArray *)historyListM{
    if (!_historyListM) {
        NSArray *list = [[DTHistoryDBHelper sharedHistoryDB] getAllItems];
        _historyListM = [NSMutableArray arrayWithArray:list];
    }
    return _historyListM;
}


@end
