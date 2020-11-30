//
//  DTHistoryTableViewCell.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/30.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DTHistoryModel;
@interface DTHistoryTableViewCell : UITableViewCell

@property (nonatomic, strong) DTHistoryModel *model;

+ (CGFloat)getHistoryCellHeight;
+ (instancetype)cellHistoryTableWithTable:(UITableView*)tableView;

@end

NS_ASSUME_NONNULL_END
