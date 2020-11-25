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

@end
