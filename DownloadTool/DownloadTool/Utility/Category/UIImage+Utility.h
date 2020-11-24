//
//  UIImage+Utility.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Utility)

//通过颜色生成一张图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
//给图片切割圆角
+ (UIImage *)setCornerWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius;
//根据颜色生成一张带圆角的图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;

/*
 UIView转化成UIImage
 */
+ (UIImage *)imageWithSourceView:(UIView *)sourceView;
+ (UIImage *)getImageFromView:(UIView *)orgView inRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
