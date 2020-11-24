//
//  DTMacroHeader.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/24.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#ifndef DTMacroHeader_h
#define DTMacroHeader_h

#define SCREEN_SIZE                 [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH                SCREEN_SIZE.width
#define SCREEN_HEIGHT               SCREEN_SIZE.height
#define SCREEN_SCALE                [UIDevice currentDevice].screenScale
#define kStatusRect                 [[UIApplication sharedApplication] statusBarFrame]
#define kStatusHeight               kStatusRect.size.height


#define LL_IS_IPHONEX_XS            (LL_IS_IPHONE && SCREEN_HEIGHT == 812.f)      //是否是iPhoneX、iPhoneXS
#define LL_IS_IPHONEXR_XSMax        (LL_IS_IPHONE && SCREEN_HEIGHT == 896.f)      //是否是iPhoneXR、iPhoneX Max
#define IS_IPHONEX_SET              (LL_IS_IPHONEX_XS||LL_IS_IPHONEXR_XSMax)      //是否是iPhoneX系列手机

#define LL_SafeAreaTopHeight        (SCREEN_HEIGHT >= 812.0 ? 88 : 64)
#define LL_SafeAreaTopStatusBar     (SCREEN_HEIGHT >= 812.0 ? 44 : 20)
#define LL_SafeAreaBottomHeight     (SCREEN_HEIGHT >= 812.0 ? 34 : 0)
#define HEIGHT_TABBAR                49 // 标签
#define NavigationBarHeight         (44.f + LL_SafeAreaTopStatusBar)

#define DTRGB(r, g, b)              [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define DTColor(r, g, b, a)         [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define DTHexColor(rgbValue)        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define DTHexColorA(rgbValue,__a)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:__a]

#define kBaseColor                  DTRGB(252,205,12)

#endif /* DTMacroHeader_h */
