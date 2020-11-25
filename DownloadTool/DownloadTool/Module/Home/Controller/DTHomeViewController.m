//
//  DTHomeViewController.m
//  DownloadTool
//
//  Created by wsl on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTHomeViewController.h"
#import "DTHomeSearchView.h"
#import "DTSearchViewController.h"
#import "DTScanViewController.h"

@interface DTHomeViewController ()

@property (nonatomic, strong) DTHomeSearchView *searchView;

@end

@implementation DTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    
    [self setupViewUI];
}

- (void)setupViewUI{
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(kSearchViewHeight);
    }];
    
}

#pragma mark - Click
- (void)clickSearchButton{
    DTSearchViewController *searchVC = [[DTSearchViewController alloc] init];
    searchVC.modalPresentationStyle = UIModalPresentationFullScreen;
    searchVC.parsentVC = self;
    [self presentViewController:searchVC animated:NO completion:nil];
}

- (void)clickScanButton{
    DTScanViewController *scanVC = [[DTScanViewController alloc] init];
    [self.navigationController pushViewController:scanVC animated:YES];
}



#pragma mark - Lazy
- (DTHomeSearchView *)searchView{
    if (!_searchView) {
        _searchView = [[DTHomeSearchView alloc] init];
        
        __weak __typeof(self) weakSelf = self;
        _searchView.clickSearchBlock = ^{
            [weakSelf clickSearchButton];
        };
        _searchView.clickScanBlock = ^{
            [weakSelf clickScanButton];
        };
        
        [self.view addSubview:_searchView];
    }
    return _searchView;
}

@end
