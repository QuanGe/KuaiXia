//
//  NSString+Utility.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "NSString+Utility.h"

@implementation NSString (Utility)

- (NSString *)encodeString {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"];
    NSString *ret = [self stringByAddingPercentEncodingWithAllowedCharacters:set];
    return ret;
}

@end

