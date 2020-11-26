//
//  DTBrowserViewController.m
//  DownloadTool
//
//  Created by wsl on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTBrowserViewController.h"
#import "DTSearchViewController.h"

@interface DTBrowserViewController () <DTBrowserAdressViewDelegate, DTBrowserTabViewDelegate, WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) DTBrowserAdressView *adressView;
@property (nonatomic, strong) DTBrowserTabView *tabView;

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
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TABBAR + LL_SafeAreaBottomHeight);
    }];
    [self.webDTView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.adressView.mas_bottom);
        make.bottom.equalTo(self.tabView.mas_top);
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

- (DTBrowserTabView *)tabView{
    if (!_tabView) {
        _tabView = [[DTBrowserTabView alloc] init];
        _tabView.delegate = self;
        [self.view addSubview:_tabView];
    }
    return _tabView;
}

- (DTWebView *)webDTView{
    if (!_webDTView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        _webDTView = [[DTWebView alloc] initWithFrame:CGRectZero configuration:config];
        _webDTView.UIDelegate = self;
        _webDTView.navigationDelegate = self;
        _webDTView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_webDTView];
    }
    return _webDTView;
}

@end
