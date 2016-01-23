//
//  QBCommonlyUsedHeader.h
//  GongYong
//
//  Created by yll on 15/11/10.
//  Copyright © 2015年 DengLu. All rights reserved.
//

#ifndef QBCommonlyUsedHeader_h
#define QBCommonlyUsedHeader_h
#import "NSObject+SBJSON.h"
#import "UIView+Tool.h"
#import "SINOAFNetWorking.h"
#import "ActivityClientAPI.h"
#import "MyNetworkRequests.h"
#import "LogInAPP.h"
#import "SaveMessage.h"
#import"JPCommonMacros.h"
#import "WalletHome.h"
#import "GCUtil.h"
#import "SINOAFNetWorking.h"
#import "WalletRequsetHttp.h"

#import "LaoYiLaoMacro.h"
#import <UIKit/UIKit.h>
#import "LYLTools.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "ZHLoginInfoManager.h"

// 判断是否为iOS7以上系统
#define iOS7 ([UIDevice currentDevice].systemVersion.doubleValue >= 7.0)

// 判断是否为iOS8以上系统
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

// 取屏幕宽、高
#define SCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT  ([[UIScreen mainScreen] bounds].size.height)

/*产品标示*/
#define LOGO @"XN01_GZTV_GZ"
//#define LOGO @"XN01_ZTTV_HZT"


#endif /* QBCommonlyUsedHeader_h */
