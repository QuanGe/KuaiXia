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

@interface DTDownloadViewController () <UITableViewDelegate, UITableViewDataSource, DTDownManagerDelegate>

@property (nonatomic, strong) UITableView *downTableView;
@property (nonatomic, strong) UIButton *downButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) NSArray *downList;

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
}

- (void)updateData{
    
}

#pragma mark - Click
- (void)clickDownButton{
    DTDownListController *listVC = [[DTDownListController alloc] init];
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)clickAddButton{
    DTDownInputController *inputVC = [[DTDownInputController alloc] init];
    DTNavigationController *navVC = [[DTNavigationController alloc] initWithRootViewController:inputVC];
    navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navVC animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DTDownloadTableCell *cell = [DTDownloadTableCell cellDownloadTableWithTable:tableView];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [DTDownloadTableCell getDownCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark - DTDownManagerDelegate
/**开始下载*/
- (void)downloadStarted:(DTDownloadObject *)downloadTask{
    NSLog(@"开始下载");
}
/**下载完成*/
- (void)downloadCompleted:(DTDownloadObject *)downloadTask{
    NSLog(@"下载完成");
}
/**下载失败*/
- (void)downloadFailed:(DTDownloadObject *)downloadTask{
    NSLog(@"下载失败");
}
/**下载暂停*/
- (void)downloadPause:(DTDownloadObject *)downloadTask{
    NSLog(@"下载暂停");
}
/**下载速度*/
- (void)downloading:(DTDownloadObject *)downloadTask withSize:(NSNumber *)receiveDatelength withSpeed:(NSNumber *)speed{
    NSLog(@"下载速度");
    CGFloat downSpeed = [speed doubleValue];
    if(downSpeed > 950){
        downSpeed = downSpeed/1024;
        NSLog(@"下载速度: %.1fM/s", downSpeed);
    } else {
        NSLog(@"下载速度: %.1fk/s", downSpeed);
    }
}



#pragma mark - Lazy
- (UITableView *)downTableView{
    if (!_downTableView) {
        _downTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _downTableView.delegate = self;
        _downTableView.dataSource = self;
        _downTableView.backgroundColor = [UIColor whiteColor];
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

- (NSArray *)downList{
    if (!_downList) {
        _downList = [NSArray array];
    }
    return _downList;
}

@end
