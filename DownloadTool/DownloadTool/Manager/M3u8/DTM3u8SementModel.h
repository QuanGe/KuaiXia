//
//  DTM3u8SementModel.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/12/2.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DTM3u8SementModel : NSObject

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSString *duration;       //时长
@property (nonatomic, copy)   NSString *locationUrl;    //url

@end

NS_ASSUME_NONNULL_END
