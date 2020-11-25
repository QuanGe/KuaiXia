//
//  DTOpenDocumentController.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DTOpenDocumentController : UIDocumentInteractionController

+ (void)openFileInOtherApplication:(NSURL *)fileURL controller:(UIViewController*)controller;

- (instancetype)initWithURL:(NSURL *)URL;
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
