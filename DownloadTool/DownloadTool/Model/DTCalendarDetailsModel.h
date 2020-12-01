//
//  DTCalendarDetailsModel.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/12/1.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DTCalendarDetailsModel : NSObject

@property (nonatomic, strong) NSArray *day;
@property (nonatomic, strong) NSArray *dayInfo;
@property (nonatomic, strong) NSArray *yi;
@property (nonatomic, strong) NSArray *ji;
@property (nonatomic, strong) NSArray *detail;

@end

NS_ASSUME_NONNULL_END
