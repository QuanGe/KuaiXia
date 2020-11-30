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
    self.webDTView.frame = CGRectMake(0, NavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT- HEIGHT_TABBAR - LL_SafeAreaBottomHeight - NavigationBarHeight);
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
        _webDTView = [[DTWebView alloc] initWithFrame:CGRectZero configuration:[self getWKWebViewConfiguration]];
        _webDTView.UIDelegate = self;
        _webDTView.navigationDelegate = self;
        _webDTView.customUserAgent = @"Mozilla/5.0 (iPhone; CPU iPhone OS 13_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.5 Mobile/15E148 Safari/604.1";
        _webDTView.backgroundColor = [UIColor whiteColor];
    }
    return _webDTView;
}

- (WKWebViewConfiguration*)getWKWebViewConfiguration{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences = [self getConfigWKPreferences];
    
    //是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
    config.allowsInlineMediaPlayback = YES;
    //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
    config.mediaTypesRequiringUserActionForPlayback = YES;
    //设置是否允许画中画技术 在特定设备上有效
    config.allowsPictureInPictureMediaPlayback = YES;
    //设置请求的User-Agent信息中应用程序名称 iOS9后可用
    config.applicationNameForUserAgent = @"KuaiZai";
    
    //这个类主要用来做native与JavaScript的交互管理
    WKUserContentController * wkUController = [[WKUserContentController alloc] init];
    
    config.userContentController = wkUController;
    
    return config;
}


- (WKPreferences*)getConfigWKPreferences{
    WKPreferences *preference = [[WKPreferences alloc]init];
    
//    //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
//    preference.minimumFontSize = 0;
//    //设置是否支持javaScript 默认是支持的
//    preference.javaScriptEnabled = YES;
//    //在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
//    preference.javaScriptCanOpenWindowsAutomatically = YES;
    
    return preference;
}


@end
