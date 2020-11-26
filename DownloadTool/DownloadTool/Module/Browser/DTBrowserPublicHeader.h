//
//  DTBrowserPublicHeader.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/26.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#ifndef DTBrowserPublicHeader_h
#define DTBrowserPublicHeader_h

NSString *const kBrowser_loading      = @"loading";
NSString *const kBrowser_Progress     = @"estimatedProgress";
NSString *const kBrowser_URL          = @"URL";
NSString *const kBrowser_Title        = @"title";
NSString *const kBrowser_CanGoBack    = @"canGoBack";
NSString *const kBrowser_CanGoForward = @"canGoForward";

NSArray* kBrowserPaths() {
    return @[kBrowser_loading,
             kBrowser_Progress,
             kBrowser_URL,
             kBrowser_Title,
             kBrowser_CanGoBack,
             kBrowser_CanGoForward];
}

#endif /* DTBrowserPublicHeader_h */
