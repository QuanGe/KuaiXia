//
//  DTScanViewController.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class DTScanViewController;
@protocol DTScanViewControllerDelegate <NSObject>

@optional
- (void)pickUpMessage:(NSString *)message;

@end


@interface DTScanViewController : DTBaseViewController

@property (nonatomic, weak) id <DTScanViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
