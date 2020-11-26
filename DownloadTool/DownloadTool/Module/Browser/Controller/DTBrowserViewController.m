//
//  DTBrowserViewController.m
//  DownloadTool
//
//  Created by wsl on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTBrowserViewController.h"
#import "DTSearchViewController.h"
#import "DTBrowserPublicHeader.h"

@interface DTBrowserViewController () <DTBrowserAdressViewDelegate, DTBrowserTabViewDelegate, WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) DTBrowserAdressView *adressView;
@property (nonatomic, strong) DTBrowserTabView *tabView;

@end

@implementation DTBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupBroswerViewUI];
    [self addKVOForWebView];
}

- (void)dealloc{
    [self removeKVOForWebView];
}

- (void)setupBroswerViewUI{
    [self.view addSubview:self.adressView];
    [self.view addSubview:self.tabView];
    [self.view addSubview:self.webDTView];
    
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

#pragma mark - KVO
//webView的各种状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    //状态
    if ([keyPath isEqualToString:kBrowser_Progress]) {
        //修改进度条
        double progress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        [self.adressView updateAdressProgress:progress];
        
    } else if ([keyPath isEqualToString:kBrowser_loading]) {
        //是否加载
        BOOL isLoding = [change[NSKeyValueChangeNewKey] boolValue];
        [self.adressView updateAdressLoading:isLoding];
        
    } else if ([keyPath isEqualToString:kBrowser_URL]) {
        //url
        NSURL *url = [change objectForKey:NSKeyValueChangeNewKey];
        if (!url) return;
        if ([url isKindOfClass:[NSNull class]]) return;
        self.webUrl = url;
        [self.adressView updateAdressUrl:url.absoluteString];
        
    } else if ([keyPath isEqualToString:kBrowser_Title]) {
        //标题
        NSString *title = [change objectForKey:NSKeyValueChangeNewKey];
        self.webTitle = title;
        [self.adressView updateAdressUrl:title];
        
    } else if ([keyPath isEqualToString:kBrowser_CanGoBack]) {
        //后退
        BOOL isBack = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        [self.tabView updateTabCanBack:isBack];
        
    } else if ([keyPath isEqualToString:kBrowser_CanGoForward]) {
        //前进
        BOOL isForward = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        [self.tabView updateTabCanForward:isForward];
    }
}

#pragma mark - Click
- (void)openUrl:(NSString*)url{
    if (url.length == 0) {
        return;
    }
    
    NSURL *reqUrl = [NSURL URLWithString:url];
    if (reqUrl.scheme == nil) {
        reqUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", reqUrl.resourceSpecifier]];
    }
    
    if (self.webDTView.isLoading) {
        [self.webDTView stopLoading];
    }
    
    
    self.webUrl = reqUrl;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:reqUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    [self.webDTView loadRequest:request];
}


#pragma mark - DTBrowserAdressViewDelegate
- (void)didBackButtonView:(DTBrowserAdressView*)adressView{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didAdressButtonView:(DTBrowserAdressView*)adressView{
    DTSearchViewController *searchVC = [[DTSearchViewController alloc] init];
    searchVC.modalPresentationStyle = UIModalPresentationFullScreen;
    searchVC.addressStr = self.webUrl.absoluteString;
    [self presentViewController:searchVC animated:NO completion:nil];
}
- (void)didRefreshButtonView:(DTBrowserAdressView*)adressView{
    if ([self.webDTView isLoading]) {
        [self.webDTView stopLoading];
    } else {
        [self.webDTView reload];
    }
}


#pragma mark - Add
- (void)addKVOForWebView {
    for (NSString *keyPath in kBrowserPaths()) {
        [self.webDTView addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
}

- (void)removeKVOForWebView {
    for (NSString *keyPath in kBrowserPaths()) {
        [self.webDTView removeObserver:self forKeyPath:keyPath];
    }
}

#pragma mark - Lazy
- (DTBrowserAdressView *)adressView{
    if (!_adressView) {
        _adressView = [[DTBrowserAdressView alloc] init];
        _adressView.delegate = self;
    }
    return _adressView;
}

- (DTBrowserTabView *)tabView{
    if (!_tabView) {
        _tabView = [[DTBrowserTabView alloc] init];
        _tabView.delegate = self;
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
    }
    return _webDTView;
}

@end
