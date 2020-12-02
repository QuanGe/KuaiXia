//
//  DTM3u8Handler.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/12/2.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTM3u8Handler.h"
#import "DTM3u8SementModel.h"
#import "DTCommonHelper.h"

@implementation DTM3u8Handler

/**
 * 解码M3U8
 */
+ (void)praseUrl:(NSString *)urlStr handleBlcok:(M3u8HandleBlack)handleBlock{
    //判断是否是HTTP连接
    if (!([urlStr hasPrefix:@"http://"] || [urlStr hasPrefix:@"https://"])) {
        if (handleBlock) {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:200 userInfo:@{NSLocalizedDescriptionKey:@"url错误"}];
            handleBlock(error, nil);
        }
        return;
    }
    
    
    //解析出M3U8
    NSError *error = nil;
    NSStringEncoding encoding;
    NSString *m3u8Str = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr] usedEncoding:&encoding error:&error];

    if (m3u8Str == nil) {
        if (handleBlock) {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:210 userInfo:@{NSLocalizedDescriptionKey:@"未解析出M3U8"}];
            handleBlock(error, nil);
        }
        return;
    }
    
    
    //解析TS文件,起点
    NSRange segmentRange = [m3u8Str rangeOfString:@"#EXTINF:"];
    if (segmentRange.location == NSNotFound) {
        //M3U8里没有TS文件
        if (handleBlock) {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:220 userInfo:@{NSLocalizedDescriptionKey:@"没有TS文件"}];
            handleBlock(error, nil);
        }
        return;
    }
    
    //逐个解析TS文件，并存储
    NSMutableArray *arrM = [NSMutableArray array];
    while (segmentRange.location != NSNotFound) {
        //model
        DTM3u8SementModel *model = [[DTM3u8SementModel alloc] init];
        
        //读取TS片段时长
        NSRange commaRange = [m3u8Str rangeOfString:@",\n"];
        
        NSInteger valueLoc = segmentRange.location + segmentRange.length;
        NSInteger valueLen = commaRange.location - valueLoc;

        NSString *value = [m3u8Str substringWithRange:NSMakeRange(valueLoc, valueLen)];
        model.duration = value;
        
        //截取M3U8
        m3u8Str = [m3u8Str substringFromIndex:commaRange.location];
        //获取TS下载链接,这需要根据具体的M3U8获取链接，可以更具自己公司的需求
        NSRange linkRangeBegin = [m3u8Str rangeOfString:@",\n"];
        NSRange linkRangeEnd = [m3u8Str rangeOfString:@".ts"];
        
        NSInteger linkLoc = linkRangeBegin.location + linkRangeBegin.length;
        NSInteger linkLen = linkRangeEnd.location - linkLoc + linkRangeEnd.length;
        
        NSString* linkUrl = [m3u8Str substringWithRange:NSMakeRange(linkLoc, linkLen)];
        model.locationUrl = linkUrl;
        
        m3u8Str = [m3u8Str substringFromIndex:(linkRangeEnd.location + linkRangeEnd.length)];
        segmentRange = [m3u8Str rangeOfString:@"#EXTINF:"];
        
        //add
        [arrM addObject:model];
    }
    
    if (handleBlock) {
        handleBlock(nil, arrM.copy);
    }
}




/**下载完毕后，把所有的ts合并成一个，文件是m3u8urlMD5地址文件+文件.ts*/
+ (void)combM3u8Url:(NSString*)urlStr m3u8List:(NSArray*)m3u8List{
    //合成的路径
    NSString *fileName = @"合成文件.ts";
    NSString *filePath = [DTCommonHelper getSaveFilepathWithUrl:urlStr];
    
    //获取保存文件的路径
    NSMutableData *dataArrM = [NSMutableData data];
    for (DTM3u8SementModel *model in m3u8List) {
        NSString *tsPath = [DTCommonHelper getSaveFilepathWithUrl:model.locationUrl];
        
        NSData *tsData = [[NSData alloc] initWithContentsOfFile:tsPath];
    
        //append
        [dataArrM appendData:tsData];
    }

    
}

@end
