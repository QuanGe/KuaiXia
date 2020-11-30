//
//  DTBrowserTabView.h
//  DownloadTool
//
//  Created by WSL on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class DTBrowserTabView;
@protocol DTBrowserTabViewDelegate <NSObject>

@optional
- (void)tabLeftTab:(DTBrowserTabView*)tabView;
- (void)tabRightTab:(DTBrowserTabView*)tabView;
- (void)tabHomeTab:(DTBrowserTabView*)tabView;
- (void)tabMoreTab:(DTBrowserTabView*)tabView;
- (void)tabMenuTab:(DTBrowserTabView*)tabView;
- (void)tabScreenTab:(DTBrowserTabView*)tabView;

@end

@interface DTBrowserTabView : UIView

@property (nonatomic, weak) id<DTBrowserTabViewDelegate> delegate;

/**后退*/
- (void)updateTabCanBack:(BOOL)canBack;
/**前进*/
- (void)updateTabCanForward:(BOOL)canForward;


@end

NS_ASSUME_NONNULL_END
