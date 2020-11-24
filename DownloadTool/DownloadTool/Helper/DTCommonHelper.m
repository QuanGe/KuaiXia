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

@end
