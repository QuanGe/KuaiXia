//
//  DTSeatchHistoryModel.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTSeatchHistoryModel.h"

@implementation DTSeatchHistoryModel

+ (DTSeatchHistoryModel*)defaultHistoryModel{
    DTSeatchHistoryModel *model = [[DTSeatchHistoryModel alloc] init];
    model.title       = @"";
    model.createdDate = [[NSDate date] timeIntervalSince1970];
    return model;
}

@end
