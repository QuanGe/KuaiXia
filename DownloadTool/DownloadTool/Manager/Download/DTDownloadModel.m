//
//  DTDownloadModel.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTDownloadModel.h"

@implementation DTDownloadModel

+ (DTDownloadModel*)defaultDwonloadModel{
    DTDownloadModel *model = [[DTDownloadModel alloc] init];
    model.downloadUrl           = @"";
    model.downloadCookie        = @"";
    model.downloadType          = @"";
    model.downloadSavePath      = @"";
    model.downloadFileName      = @"";
    model.createdDate           = [[NSDate date] timeIntervalSince1970];
    model.downloadStatus        = DTWSLDownLoad_Pause;
    model.downloadAlreadySize   = 0;
    return model;
}

@end
