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
@property (nonatomic, strong) UIImageView *maskImgView;

@end

@implementation DTDownListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"全部文件";
    
    [self setupViewUI];
    [self updateListData];
    [self showMsgImgView];
}

- (void)setupViewUI{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleDone target:self action:@selector(clickClearButton)];
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.maskImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-50);
    }];
}

- (void)showMsgImgView{
    self.maskImgView.hidden = self.listArrM.count != 0;
}

- (void)updateListData{
    [self showMsgImgView];
    
    //
    NSArray *list = [[DTDoownloadDBHelper sharedDownDB] getSucessItems];
    self.listArrM = [NSMutableArray arrayWithArray:list];
    
    [self.listTableView reloadData];
}

//清空
- (void)clickClearButton{
    if (self.listArrM.count == 0) {
        [DTProgressHUDHelper showMessage:@"还没有文件哦～"];
        return;
    }
    
    [DTProgressHUDHelper show];
    for (DTDownloadModel *model in self.listArrM) {
        [[DTDownManager shareInstance] removeDownloadFile:model.downloadUrl];
    }
    [DTProgressHUDHelper dissMiss];
    //刷新
    [self updateListData];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //选中
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
    UIAlertAction *picture = [UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self clickPictureModel:model];
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:delete];
    [alertVC addAction:picture];
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
    [self showMsgImgView];
}

//其它应用打开
- (void)clickOtherButtonModel:(DTDownloadModel*)model{
    NSString *filePath = [DTCommonHelper getSaveFilepathWithUrl:model.downloadUrl];
    NSURL *fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", filePath, model.downloadFileName]];
    [DTOpenDocumentController openFileInOtherApplication:fileURL controller:self];
}

//保存到相册
- (void)clickPictureModel:(DTDownloadModel*)model{
    NSString *filePath = [DTCommonHelper getSaveFilepathWithUrl:model.downloadUrl];
    NSURL *fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", filePath, model.downloadFileName]];
    
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([fileURL path])) {
        [DTProgressHUDHelper show];
        UISaveVideoAtPathToSavedPhotosAlbum([fileURL path], self, @selector(saveVideo:didFinishSavingWithError:contextInfo:), nil);
    }
}

//保存视频完成之后的回调
- (void)saveVideo:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [DTProgressHUDHelper showMessage:[NSString stringWithFormat:@"保存视频失败%@", error.localizedDescription]];
    } else {
        [DTProgressHUDHelper showMessage:@"保存视频成功"];
    }
  
}

#pragma mark - Lazy
- (UITableView *)listTableView{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.backgroundColor = kBackViewColor;
        _listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_listTableView];
    }
    return _listTableView;
}

- (UIImageView *)maskImgView{
    if (!_maskImgView) {
        _maskImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_007"]];
        _maskImgView.hidden = YES;
        [self.view addSubview:_maskImgView];
    }
    return _maskImgView;
}

- (NSMutableArray *)listArrM{
    if (!_listArrM) {
        _listArrM = [NSMutableArray array];
    }
    return _listArrM;
}

@end
