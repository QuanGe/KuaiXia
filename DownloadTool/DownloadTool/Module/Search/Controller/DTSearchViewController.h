//
//  DTSearchViewController.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DTSearchViewController : DTBaseViewController

@property (nonatomic, strong) DTBaseViewController *parsentVC;
@property (nonatomic, copy)   NSString *addressStr;

@end

NS_ASSUME_NONNULL_END
