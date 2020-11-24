//
//  DTDownManager.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTDownManager.h"
#import "DTDownloadObject.h"
#import "DTDoownloadDBHelper.h"

@interface DTDownManager()

@property (nonatomic, strong) NSMutableDictionary<NSString *, DTDownloadObject *> *downloadObjectes;    //记录下载

@end

@implementation DTDownManager

+ (instancetype)shareInstance{
    static id sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init{
    if (self = [super init]) {
        self.downloadObjectes = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc{
    NSLog(@"DTDownManager ==> DTDownManager");
}

#pragma mark - Helper
//需要在DTDownloadObject下载完成后，调用的方法
- (void)removeDownloadTask:(DTDownloadObject *)downloadTask {
    [self.downloadObjectes removeObjectForKey:downloadTask.downloadUrl];
}
//根据url去查找下载任务
- (DTDownloadObject *)findDownloadObjectByUrl:(NSString *)url{
    return [self.downloadObjectes objectForKey:url];
}

// 根据url判断是否已下载
- (BOOL)hasDownload:(NSString *)downloadUrl{
    DTDownloadModel *model = [[DTDoownloadDBHelper sharedDB] getSelModelUrl:downloadUrl];
    if (model) {
        return YES;
    }
    return NO;
}

#pragma mark - Start
- (void)startDowload:(NSString *)downloadUrl withSuggestionName:(NSString *)fileName withMIMEType:(NSString *)mimeType cookie:(NSString *)cookie{
    //创建
    DTDownloadObject *downObj = [self findDownloadObjectByUrl:downloadUrl];
    if (downObj) {
        //判断下载状态
        if (downObj.downloadStatus == DTWSLDownLoad_Loading) {
            return;
        }
    } else {
        //没有任务,去创建任务
        __weak __typeof(self) weakSelf = self;
        downObj = [[DTDownloadObject alloc] initWithUrl:downloadUrl withSuggestionName:fileName withMIMEType:mimeType cookie:cookie manager:self completion:^{
            //
            NSInteger filenameLengthLimit = 20;
            NSString *toastFileName = fileName.length > filenameLengthLimit ? [NSString stringWithFormat:@"%@...", [fileName substringToIndex:filenameLengthLimit]] : fileName;
            //[GRHUD showLoadingWithStatus:[NSString stringWithFormat:@"%@ 下载完成", toastFileName]];
            NSLog(@"%@ 下载完成", toastFileName);
            
            //任务完成后，移除掉
            [weakSelf removeDownloadTasFile:downloadUrl];
        }];
        //添加任务
        [self.downloadObjectes setObject:downObj forKey:downloadUrl];
    }
    
    //开始下载
    [downObj startDownload];
}

#pragma mark - Stop
/**暂停下载*/
- (void)pauseDownload:(DTDownloadModel *)fileModel{
    DTDownloadObject *downObj = [self findDownloadObjectByUrl:fileModel.downloadUrl];
    if (downObj) {
        [downObj pauseDownload];
    } else {
        //没有的话，说明没有在任务列表中，添加到人去列表中
        [self startDowload:fileModel.downloadUrl withSuggestionName:fileModel.downloadFileName withMIMEType:fileModel.downloadType cookie:fileModel.downloadCookie];
    }
}

/**杀死app前，下载列表暂停*/
- (void)pauseDownloadList{
    NSArray *allKeys = self.downloadObjectes.allKeys;
    for (NSString *key in allKeys) {
        DTDownloadObject *dobj = [self.downloadObjectes objectForKey:key];
        if (dobj) {
            [dobj pauseDownload];
        }
    }
}

#pragma mark - Delete
//根据url删除任务
- (void)removeDownloadTasFile:(NSString *)downloadUrl{
    DTDownloadObject *downObj = [self findDownloadObjectByUrl:downloadUrl];
    [downObj pauseDownload];
    [self.downloadObjectes removeObjectForKey:downloadUrl];
}

//移除文件 (删除任务，删除文件，删除数据库中的记录)
- (void)removeDownloadFile:(NSString *)downloadUrl {
    [self removeDownloadFile:downloadUrl completion:^{ }];
}
- (void)removeDownloadFile:(NSString *)downloadUrl completion: (void (^)(void))completion{
    //找到下载，去暂停
    DTDownloadObject * downObj = [self findDownloadObjectByUrl:downloadUrl];
    [downObj pauseDownload];
    
    //移除任务
    [self.downloadObjectes removeObjectForKey:downloadUrl];
    
    //数据库中查找
    DTDownloadModel *model = [[DTDoownloadDBHelper sharedDB] getSelModelUrl:downloadUrl];
    if (model) {
        //移除文件
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:model.downloadSavePath error:nil];
        
        //数据库中删除
        [[DTDoownloadDBHelper sharedDB] deleteItem:model];
    }
    
    //
    if (completion) {
        completion();
    }
}


@end
