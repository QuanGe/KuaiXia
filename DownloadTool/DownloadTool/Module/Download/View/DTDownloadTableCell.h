//
//  DTDownloadTableCell.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DTDownloadModel;
@interface DTDownloadTableCell : UITableViewCell

@property (nonatomic, strong) DTDownloadModel *itemModel;

+ (CGFloat)getDownCellHeight;
+ (instancetype)cellDownloadTableWithTable:(UITableView*)tableView;

//刷新cell
- (void)reloadCell;
//进度和下载速度
- (void)setProgressWithProgress:(int64_t)progress speed:(double)speed;

@end

NS_ASSUME_NONNULL_END
