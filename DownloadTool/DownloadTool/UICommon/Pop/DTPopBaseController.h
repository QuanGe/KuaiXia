//
//  DTPopBaseController.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/27.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DTPopBaseController : DTBaseViewController

@property (nonatomic, strong) UIView *contentView;              //容器


@end

@interface DTPopBackView : UIView

@property (nonatomic, assign) CGRect rect;
@property (nonatomic, copy)   dispatch_block_t dismiss;

@end

NS_ASSUME_NONNULL_END
