//
//  WKWebView+DTShot.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/30.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "WKWebView+DTShot.h"

@implementation WKWebView (DTShot)

- (void)snapContentWithCompletion:(SnapCompletion)completion {
    CGPoint offset = self.scrollView.contentOffset;
    //添加遮罩
    UIView *snapShotView = [self snapshotViewAfterScreenUpdates:YES];
    snapShotView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, snapShotView.frame.size.width, snapShotView.frame.size.height);
    [self.superview addSubview:snapShotView];
    
    self.scrollView.contentOffset = CGPointZero;
    
    [self snapContentWithoutOffsetCompletion:^(UIImage *snapImg) {
        self.scrollView.contentOffset = offset;
        
        [snapShotView removeFromSuperview];
        
        NSData *data = UIImageJPEGRepresentation(snapImg, 0.3);
        UIImage *resultImage = [UIImage imageWithData:data];
                
        completion(resultImage);
    }];
}

- (void)snapContentWithoutOffsetCompletion:(SnapCompletion)completion {
    
    UIView *containerView = [[UIView alloc]initWithFrame:self.bounds];
    
    CGRect bakFrame = self.frame;
    UIView *bakSuperView = self.superview;
    NSInteger bakIndex = [self.superview.subviews indexOfObject:self];
    
    [self removeFromSuperview];
    [containerView addSubview:self];
    
    self.frame = CGRectMake(0, 0, containerView.bounds.size.width, self.scrollView.contentSize.height);
    
    CGSize totalSize = self.scrollView.contentSize;
    float page = floorf(totalSize.height/containerView.bounds.size.height);
    UIGraphicsBeginImageContextWithOptions(totalSize, false, [UIScreen mainScreen].scale);
    
    [self contentPageDrawTargetView:containerView index:0 maxIndex:(int)page drawCallback:^{
        UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self removeFromSuperview];
        [bakSuperView insertSubview:self atIndex:bakIndex];
        
        self.frame = bakFrame;
        
        [containerView removeFromSuperview];
        
        completion(capturedImage);
    }];
}

- (void)contentPageDrawTargetView:(UIView *)targetView
                            index:(int)index
                         maxIndex:(int)maxIndex
                     drawCallback:(void(^)(void))drawCallback {
    
    CGRect splitFrame = CGRectMake(0, (float)index * targetView.frame.size.height, targetView.bounds.size.width, targetView.frame.size.height);
    
    CGRect myFrame = self.frame;
    myFrame.origin.y = - ((float)index * targetView.frame.size.height);
    self.frame = myFrame;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [targetView drawViewHierarchyInRect:splitFrame afterScreenUpdates:YES];
        
        if(index<maxIndex){
            [self contentPageDrawTargetView:targetView index:index + 1 maxIndex:maxIndex drawCallback:drawCallback];
        }else{
            drawCallback();
        }
    });
}


@end
