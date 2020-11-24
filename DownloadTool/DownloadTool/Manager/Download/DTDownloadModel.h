//
//  DTDownloadModel.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, DTWSLDownLoadStatus){
    DTWSLDownLoad_Pause = 0,   //暂停
    DTWSLDownLoad_Loading,     //下载中
    DTWSLDownLoad_Complete,    //完成
    DTWSLDownLoad_Failed,      //失败
    DTWSLDownLoad_FileDeleted, //文件已删除
    DTWSLDownLoad_TaskDelete   //任务已删除
};

@interface DTDownloadModel : NSObject

@property (copy, nonatomic)   NSString *downloadUrl;                //下载url
@property (copy, nonatomic)   NSString *downloadCookie;             //cookie
@property (copy, nonatomic)   NSString *downloadType;               //下载类型
@property (copy, nonatomic)   NSString *downloadSavePath;           //文件保存的路径
@property (copy, nonatomic)   NSString *downloadFileName;           //文件名字
@property (assign, nonatomic) DTWSLDownLoadStatus downloadStatus;    //状态
@property (assign, nonatomic) uint64_t downloadTotleSize;           //文件大小
@property (assign, nonatomic) uint64_t downloadAlreadySize;         //已经下载大小
@property (assign, nonatomic) double createdDate;                   //创建日期

+ (DTDownloadModel*)defaultDwonloadModel;

@end

NS_ASSUME_NONNULL_END
