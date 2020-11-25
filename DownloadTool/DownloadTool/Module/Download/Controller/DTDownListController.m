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
#import "DTDownloadModel.h"
#import "DTDownManager.h"
#import "DTOpenDocumentController.h"
#import "DTCommonHelper.h"

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
    return self.listArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DTDownListTableCell *cell = [DTDownListTableCell cellListTableWithTable:tableView];
    
    cell.itemModel = self.listArrM[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [DTDownListTableCell getListCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self didSelectItemModelWithModel:self.listArrM[indexPath.row]];
}

#pragma mark - Alert
- (void)didSelectItemModelWithModel:(DTDownloadModel*)model{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:model.downloadFileName message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self clickDeleteButtonWithModel:model];
    }];
    UIAlertAction *other = [UIAlertAction actionWithTitle:@"用其它应用打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self clickOtherButtonModel:model];
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:delete];
    [alertVC addAction:other];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

//删除
- (void)clickDeleteButtonWithModel:(DTDownloadModel*)model{
    //列表删除
    [self.listArrM removeObject:model];
    //删除任务，删除文件，删除数据库中的记
    [[DTDownManager shareInstance] removeDownloadFile:model.downloadUrl];
    //刷新table
    [self.listTableView reloadData];
}

//其它应用打开
- (void)clickOtherButtonModel:(DTDownloadModel*)model{
    NSString *filePath = [DTCommonHelper getSaveFilepathWithUrl:model.downloadUrl];
    NSURL *fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", filePath, model.downloadFileName]];
    [DTOpenDocumentController openFileInOtherApplication:fileURL controller:self];
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
