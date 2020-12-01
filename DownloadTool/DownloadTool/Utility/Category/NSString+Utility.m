//
//  NSString+Utility.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "NSString+Utility.h"

@implementation NSString (Utility)

/**url编码*/
- (NSString *)encodeString {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"];
    NSString *ret = [self stringByAddingPercentEncodingWithAllowedCharacters:set];
    return ret;
}

/**根据字符串生成条形码码*/
- (UIImage *)loadBarCodeImg{
    //  条形码
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    CIImage *img_CIImage = [self creatCodeImageFilter:filter];
    
    CGFloat scaleX = 300 / img_CIImage.extent.size.width;//300是你想要的长
    CGFloat scaleY = 70 / img_CIImage.extent.size.height;//70是你想要的宽
    img_CIImage = [img_CIImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
        
    UIImage *imager = [UIImage imageWithCIImage:img_CIImage];
    
    return imager;
}

/**根据字符串生成二维码*/
- (UIImage *)loadQRCodeImg{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    CIImage *img_CIImage = [self creatCodeImageFilter:filter];
    
    //此时获得的二维码图片比较模糊，通过下面函数转换成高清
    UIImage *image = [self changeImageSizeWithCIImage:img_CIImage andSize:180];
    
    return image;
}

- (CIImage *)creatCodeImageFilter:(CIFilter*)filter{
    //将字符串转出NSData
    NSData *img_data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    //将字符串变成二维码滤镜
    //filter
    
    //恢复滤镜的默认属性
    [filter setDefaults];
    
    //设置滤镜的 inputMessage
    [filter setValue:img_data forKey:@"inputMessage"];
    
    //获得滤镜输出的图像
    CIImage *img_CIImage = [filter outputImage];
    
    return img_CIImage;
}

//拉伸二维码图片，使其清晰
- (UIImage *)changeImageSizeWithCIImage:(CIImage *)ciImage andSize:(CGFloat)size{
    CGRect extent = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

@end

