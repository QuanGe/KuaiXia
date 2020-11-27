//
//  DTTabManager.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/27.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTTabManager.h"

@interface DTTabManager()

@end

@implementation DTTabManager

+ (instancetype)shareInstance{
    static DTTabManager _manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _manager = [[DTTabManager alloc] init];
    });
    return _manager;
}

@end
