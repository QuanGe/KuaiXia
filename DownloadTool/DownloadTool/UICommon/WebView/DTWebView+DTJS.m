//
//  DTWebView+DTJS.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTWebView+DTJS.h"

@implementation DTWebView (DTJS)

//MARK: - 暂停视频
- (void)jsToPauseVideo{
    //针对iframe中的视频
    NSString *frameJs = @"\
    var iframe = document.getElementsByTagName('iframe');\
    for(var j = 0; j < iframe.length;j++) {\
        var iframeDocument = iframe[j].contentWindow.document;\
        var videos = iframeDocument.getElementsByTagName('video');\
        for (var i = 0; i < videos.length; i++) {\
            videos[i].pause();\
        }\
    }";
    [self evaluateJavaScript:frameJs completionHandler:nil];
    
    //
    NSString *videoJs = @"\
    var videos = document.getElementsByTagName('video');\
    for (var i = 0; i < videos.length; i++) {\
        videos[i].pause();\
    }";
    [self evaluateJavaScript:videoJs completionHandler:nil];
}


@end
