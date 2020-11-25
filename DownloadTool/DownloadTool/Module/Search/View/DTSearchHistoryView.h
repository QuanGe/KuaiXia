//
//  DTSearchHistoryView.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DTSearchHistoryView : UIView

@end

@interface DTSearchHistoryTableCell : UITableViewCell

+ (CGFloat)getHistoryCellHeight;
+ (instancetype)cellHistoryTableWithTable:(UITableView*)tableView;

@end

NS_ASSUME_NONNULL_END
