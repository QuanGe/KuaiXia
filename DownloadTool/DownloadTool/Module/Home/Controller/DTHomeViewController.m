//
//  DTHomeViewController.m
//  DownloadTool
//
//  Created by wsl on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTHomeViewController.h"
#import "DTHomeSearchView.h"
#import "DTHomeTipView.h"
#import "DTHomeCollectionCell.h"
#import "DTSearchViewController.h"
#import "DTScanViewController.h"
#import "DTBrowserViewController.h"

@interface DTHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DTScanViewControllerDelegate>

@property (nonatomic, strong) DTHomeSearchView *searchView;
@property (nonatomic, strong) DTHomeTipView *tipHeadView;
@property (nonatomic, strong) UICollectionView *homeCollectionView;

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
    [self.tipHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.searchView.mas_bottom);
        make.height.mas_equalTo(kHomeTipHeight);
    }];
    [self.homeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.tipHeadView.mas_bottom);
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
    scanVC.delegate = self;
    [self.navigationController pushViewController:scanVC animated:YES];
}

#pragma mark - DTScanViewControllerDelegate
- (void)pickUpMessage:(NSString *)message{
    DTBrowserViewController *webVC = [[DTBrowserViewController alloc] init];
    [self.navigationController pushViewController:webVC animated:YES];
    [webVC openUrl:message];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DTHomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDTHomeCollectionCellKey forIndexPath:indexPath];
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = SCREEN_WIDTH - 9;
    return CGSizeMake(width/3, width/3);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(3, 3, 3, 3);
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

- (DTHomeTipView *)tipHeadView{
    if (!_tipHeadView) {
        _tipHeadView = [[DTHomeTipView alloc] init];
        [self.view addSubview:_tipHeadView];
    }
    return _tipHeadView;
}

- (UICollectionView *)homeCollectionView{
    if (!_homeCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 2;
        flowLayout.minimumInteritemSpacing = 0;
        
        _homeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _homeCollectionView.delegate = self;
        _homeCollectionView.dataSource = self;
        _homeCollectionView.backgroundColor = kBackViewColor;
        
        [_homeCollectionView registerClass:[DTHomeCollectionCell class] forCellWithReuseIdentifier:kDTHomeCollectionCellKey];
        
        [self.view addSubview:_homeCollectionView];
    }
    return _homeCollectionView;
}

@end
