//
//  DTHistoryModel.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/30.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTDBModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DTHistoryModel : DTDBModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (assign, nonatomic) double createdDate;       //创建日期

@end

NS_ASSUME_NONNULL_END
