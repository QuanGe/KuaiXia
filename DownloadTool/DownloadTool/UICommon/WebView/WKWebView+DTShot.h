//
//  WKWebView+DTShot.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/30.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SnapCompletion) (UIImage *snapImg);

@interface WKWebView (DTShot)

- (void)snapContentWithCompletion:(SnapCompletion)completion;

@end

NS_ASSUME_NONNULL_END
