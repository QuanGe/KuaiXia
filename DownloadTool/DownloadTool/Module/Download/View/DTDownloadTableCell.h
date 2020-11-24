//
//  DTDownloadTableCell.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DTDownloadTableCell : UITableViewCell

+ (CGFloat)getDownCellHeight;
+ (instancetype)cellDownloadTableWithTable:(UITableView*)tableView;


@end

NS_ASSUME_NONNULL_END
