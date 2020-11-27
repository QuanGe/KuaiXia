//
//  DTMinePublicHeader.h
//  DownloadTool
//
//  Created by wangshuailong on 2020/11/25.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#ifndef DTMinePublicHeader_h
#define DTMinePublicHeader_h


typedef NS_OPTIONS(NSInteger, DTMineCellStatus){
    DTMineCellStatus_Download = 0,   //下载
    DTMineCellStatus_About,         //关于
    DTMineCellStatus_Help,          //帮助
    DTMineCellStatus_Message,          //帮助
    DTMineCellStatus_Shared,        //分享
    DTMineCellStatus_Good,          //好评
};

#endif /* DTMinePublicHeader_h */
