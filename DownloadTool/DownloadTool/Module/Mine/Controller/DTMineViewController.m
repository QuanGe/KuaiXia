//
//  DTMineViewController.m
//  DownloadTool
//
//  Created by wsl on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTMineViewController.h"
#import "DTMineTableCell.h"
#import "DTMineTableHeadView.h"
#import "DTMinePublicHeader.h"
#import "DTHelpViewController.h"
#import "DTAboutController.h"
#import "DTDownListController.h"
#import "DTMessageViewController.h"

#define kCellICON   @"kCellICON"
#define kCellTXT    @"kCellTXT"
#define kCellCode   @"kCellCode"

@interface DTMineViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mineTableView;
@property (nonatomic, strong) DTMineTableHeadView *tableHeadView;
@property (nonatomic, strong) NSArray *mineList;

@end

@implementation DTMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"";
    
    [self setupViewUI];
}

- (void)setupViewUI{
    [self.mineTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mineList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.mineList[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DTMineTableCell *cell = [DTMineTableCell cellMineTableWithTable:tableView];
    
    NSArray *sectionList = self.mineList[indexPath.section];
    NSDictionary *dict = sectionList[indexPath.row];
    [cell cellTitle:[dict objectForKey:kCellTXT] imgName:[dict objectForKey:kCellICON]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [DTMineTableCell getMineCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *sectionList = self.mineList[indexPath.section];
    NSDictionary *dict = sectionList[indexPath.row];
    NSNumber *number = [dict objectForKey:kCellCode];
    
    switch ([number integerValue]) {
        case DTMineCellStatus_Download:{ //下载
            DTDownListController *downVC = [[DTDownListController alloc] init];
            [self.navigationController pushViewController:downVC animated:YES];
        }
            break;
        case DTMineCellStatus_Message: { //消息
            DTMessageViewController *messageVC = [[DTMessageViewController alloc] init];
            [self.navigationController pushViewController:messageVC animated:YES];
        }
            break;
        case DTMineCellStatus_About: { //关于
            DTAboutController *setVC = [[DTAboutController alloc] init];
            [self.navigationController pushViewController:setVC animated:YES];
        }
            break;
        case DTMineCellStatus_Help: { //帮助
            DTHelpViewController *helpVC = [[DTHelpViewController alloc] init];
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
        case DTMineCellStatus_Shared: { //分享
            [self clickSharedButton];
        }
            break;
        case DTMineCellStatus_Good: {   //点赞
            [self clickGoodButton];
        }
            break;
        default:
            break;
    }
}

//分享
- (void)clickSharedButton{
    
}
//点赞
- (void)clickGoodButton{
    
}



#pragma mark - Lazy
- (UITableView *)mineTableView{
    if (!_mineTableView) {
        _mineTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mineTableView.delegate = self;
        _mineTableView.dataSource = self;
        _mineTableView.backgroundColor = kBackViewColor;
        _mineTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _mineTableView.tableHeaderView = self.tableHeadView;
        _mineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_mineTableView];
    }
    return _mineTableView;
}

- (DTMineTableHeadView *)tableHeadView{
    if (!_tableHeadView) {
        _tableHeadView = [[DTMineTableHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _tableHeadView.text = @"我的";
    }
    return _tableHeadView;
}

- (NSArray *)mineList{
    if (!_mineList) {
        _mineList = @[
            @[
                @{kCellICON:@"", kCellTXT:@"我的下载",  kCellCode:@(DTMineCellStatus_Download)},
                @{kCellICON:@"", kCellTXT:@"我的消息",  kCellCode:@(DTMineCellStatus_Message)},
            ],
            @[
                @{kCellICON:@"", kCellTXT:@"帮助中心",  kCellCode:@(DTMineCellStatus_Help)},
                @{kCellICON:@"", kCellTXT:@"分享好友",  kCellCode:@(DTMineCellStatus_Shared)},
                @{kCellICON:@"", kCellTXT:@"我要点赞",  kCellCode:@(DTMineCellStatus_Good)},
                @{kCellICON:@"", kCellTXT:@"关于我们",  kCellCode:@(DTMineCellStatus_About)},
            ],
        ];
    }
    return _mineList;
}


@end
