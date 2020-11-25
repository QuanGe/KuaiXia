//
//  DTSearchViewController.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTSearchViewController.h"
#import "DTSearchToolView.h"
#import "DTSearchHistoryView.h"
#import "DTSeatchHistoryDBHelper.h"
#import "DTCommonHelper.h"
#import "DTBrowserViewController.h"

@interface DTSearchViewController () <DTSearchToolViewDelegate, DTSearchHistoryViewDelegate>

@property (nonatomic, strong) DTSearchToolView *searchToolView;
@property (nonatomic, strong) DTSearchHistoryView *historyView;

@end

@implementation DTSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViewUI];
}

- (void)setupViewUI{
    [self.searchToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(kSearchViewHeight);
    }];
    [self.historyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.searchToolView.mas_bottom);
    }];
}

- (void)setAddressStr:(NSString *)addressStr{
    _addressStr = addressStr;
    self.searchToolView.addressStr = addressStr;
}

#pragma mark - Click
- (void)clickCloseButtonAnimation:(BOOL)animation{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:animation completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:animation];
    }
}

//打开链接
- (void)openUrlWithUrl:(NSString*)urlString{
    //判断是否为空
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (urlString.length == 0) {
        return;
    }
    
    //保存历史记录
    DTSeatchHistoryModel *model = [DTSeatchHistoryModel defaultHistoryModel];
    model.title = urlString;
    
    //判断是否为url
    if ([DTCommonHelper isUrl:urlString] == NO) {
        urlString = [NSString stringWithFormat:@"https://m.baidu.com/s?word=%@", [urlString encodeString]];
    }
    
    //保存历史记录
    [[DTSeatchHistoryDBHelper sharedDB] saveItem:model];
    
    //打开url
    if (self.parsentVC) {
        DTBrowserViewController *webVC = [[DTBrowserViewController alloc] init];
        [self.parsentVC.navigationController pushViewController:webVC animated:YES];
    }
    
    //搜索消失
    [self clickCloseButtonAnimation:NO];
}

#pragma mark - DTSearchToolViewDelegate
- (void)cancelInputView:(DTSearchToolView*)toolView{
    [self clickCloseButtonAnimation:YES];
}
//点击完成
- (void)searchDoneInputText:(NSString *)inputText{
    [self openUrlWithUrl:inputText];
}


#pragma mark - DTSearchHistoryViewDelegate
//选中历史记录
- (void)didSelectUrl:(NSString *)url{
    [self openUrlWithUrl:url];
}


#pragma mark - Lazy
- (DTSearchToolView *)searchToolView{
    if (!_searchToolView) {
        _searchToolView = [[DTSearchToolView alloc] init];
        _searchToolView.delegate = self;
        [self.view addSubview:_searchToolView];
    }
    return _searchToolView;
}

- (DTSearchHistoryView *)historyView{
    if (!_historyView) {
        _historyView = [[DTSearchHistoryView alloc] init];
        _historyView.delegate = self;
        [self.view addSubview:_historyView];
    }
    return _historyView;
}

@end
