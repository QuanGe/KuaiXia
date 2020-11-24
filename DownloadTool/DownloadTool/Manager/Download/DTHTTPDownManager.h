//
//  DTHTTPDownManager.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SessionDownBlack)(NSError *__nullable error, id __nullable responseObject, NSURLResponse * _Nullable response);

@interface DTHTTPDownManager : NSObject

+ (instancetype)shareInstance;

/**head 请求*/
- (NSURLSessionDataTask *)headRequestWithUrl:(NSString*)url complation:(SessionDownBlack)complation;

@end

NS_ASSUME_NONNULL_END
