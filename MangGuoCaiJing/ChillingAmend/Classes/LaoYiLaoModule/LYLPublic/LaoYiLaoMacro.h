//
//  LaoYiLaoMacro.h
//  LaoYiLao
//
//  Created by sunsu on 15/10/29.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#ifndef LaoYiLaoMacro_h
#define LaoYiLaoMacro_h

#import "LaoYiLaoBaseViewController.h"
#import "LaoYiLao_URL.h"
#import "LYLAFNetWorking.h"
#import "LYLHttpTool.h"
#import "AFNetworking.h"
#import "UIViewController+HUD.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "ZHDataBase.h"
#import "UIView+Extension.h"
#import "MJRefresh.h"
#import "LYLTools.h"
#import "ZHLoginInfoManager.h"
#import "Reachability.h"
#import "MBProgressHUD.h"


#define TARGET_IPHONE_DEBUG   //ZHLog打印开关，打开即可打印

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IS_IPHONE6_PLUS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//永久保存的数据
#define MySetObjectForKey(object,key) [[NSUserDefaults standardUserDefaults]setObject:object forKey:key]//赋值
#define MyObjectForKey(key) [[NSUserDefaults standardUserDefaults]objectForKey:key]//取值
#define IsStrWithNUll(str) [str isEqualToString:@""] || !str || [str isEqual:[NSNull null]]
#define IsStrWithNONull(str) ![str isEqual:@""] && str //不为空
 //判断为空

//是不是第一次进入应用
#define IsFirstKey @"IsFirstKey"//是不是第一次的key
#define IsFirstYES @"1"//是第一次
#define IsFirstNO @"0"//不是第一次





#define UserIDKey @"UserIDKey"//登陆人userid保存的key
#define LoginPhoneKey @"LoginPhoneKey"//登录人手机号key

#define LYLUserId  MyObjectForKey(UserIDKey) //登陆的UserId（NSNumber类型） [NSString stringWithFormat:@"%@",MyObjectForKey(UserIDKey)]  
#define LYLPhone   MyObjectForKey(LoginPhoneKey)//登陆的手机号
#define LYLIsLoging IsStrWithNONull(LYLUserId)//已登陆

//分享界面类型
#define ShareTypeKey @"ShareTypeKey"
#define ShareTypeWithBounce @"1"// 弹框上的分享增加次数
#define ShareTypeWithNavBarLaoYiLao @"2"//导航捞一捞的分享
#define ShareTypeWithMyDumpling @"3"//我得饺子炫耀一下分享
#define ShareTypeWithMakeMoney @"4"//包饺子分享链接
#define ShareTypeWithNavBarMakeDumpling @"5"

#define DumplingTheLastTimeKey @"DumplingTimeKey" // 上一次捞饺子时间


#define kkViewWidth [[UIScreen mainScreen] bounds].size.width
#define kkViewHeight [[UIScreen mainScreen] bounds].size.height
#define KPercenX    (kkViewWidth /320.0)
#define KPercenY    (kkViewHeight /568.0)

#define ScaleForHeight    (kkViewHeight /480.0)

#define NavgationBarHeight 64
#define CustomViewHeight  (kkViewHeight-NavgationBarHeight)

#define TabBarHeight 60
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define BackColor [UIColor colorWithPatternImage:[LYLTools scaleImage:[UIImage imageNamed:@"laojiaozi_mengban"] ToSize:CGSizeMake(kkViewWidth, kkViewHeight)]]

#define UIFont10 [UIFont systemFontOfSize:5]
#define UIFont18 [UIFont systemFontOfSize:9]
#define UIFont20 [UIFont systemFontOfSize:10]
#define UIFont22 [UIFont systemFontOfSize:11]

#define UIFont24 [UIFont systemFontOfSize:12]
#define UIFont26 [UIFont systemFontOfSize:13]
#define UIFont28 [UIFont systemFontOfSize:14]
#define UIFont30 [UIFont systemFontOfSize:15]
#define UIFont32 [UIFont systemFontOfSize:16]
#define UIFont36 [UIFont systemFontOfSize:18]
#define UIFont40 [UIFont systemFontOfSize:20]
#define UIFont50 [UIFont systemFontOfSize:25]

#define UIFontBild58 [UIFont boldSystemFontOfSize:26]
#define UIFontBild60 [UIFont boldSystemFontOfSize:30]
#define UIFontBild64 [UIFont boldSystemFontOfSize:32]
#define UIFontBild80 [UIFont boldSystemFontOfSize:40]
#define UIFontBild34 [UIFont boldSystemFontOfSize:17]
//#define UIFontBild40 [UIFont boldSystemFontOfSize:20]
#define UIFontBild30 [UIFont boldSystemFontOfSize:15]

#define PosterHeight   0  // KPercenY * 140/2
#define SelectSwitchX 5

//#define SwitchHeight  KPercenY * 62 / 2
#define TopHeight 10
#define SwitchHeight   62 / 2


#define SessionValue [LYLTools getPhoneUuid]  //手机IMEI
#define SysType  @"3"    //手机系统是iOS


#define BackRedColor RGBACOLOR(192, 21, 31, 1)

#define NoTypeJiaozi @"Jiaozi"     //没有捞到饺子时显示页面的参数
#define NoTypeCounpon @"Counpon"   //没有捞到优惠券时显示页面的参数
#define NoTypeGreetCard  @"MyGreetCard"   //没有捞到贺卡时显示的参数
#define NoTypeBaoJiaozi  @"NoBaoJiaozi"   //没有捞到饺子时显示的参数
#define NoTypeBaoHeka    @"NoBaoHeka"    //没有包贺卡饺子时显示的参数


#define WoBaoGreetCard  @"我包贺卡"   //跳转到我包贺卡界面的标识
#define WoBaoCash       @"我包现金"    //跳转到我包现金界面的标识


#endif /* LaoYiLaoMacro_h */
