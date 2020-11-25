//
//  DTBrowserViewController.m
//  DownloadTool
//
//  Created by wsl on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTBrowserViewController.h"
#import "DTBrowserAdressView.h"
#import "DTSearchViewController.h"

@interface DTBrowserViewController () <DTBrowserAdressViewDelegate>

@property (nonatomic, strong) DTBrowserAdressView *adressView;

@end

@implementation DTBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupBroswerViewUI];
}

- (void)setupBroswerViewUI{
    [self.adressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(NavigationBarHeight);
    }];
}


#pragma mark - Click
- (void)openUrl:(NSString*)url{
    
}


#pragma mark - DTBrowserAdressViewDelegate
- (void)didBackButtonView:(DTBrowserAdressView*)adressView{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didAdressButtonView:(DTBrowserAdressView*)adressView{
    DTSearchViewController *searchVC = [[DTSearchViewController alloc] init];
//    searchVC.addressStr = @"";
    [self presentViewController:searchVC animated:NO completion:nil];
}
- (void)didRefreshButtonView:(DTBrowserAdressView*)adressView{
    
}

#pragma mark - Lazy
- (DTBrowserAdressView *)adressView{
    if (!_adressView) {
        _adressView = [[DTBrowserAdressView alloc] init];
        _adressView.delegate = self;
        [self.view addSubview:_adressView];
    }
    return _adressView;
}

@end
