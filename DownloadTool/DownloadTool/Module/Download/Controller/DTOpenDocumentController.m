//
//  DTOpenDocumentController.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTOpenDocumentController.h"

@interface DTOpenDocumentController() <UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIViewController *currentVC;
@property (nonatomic, strong) DTOpenDocumentController *documentVC;

@end

@implementation DTOpenDocumentController

+ (void)openFileInOtherApplication:(NSURL *)fileURL controller:(UIViewController*)controller{
    DTOpenDocumentController *documentVC = [[DTOpenDocumentController alloc] initWithURL:fileURL];
    [documentVC presentViewController:controller animated:YES];
}


- (instancetype)initWithURL:(NSURL *)URL {
    if (self = [super init]) {
        self.URL = URL;
    }
    return self;
}

- (id<UIDocumentInteractionControllerDelegate>)delegate {
    id<UIDocumentInteractionControllerDelegate> delegate = [super delegate];
    if (!delegate) {
        delegate = self;
    }
    return delegate;
}

- (void)presentViewController:(UIViewController *)vcPresent animated:(BOOL)animated {
    self.documentVC = self;
    self.currentVC = vcPresent;
    BOOL canOpen = [self presentOpenInMenuFromRect:self.currentVC.view.bounds inView:self.currentVC.view animated:animated];
    if(!canOpen) {
        [DTProgressHUDHelper showMessage:@"沒有程序可以打开选中的文件"];
    }
}

#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self.currentVC;
}

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
    self.documentVC = nil;
}


@end
