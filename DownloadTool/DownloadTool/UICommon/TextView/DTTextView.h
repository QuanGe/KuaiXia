//
//  DTTextView.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DTTextView : UITextView

@property (nonatomic, copy)   NSString *placeholder;
@property (nonatomic, strong) UIColor *placeColor;

@end

NS_ASSUME_NONNULL_END
