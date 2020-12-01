//
//  NSString+Utility.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Utility)

/**url编码*/
- (NSString *)encodeString;

/**根据字符串生成条形码码*/
- (UIImage *)loadBarCodeImg;

/**根据字符串生成二维码*/
- (UIImage *)loadQRCodeImg;

@end

NS_ASSUME_NONNULL_END
