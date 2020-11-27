//
//  DTCommonHelper.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTCommonHelper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation DTCommonHelper

//获取隐藏文件夹的名字
+ (NSString *)getHideFileName{
    return @".download";
}


//md5
+ (NSString *)md5Encrypt:(NSString *)source {
    const char *original_str = [source UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (uint32_t)(strlen(original_str)), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}


//保存的路径
+ (NSString *)saveFileDirectorWithFileName:(NSString*)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *dbDirPath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"downloadFile/%@", fileName]];
    if (![fileManage fileExistsAtPath:dbDirPath]) {
        BOOL isSuccess = [fileManage createDirectoryAtPath:dbDirPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isSuccess) {
            return nil;
        }
    }
    return [NSString stringWithFormat:@"%@/", dbDirPath];
}

//临时下载文件夹路径
+ (NSString *)getDoownHideDirectorWithFileName:(NSString*)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *dbDirPath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@".tempFile/%@", fileName]];
    if (![fileManage fileExistsAtPath:dbDirPath]) {
        BOOL isSuccess = [fileManage createDirectoryAtPath:dbDirPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isSuccess) {
            return nil;
        }
    }
    return [NSString stringWithFormat:@"%@/", dbDirPath];
}


/**
 根据url 获取临时文件的路径
 */
+ (NSString *)getTempFilepathWithUrl:(NSString*)url{
    if (url.length == 0) {
        return @"";
    }
    //根据url获取md5
    NSString *md5 = [DTCommonHelper md5Encrypt:url];
    //拼接文件的路径
    NSString *result = [DTCommonHelper getDoownHideDirectorWithFileName:md5];

    //
    return result;
}

//根据url 获取保存文件的路径
+ (NSString *)getSaveFilepathWithUrl:(NSString*)url{
    if (url.length == 0) {
        return @"";
    }
    //根据url获取md5
    NSString *md5 = [DTCommonHelper md5Encrypt:url];
    //拼接文件的路径
    NSString *result = [DTCommonHelper saveFileDirectorWithFileName:md5];

    //
    return result;
}


//时间戳转时间
+ (NSString *)convertStrToTime:(int64_t)timeVal{
    if (timeVal == 0) {
        return @"";
    }
    //    如果服务器返回的是13位字符串，需要除以1000，否则显示不正确(13位其实代表的是毫秒，需要除以1000)
    if (sizeof(timeVal) > 13) {
        timeVal = timeVal / 1000;
    }
    
    
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:timeVal];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *timeString = [formatter stringFromDate:date];
    
    return timeString;
}

//根据路径获取文件大小
+ (CGFloat)getFileSizeWithFilePath:(NSString*)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//获取数字的MB,GB,KB
+ (NSString *)getContentSizeWithTotalSize:(CGFloat)totalSize{

    long kb = 1024;
    long mb = kb * 1024;
    long gb = mb * 1024;
    
    NSString *str;
    if (totalSize <= 0) {
        return @"0.0B";
    } else if (totalSize >= gb) {
        float f = (float)totalSize/gb;
        str = [NSString stringWithFormat:@"%.1fGB", f];
    } else if (totalSize >= mb) {
        float f = (float)totalSize/mb;
        str = [NSString stringWithFormat:@"%.1fMB", f];
    } else {
        float f = (float)totalSize/kb;
        str = [NSString stringWithFormat:@"%.1fKB", f];
    }
    
    return str;
}


//下载文件夹路径
+(NSString *)hasHideDBFile{
    NSString *name = @".DB";
    NSString *path_document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *hidePath = [path_document stringByAppendingPathComponent:name];
    
    //创建一个隐藏的文件夹
    if ([[NSFileManager defaultManager] fileExistsAtPath:hidePath] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:hidePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return name;
}


/**判断是否为url*/
+ (BOOL)isUrl:(NSString*)url{
    if(url.length < 1)
        return NO;
    if (url.length > 4 && [[url substringToIndex:4] isEqualToString:@"www."]) {
        url = [NSString stringWithFormat:@"http://%@",url];
    } else {
        url = url;
    }
    
    NSString *urlRegex = @"(https|http|ftp|rtsp|igmp|file|rtspt|rtspu)://((((25[0-5]|2[0-4]\\d|1?\\d?\\d)\\.){3}(25[0-5]|2[0-4]\\d|1?\\d?\\d))|([0-9a-z_!~*'()-]*\\.?))([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\.([a-z]{2,6})(:[0-9]{1,4})?([a-zA-Z/?_=]*)\\.\\w{1,5}";
    
    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    
    return [urlTest evaluateWithObject:url];
}



/**根据时间获取问候*/
+ (NSString *)getHellowText{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour;
    
    //获得当前日期的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSInteger hour = nowCmps.hour;
    
    //判断时间
    NSString *result;
    if (hour < 6) {
        result = @"凌晨好";
    } else if (hour < 9) {
        result = @"早上好";
    } else if (hour < 12) {
        result = @"上午好";
    } else if (hour < 14) {
        result = @"中午好";
    } else if (hour < 17) {
        result = @"下午好";
    } else if (hour < 19) {
        result = @"傍晚好";
    } else if (hour < 22) {
        result = @"晚上好";
    } else {
        result = @"夜里好";
    }
        
    return result;
}


//识别二维码
+ (NSString *)messageFromQRCodeImage:(UIImage *)image{
    if (!image) {
        return nil;
    }
    //创建上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    //识别类型设置为二维码，精度设为高
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    //转换image
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    //获取识别结果
    NSArray *features = [detector featuresInImage:ciImage];
    
    if (features.count == 0) {
        return nil;
    }
    
    CIQRCodeFeature *feature = features.firstObject;
    return feature.messageString;
}

@end
