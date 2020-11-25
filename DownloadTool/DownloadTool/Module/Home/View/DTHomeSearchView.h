//
//  DTHomeSearchView.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kSearchViewHeight       (NavigationBarHeight + 10)

@interface DTHomeSearchView : UIView

@property (nonatomic, copy) void(^clickSearchBlock)(void); //点击搜索
@property (nonatomic, copy) void(^clickScanBlock)(void);    //点击二维码

@end

NS_ASSUME_NONNULL_END
