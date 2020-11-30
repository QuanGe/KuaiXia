//
//  DTDownloadObject.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTDownloadObject.h"
#import "DTDownloadSession.h"
#import "DTCommonHelper.h"
#import "DTDoownloadDBHelper.h"
#import "DTDownManager.h"

@interface DTDownManager()
/**从下载任务中移除*/
- (void)removeDownloadTask:(DTDownloadObject *)downloadTask;
@end


@interface DTDownloadObject() <DTDownloadSessionDelegate>

@property (strong, nonatomic) DTDownloadSession *downloadTask;      //下载task
@property (weak,   nonatomic) DTDownManager *manager;               //下载管理
@property (nonatomic, copy)   NSString *savePath;                   //保存的路径
@property (nonatomic, strong) DTDownloadModel *downModel;           //下载model
@property (assign, nonatomic) int64_t fileTotalSize;                //文件的大小
@property (strong, nonatomic) NSString *contentType;                //文件类型
@property (strong, nonatomic) NSString *cookie;                     //文件Cookie
@property (copy  , nonatomic) dispatch_block_t completion;          //回调

@end

@implementation DTDownloadObject

- (id)initWithUrl:(NSString *)url withSuggestionName:(NSString *)fileName withMIMEType:(NSString *)mimeType cookie:(NSString *)cookie manager:(DTDownManager *)manager completion:(dispatch_block_t)completion{
    if (self = [super init]) {
        self.manager = manager;
        self.contentType = mimeType;
        self.downloadUrl = url;
        self.cookie = cookie;
        self.fileName = fileName;
        self.completion = completion;
        
        //路径拼接，url生成的文件夹路径 + 文件名字
        self.savePath = [NSString stringWithFormat:@"%@%@", [DTCommonHelper getTempFilepathWithUrl:url], fileName];
    }
    return self;
}


#pragma mark - Start Stop
/**开始下载*/
- (void)startDownload{
    //判断是否已经下载完
    if (self.downloadStatus == DTWSLDownLoad_Complete) {
        return;
    }
    
    //
    dispatch_async(dispatch_get_main_queue(), ^{
        //判断是否正在下载
        if ([self recordDownloadFileInfo]) {
            //请求
            NSMutableURLRequest *headRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.downloadUrl]];
            if (self.cookie.length > 0) {
                //[headRequest addValue:self.cookie forHTTPHeaderField:@"Cookie"];
            }
            
            //创建task
            self.downloadTask = [[DTDownloadSession alloc] initWithRequest:headRequest filePath:self.savePath];
            self.downloadTask.delegate = self;
            [self.downloadTask startDownload];
            
            //开始下载
            if ([self.manager.delegate respondsToSelector:@selector(downloadStarted:)]) {
                [self.manager.delegate downloadStarted:self];
            }
        }
    });
}

/**暂停下载*/
- (void)pauseDownload{
    //判断是否下载完成
    if (self.downloadStatus == DTWSLDownLoad_Complete) {
        return;
    }
    //取消下载
    [self.downloadTask cancelDownload];
    
    //修改状态
    if (self.downModel) {
        self.downModel.downloadStatus = DTWSLDownLoad_Pause;
        self.downModel.downloadAlreadySize = [self.downloadTask currentFileSize];
        [[DTDoownloadDBHelper sharedDownDB] saveItem:self.downModel];
    }
    
    //
    self.downloadTask = nil;
    
    //下载暂停
    if ([self.manager.delegate respondsToSelector:@selector(downloadPause:)]) {
        [self.manager.delegate downloadPause:self];
    }
}

#pragma mark - Taks
//判断是否正在下载
- (BOOL)recordDownloadFileInfo {
    //判断是否已经有下载了
    if (self.downModel == nil) {
        return [self createDownloadTask];
    }
    
    //判断状态是否完成
    if (self.downModel.downloadTotleSize && self.downModel.downloadAlreadySize == self.downModel.downloadTotleSize && self.downModel.downloadStatus != DTWSLDownLoad_Pause) {
        self.downModel.downloadStatus = DTWSLDownLoad_Complete;
    } else {
        self.downModel.downloadStatus = DTWSLDownLoad_Loading;
    }
    
    //更新数据
    [[DTDoownloadDBHelper sharedDownDB] saveItem:self.downModel];
    
    //判断是否正在下载
    return self.downModel.downloadStatus == DTWSLDownLoad_Loading;
}

//创建下载
- (BOOL)createDownloadTask{
    if (self.downModel) {
        return YES;
    }
    
    //根据url查找是否已经存在，没有就新建
    DTDownloadModel *model = [[DTDoownloadDBHelper sharedDownDB] getSelModelUrl:self.downloadUrl];
    if (model) {
        model.downloadStatus = DTWSLDownLoad_Pause;
        model.downloadCookie = self.cookie;
    } else {
        //创建新的
        model = [DTDownloadModel defaultDwonloadModel];
        model.downloadUrl       = self.downloadUrl;
        model.downloadCookie    = self.cookie;
        model.downloadType      = self.contentType;
        model.downloadSavePath  = self.savePath;
        model.downloadFileName  = self.fileName;
    }
    //保存
    [[DTDoownloadDBHelper sharedDownDB] saveItem:model];
    self.downModel = model;
    
    return YES;
}

//获取当前的状态
- (DTWSLDownLoadStatus)downloadStatus {
    if (self.downModel) {
        return self.downModel.downloadStatus;
    } else {
        return DTWSLDownLoad_Pause;
    }
}

#pragma mark - DTDownloadSessionDelegate
//请求成功
- (void)didReceiveRespond:(NSURLSessionDataTask *)task withRespondSize:(long long)fileSize{
    self.fileTotalSize = fileSize;
    self.downModel.downloadTotleSize = fileSize;
    self.downModel.downloadStatus = DTWSLDownLoad_Loading;
    
    [[DTDoownloadDBHelper sharedDownDB] saveItem:self.downModel];
}
//返回数据
- (void)didReceiveData:(NSURLSessionDataTask *)task withFileSize:(long long)fileSize withSpeed:(double)speed{
    if ([self.manager.delegate respondsToSelector:@selector(downloading:withSize:withSpeed:)]) {
        [self.manager.delegate downloading:self withSize:@(fileSize) withSpeed:@(speed)];
    }
}
//失败
- (void)failedDownload:(NSURLSessionTask *)task withFileSize:(long long)fileSize{
    self.downModel.downloadStatus = DTWSLDownLoad_Failed;
    self.downModel.downloadAlreadySize = fileSize;
    [[DTDoownloadDBHelper sharedDownDB] saveItem:self.downModel];
    
    
    //下载失败，回调，并从任务中移除
    if ([self.manager.delegate respondsToSelector:@selector(downloadFailed:)]) {
        [self.manager.delegate downloadFailed:self];
        [self.manager removeDownloadTask:self];
    }
}
//成功
- (void)didFinishDownload:(NSURLSessionTask *)task withFileSize:(long long)fileSize{
    if (self.downloadTask) {
        //判断完成的大小跟请求会来的大小是否一致
        if (fileSize < self.fileTotalSize) {
            //不一致，重新下载
            [self.downloadTask cancelDownload];
            [self startDownload];
        } else {
            //移动文件，把临时文件移动到下载文件夹中
            NSString *filePath = [DTCommonHelper getTempFilepathWithUrl:self.downloadUrl];
            NSString *newPath = [DTCommonHelper getSaveFilepathWithUrl:self.downloadUrl];
            
            
            NSArray *subPaths = [[NSFileManager defaultManager] subpathsAtPath:filePath];
            for (NSString *pathUrl in subPaths) {
                NSString *oldUrl = [NSString stringWithFormat:@"%@%@", filePath, pathUrl];
                NSString *newUrl = [NSString stringWithFormat:@"%@%@", newPath, pathUrl];
                
                NSError *error;
                [[NSFileManager defaultManager] moveItemAtPath:oldUrl toPath:newUrl error:&error];
                if (error) {
                    NSLog(@"error => %@", error);
                }
            }
            NSError *error;
            BOOL del = [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:filePath] error:&error];
            NSLog(@"删除%@:%@", del ? @"成功" : @"失败", error);
            
            
            //更新状态
            self.downModel.downloadAlreadySize = self.fileTotalSize;
            self.downModel.downloadStatus = DTWSLDownLoad_Complete;
            self.downModel.downloadSavePath = [NSString stringWithFormat:@"%@%@", newPath, self.fileName];
            [[DTDoownloadDBHelper sharedDownDB] saveItem:self.downModel];
            
            //下载完成后，回调，并从任务中移除
            [self.manager removeDownloadTask:self];
            
            
            //下载完成
            if ([self.manager.delegate respondsToSelector:@selector(downloadCompleted:)]) {
                [self.manager.delegate downloadCompleted:self];
            }
        }
    }
}

@end
