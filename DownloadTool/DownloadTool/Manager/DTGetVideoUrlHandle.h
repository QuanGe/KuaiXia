//
//  DTGetVideoUrlHandle.h
//  DownloadTool
//
//  Created by wsl on 2020/11/23.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CompletaionBlack)(NSString * _Nullable videoUrl);

@interface DTGetVideoUrlHandle : NSObject

+ (instancetype)shared;

/**
 * url  获取连接中的视频地址
 * 完成回调视频的地址
 */
- (void)getVideoUrlWithUrl:(NSString*)url completaion:(CompletaionBlack)completaion;

@end

NS_ASSUME_NONNULL_END
