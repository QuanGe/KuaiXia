//
//  DTBrowserTabView.m
//  DownloadTool
//
//  Created by WSL on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTBrowserTabView.h"

#define kCellIMG    @"kCellIMG"
#define kCellCODE   @"kCellCODE"


typedef NS_OPTIONS(NSInteger, DTTabCode){
    DTTabCode_Left = 0,   //左
    DTTabCode_Right,      //右
    DTTabCode_Home,       //首页
    DTTabCode_More,       //多标签
    DTTabCode_Menu,       //菜单
};

@interface DTBrowserTabView()

@property (nonatomic, strong) NSArray *buttonList;

@end

@implementation DTBrowserTabView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupTabViewUI];
    }
    return self;
}

- (void)setupTabViewUI{
    self.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSInteger i = 0; i < self.buttonList.count; i++) {
        NSDictionary *dict = self.buttonList[i];
        NSString *imgName = [dict objectForKey:kCellIMG];
        NSNumber *number = [dict objectForKey:kCellCODE];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = number.integerValue;
        [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickTabButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [arrM addObject:button];
    }
    
    [arrM mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [arrM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.mas_equalTo(49);
    }];
}

#pragma mark - Click
- (void)clickTabButton:(UIButton*)sender{
    switch (sender.tag) {
        case DTTabCode_Left: {
            [self clickLeftButton];
        }
            break;
        case DTTabCode_Right: {
            [self clickRightButton];
        }
            break;
        case DTTabCode_Home: {
            [self clickHomeButton];
        }
            break;
        case DTTabCode_More: {
            [self clickMoreButton];
        }
            break;
        case DTTabCode_Menu: {
            [self clickMenuButton];
        }
            break;
        default:
            break;
    }
}

- (void)clickLeftButton{
    if ([self.delegate respondsToSelector:@selector(tabLeftTab:)]) {
        [self.delegate tabLeftTab:self];
    }
}
- (void)clickRightButton{
    if ([self.delegate respondsToSelector:@selector(tabRightTab:)]) {
        [self.delegate tabRightTab:self];
    }
}
- (void)clickHomeButton{
    if ([self.delegate respondsToSelector:@selector(tabHomeTab:)]) {
        [self.delegate tabHomeTab:self];
    }
}
- (void)clickMoreButton{
    if ([self.delegate respondsToSelector:@selector(tabMoreTab:)]) {
        [self.delegate tabMoreTab:self];
    }
}
- (void)clickMenuButton{
    if ([self.delegate respondsToSelector:@selector(tabMenuTab:)]) {
        [self.delegate tabMenuTab:self];
    }
}

#pragma mark - Lazy
- (NSArray *)buttonList{
    if (!_buttonList) {
        _buttonList = @[
            @{kCellIMG:@"browser_left", kCellCODE:@(DTTabCode_Left)},
            @{kCellIMG:@"browser_right", kCellCODE:@(DTTabCode_Right)},
            @{kCellIMG:@"browser_home", kCellCODE:@(DTTabCode_Home)},
            @{kCellIMG:@"browser_more", kCellCODE:@(DTTabCode_More)},
            @{kCellIMG:@"browser_menu", kCellCODE:@(DTTabCode_Menu)},
        ];
    }
    return _buttonList;
}

@end
