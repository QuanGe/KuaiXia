//
//  DTSearchHistoryView.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DTSeatchHistoryModel;
@protocol DTSearchHistoryViewDelegate <NSObject>

@optional
- (void)didSelectUrl:(NSString*)url;

@end

@interface DTSearchHistoryView : UIView

@property (nonatomic, weak)   id<DTSearchHistoryViewDelegate> delegate;

@end

@interface DTSearchHistoryTableCell : UITableViewCell

@property (nonatomic, strong) DTSeatchHistoryModel *itemModel;

+ (CGFloat)getHistoryCellHeight;
+ (instancetype)cellHistoryTableWithTable:(UITableView*)tableView;

@end

NS_ASSUME_NONNULL_END
