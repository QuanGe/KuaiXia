//
//  DTHistoryViewController.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/30.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DTHistoryViewController : DTBaseViewController

@property (copy, nonatomic) void(^selHistoryBlock)(NSString *url);

@end

NS_ASSUME_NONNULL_END
