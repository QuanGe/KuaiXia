//
//  DTPopBaseController.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/27.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTPopBaseController.h"

#define kDuration               0.5     //弹出动画时长
#define kContentHeight          (320 + LL_SafeAreaBottomHeight)     //高
#define kContentWidth           (SCREEN_WIDTH)                      //宽
#define kContentRect            CGRectMake(0, SCREEN_HEIGHT-kContentHeight, kContentWidth, kContentHeight)  //列表内容的frame

@interface DTPopBaseController () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) DTPopBackView *backBlackView;
@property (nonatomic, assign) SEL animateSelector;

@end

@implementation DTPopBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupPopBaseViewUI];
}


#pragma mark - View
- (void)setupPopBaseViewUI{
    [self.view addSubview:self.backBlackView];
    [self.view addSubview:self.contentView];
    
}

#pragma mark - Click
//关闭
- (void)clickDismissButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Lazy
- (DTPopBackView *)backBlackView{
    if (!_backBlackView) {
        _backBlackView = [[DTPopBackView alloc] init];
        _backBlackView.rect = kContentRect;
        
        __weak __typeof(self) weakSelf = self;
        _backBlackView.dismiss = ^{
            [weakSelf clickDismissButton];
        };
    }
    return _backBlackView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:kContentRect];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _contentView.bounds;
        maskLayer.path = maskPath.CGPath;
        _contentView.layer.mask = maskLayer;
    }
    return _contentView;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationCustom;
}

- (id<UIViewControllerTransitioningDelegate>)transitioningDelegate {
    return self;
}

- (void)present:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    self.view.frame = [transitionContext finalFrameForViewController:self];
    self.backBlackView.backgroundColor = DTColor(0, 0, 0, 0.5);
    containerView.backgroundColor = DTColor(0, 0, 0, 0.5);
    self.view.backgroundColor = [UIColor clearColor];
    [containerView addSubview:self.view];
    
    CGRect frame = self.contentView.frame;
    frame.origin.y += frame.size.height;
    self.contentView.frame = frame;
    frame.origin.y -= frame.size.height;
    
    self.backBlackView.alpha = 0;
    [UIView animateWithDuration:kDuration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.backBlackView.alpha = 1;
        self.contentView.frame = frame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)dismiss:(id<UIViewControllerContextTransitioning>)transitionContext {
    __block CGRect frame = self.contentView.frame;
    [UIView animateWithDuration:kDuration/2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        frame.origin.y += frame.size.height+50;
        self.contentView.frame = frame;
    } completion:^(BOOL finished){
        self.contentView.frame = frame;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    [UIView animateWithDuration:kDuration * 2 / 7 animations:^{
        self.backBlackView.alpha = 0;
    }];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.animateSelector = @selector(present:);
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.animateSelector = @selector(dismiss:);
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    // 保证非交互动画时返回的是nil。
    return nil;
}


#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return kDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:self.animateSelector withObject:transitionContext];
#pragma clang diagnostic pop
}

@end


@implementation DTPopBackView

- (instancetype)initWithPointRect:(CGRect)rect{
    if (self = [super init]) {
        self.rect = rect;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if (CGRectContainsPoint(self.rect, point)) {
        return YES;
    } else {
        if (self.dismiss) {
            self.dismiss();
        }
        return NO;
    }
}


@end
