//
//  DTDownListTableCell.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DTDownloadModel;
@interface DTDownListTableCell : UITableViewCell

@property (nonatomic, strong) DTDownloadModel *itemModel;

+ (CGFloat)getListCellHeight;
+ (instancetype)cellListTableWithTable:(UITableView*)tableView;

@end

NS_ASSUME_NONNULL_END
