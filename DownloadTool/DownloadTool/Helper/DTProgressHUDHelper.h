//
//  DTProgressHUDHelper.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DTProgressHUDHelper : NSObject

/**显示loading*/
+ (void)show;
/**移除loading*/
+ (void)dissMiss;
/**显示1秒文字*/
+ (void)showMessage:(NSString*)message;
/**显示3秒文字*/
+ (void)showLongMessage:(NSString*)message;
/**显示文字，自定时长*/
+ (void)showMessage:(NSString*)message time:(CGFloat)time;

@end

NS_ASSUME_NONNULL_END
