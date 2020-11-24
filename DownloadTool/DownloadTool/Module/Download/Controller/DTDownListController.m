//
//  DTDownListController.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTDownListController.h"
#import "DTDownListTableCell.h"
#import "DTDoownloadDBHelper.h"

@interface DTDownListController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) NSMutableArray *listArrM;

@end

@implementation DTDownListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"全部文件";
    
    [self setupViewUI];
    [self updateListData];
}

- (void)setupViewUI{
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)updateListData{
    NSArray *list = [[DTDoownloadDBHelper sharedDB] getSucessItems];
    self.listArrM = [NSMutableArray arrayWithArray:list];
    
    [self.listTableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DTDownListTableCell *cell = [DTDownListTableCell cellListTableWithTable:tableView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [DTDownListTableCell getListCellHeight];
}


#pragma mark - Lazy
- (UITableView *)listTableView{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.backgroundColor = [UIColor whiteColor];
        _listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_listTableView];
    }
    return _listTableView;
}


- (NSMutableArray *)listArrM{
    if (!_listArrM) {
        _listArrM = [NSMutableArray array];
    }
    return _listArrM;
}

@end
