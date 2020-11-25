//
//  DTSeatchHistoryModel.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DTSeatchHistoryModel : NSObject

@property (nonatomic, copy)   NSString *title;          //输入的内容
@property (assign, nonatomic) double createdDate;       //创建日期

+ (DTSeatchHistoryModel*)defaultHistoryModel;

@end

NS_ASSUME_NONNULL_END
