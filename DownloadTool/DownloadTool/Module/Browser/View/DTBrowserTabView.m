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

#define kTagValue 7896

@interface DTBrowserTabView()

@property (nonatomic, strong) NSArray *buttonList;
@property (nonatomic, strong) UILabel *tabTextLabel;
@property (nonatomic, strong) UIView *lineView;

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
        button.tag = kTagValue + number.integerValue;
        if (number.integerValue == DTTabCode_Left || number.integerValue == DTTabCode_Right) {
            button.alpha = 0.3;
        }
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
    
    UIButton *moreButton = [self viewWithTag:kTagValue+DTTabCode_More];
    if (moreButton) {
        [self.tabTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(moreButton);
        }];
    }
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - Click
- (void)clickTabButton:(UIButton*)sender{
    NSInteger tag = sender.tag - kTagValue;
    switch (tag) {
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


#pragma mark - Update
/**后退*/
- (void)updateTabCanBack:(BOOL)canBack{
    UIButton *backButton = [self viewWithTag:kTagValue+DTTabCode_Left];
    if (backButton) {
        backButton.userInteractionEnabled = canBack;
        backButton.alpha = canBack ? 1.0 : 0.3;
    }
}

/**前进*/
- (void)updateTabCanForward:(BOOL)canForward{
    UIButton *forwardButton = [self viewWithTag:kTagValue+DTTabCode_Right];
    if (forwardButton) {
        forwardButton.userInteractionEnabled = canForward;
        forwardButton.alpha = canForward ? 1.0 : 0.3;
    }
}




#pragma mark - Lazy
- (NSArray *)buttonList{
    if (!_buttonList) {
        _buttonList = @[
            @{kCellIMG:@"browser_left",  kCellCODE:@(DTTabCode_Left)},
            @{kCellIMG:@"browser_right", kCellCODE:@(DTTabCode_Right)},
            @{kCellIMG:@"browser_home",  kCellCODE:@(DTTabCode_Home)},
            @{kCellIMG:@"browser_more",  kCellCODE:@(DTTabCode_More)},
            @{kCellIMG:@"browser_menu",  kCellCODE:@(DTTabCode_Menu)},
        ];
    }
    return _buttonList;
}

- (UILabel *)tabTextLabel{
    if (!_tabTextLabel) {
        _tabTextLabel = [[UILabel alloc] init];
        _tabTextLabel.textColor = kBaseColor;
        _tabTextLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        _tabTextLabel.text = @"1";
        [self addSubview:_tabTextLabel];
    }
    return _tabTextLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = DTRGB(246, 246, 246);
        [self addSubview:_lineView];
    }
    return _lineView;
}

@end
