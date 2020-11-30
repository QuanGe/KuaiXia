//
//  DTDownloadViewController.m
//  DownloadTool
//
//  Created by wsl on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTDownloadViewController.h"
#import "DTDownloadHandle.h"
#import "DTDownManager.h"
#import "DTDownloadTableCell.h"
#import "DTDownListController.h"
#import "DTDownInputController.h"
#import "DTNavigationController.h"
#import "DTDoownloadDBHelper.h"

@interface DTDownloadViewController () <UITableViewDelegate, UITableViewDataSource, DTDownManagerDelegate>

@property (nonatomic, strong) UITableView *downTableView;
@property (nonatomic, strong) UIButton *downButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) NSMutableArray *downListM;
@property (nonatomic, strong) UIImageView *maskImgView;

@end

@implementation DTDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"传输";
    
    //
    [DTDownManager shareInstance].delegate = self;
    [DTDownloadHandle startDownList];
    
    [self setupViewUI];
    [self updateData];
}

- (void)setupViewUI{
    self.navigationItem.leftBarButtonItem = nil;
    
    [self.downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.bottom.equalTo(self.view).offset(-(20+HEIGHT_TABBAR+LL_SafeAreaBottomHeight));
        make.height.mas_equalTo(48);
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-30);
        make.width.height.bottom.equalTo(self.downButton);
        make.left.equalTo(self.downButton.mas_right).offset(30);
    }];
    [self.downTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.downButton.mas_top).offset(-20);
    }];
    [self.maskImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.downTableView);
        make.centerY.equalTo(self.downTableView);
    }];
}

- (void)showMsgImgView{
    self.maskImgView.hidden = self.downListM.count != 0;
}


//刷新数据
- (void)updateData{
    NSArray *list = [[DTDoownloadDBHelper sharedDownDB] getLoadingItems];
    self.downListM = [NSMutableArray arrayWithArray:list];
    [self.downTableView reloadData];
    [self showMsgImgView];
}

#pragma mark - Click
- (void)clickDownButton{
    DTDownListController *listVC = [[DTDownListController alloc] init];
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)clickAddButton{
    DTDownInputController *inputVC = [[DTDownInputController alloc] init];
    __weak __typeof(self) weakSelf = self;
    inputVC.inputBlock = ^{
        [weakSelf updateData];
    };
    DTNavigationController *navVC = [[DTNavigationController alloc] initWithRootViewController:inputVC];
    navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navVC animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.downListM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DTDownloadTableCell *cell = [DTDownloadTableCell cellDownloadTableWithTable:tableView];
    
    DTDownloadModel *itemModel = self.downListM[indexPath.row];
    cell.itemModel = itemModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [DTDownloadTableCell getDownCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DTDownloadModel *itemModel = self.downListM[indexPath.row];
    
    if (itemModel.downloadStatus == DTWSLDownLoad_Loading) {   //下载中
        [[DTDownManager shareInstance] pauseDownload:itemModel];
        
    } else if (itemModel.downloadStatus == DTWSLDownLoad_Pause) {  //暂停
        [[DTDownManager shareInstance] startDowload:itemModel.downloadUrl withSuggestionName:itemModel.downloadFileName withMIMEType:itemModel.downloadType cookie:itemModel.downloadCookie];
        
    } else if (itemModel.downloadStatus == DTWSLDownLoad_Failed) {  //失败
        itemModel.downloadAlreadySize = 0;
        [[DTDownManager shareInstance] startDowload:itemModel.downloadUrl withSuggestionName:itemModel.downloadFileName withMIMEType:itemModel.downloadType cookie:itemModel.downloadCookie];
    }
}


//刷新tableView,跟新cell状态
- (void)reloadTableWithDownTasl:(DTDownloadObject*)downloadTask downloadStatus:(DTWSLDownLoadStatus)downloadStatus{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *cells = [self.downTableView visibleCells];
        for (DTDownloadTableCell *cell in cells) {
            if (cell.itemModel && [cell.itemModel.downloadUrl isEqualToString:downloadTask.downloadUrl]) {
                cell.itemModel.downloadStatus = downloadStatus;
                [cell reloadCell];
            }
        }
    });
}


#pragma mark - DTDownManagerDelegate
/**开始下载*/
- (void)downloadStarted:(DTDownloadObject *)downloadTask{
    [self reloadTableWithDownTasl:downloadTask downloadStatus:DTWSLDownLoad_Loading];
}
/**下载失败*/
- (void)downloadFailed:(DTDownloadObject *)downloadTask{
    [self reloadTableWithDownTasl:downloadTask downloadStatus:DTWSLDownLoad_Failed];
}
/**下载暂停*/
- (void)downloadPause:(DTDownloadObject *)downloadTask{
    [self reloadTableWithDownTasl:downloadTask downloadStatus:DTWSLDownLoad_Pause];
}
/**下载完成*/
- (void)downloadCompleted:(DTDownloadObject *)downloadTask{
    [self updateData];
}
/**下载速度*/
- (void)downloading:(DTDownloadObject *)downloadTask withSize:(NSNumber *)receiveDatelength withSpeed:(NSNumber *)speed{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *cells = [self.downTableView visibleCells];
        for (DTDownloadTableCell *cell in cells) {
            if (cell.itemModel && [cell.itemModel.downloadUrl isEqualToString:downloadTask.downloadUrl]) {
                [cell setProgressWithProgress:[receiveDatelength longLongValue] speed:[speed doubleValue]];
            }
        }
    });
}



#pragma mark - Lazy
- (UITableView *)downTableView{
    if (!_downTableView) {
        _downTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _downTableView.delegate = self;
        _downTableView.dataSource = self;
        _downTableView.backgroundColor = kBackViewColor;
        _downTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _downTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_downTableView];
    }
    return _downTableView;
}

- (UIButton *)downButton{
    if (!_downButton) {
        _downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _downButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _downButton.backgroundColor = [UIColor whiteColor];
        _downButton.layer.cornerRadius = 24;
        _downButton.layer.masksToBounds = YES;
        _downButton.layer.borderWidth = 0.5;
        _downButton.layer.borderColor = kBaseColor.CGColor;
        [_downButton setTitle:@"查看完成文件" forState:UIControlStateNormal];
        [_downButton setTitleColor:kBaseColor forState:UIControlStateNormal];
        [_downButton addTarget:self action:@selector(clickDownButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_downButton];
    }
    return _downButton;
}

- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _addButton.backgroundColor = kBaseColor;
        _addButton.layer.cornerRadius = 24;
        _addButton.layer.masksToBounds = YES;
        [_addButton setTitle:@"+ 创建下载" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(clickAddButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_addButton];
    }
    return _addButton;
}

- (NSMutableArray *)downListM{
    if (!_downListM) {
        _downListM = [NSMutableArray array];
    }
    return _downListM;
}

- (UIImageView *)maskImgView{
    if (!_maskImgView) {
        _maskImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_007"]];
        _maskImgView.hidden = YES;
        [self.view addSubview:_maskImgView];
    }
    return _maskImgView;
}


@end
