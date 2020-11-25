//
//  DTMineTableCell.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DTMineTableCell : UITableViewCell

+ (CGFloat)getMineCellHeight;
+ (instancetype)cellMineTableWithTable:(UITableView*)tableView;

- (void)cellTitle:(NSString*)title imgName:(NSString*)imgName;

@end

NS_ASSUME_NONNULL_END
