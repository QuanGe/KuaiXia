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

@interface DTSearchViewController () <DTSearchToolViewDelegate>

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


#pragma mark - DTSearchToolViewDelegate
- (void)cancelInputView:(DTSearchToolView*)toolView{
    [self.navigationController popViewControllerAnimated:YES];
}
//点击完成
- (void)searchDoneInputText:(NSString *)inputText{
    NSLog(@"inputText ==> %@", inputText);
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
        [self.view addSubview:_historyView];
    }
    return _historyView;
}

@end
