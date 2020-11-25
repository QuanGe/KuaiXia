//
//  DTBrowserAdressView.h
//  DownloadTool
//
//  Created by WSL on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class DTBrowserAdressView;
@protocol DTBrowserAdressViewDelegate <NSObject>

@optional
- (void)didBackButtonView:(DTBrowserAdressView*)adressView;
- (void)didAdressButtonView:(DTBrowserAdressView*)adressView;
- (void)didRefreshButtonView:(DTBrowserAdressView*)adressView;

@end

@interface DTBrowserAdressView : UIView

@property (nonatomic, weak) id<DTBrowserAdressViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
