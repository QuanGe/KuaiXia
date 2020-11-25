//
//  DTSearchToolView.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DTSearchToolView;
@protocol DTSearchToolViewDelegate <NSObject>

@optional
- (void)cancelInputView:(DTSearchToolView*)toolView;
- (void)searchDoneInputText:(NSString*)inputText;

@end

@interface DTSearchToolView : UIView

@property (nonatomic, weak) id<DTSearchToolViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
