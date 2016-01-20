//
//  ZHLoginInfoManager.h
//  LaoYiLao
//
//  Created by wzh on 15/11/30.
//  Copyright (c) 2015年 sunsu. All rights reserved.
//

#import <Foundation/Foundation.h>

//登陆的type
#define LOGINGTYPE 2 //1 只调java 2. 先调java后调php 不同app类型不同
#define ProductCode @"XN01_HNTV_MGCJ"   //每个app对应自己的产品标识

//应用需要传入的Key
/****   友盟分享  *****/
#define LYL_UM_KEY      @"56610d70e0f55a53c100372a"  //@"5328fbfa56240b9ada067458"
#define QQ_APPID        @"1104925879"  //"1101248410"
#define QQ_APPKEY       @"kdfAHKrtRukCA3fb"  //"c7394704798a158208a74ab60104f0ba"
#define WX_APPID        @"wx0bd20f42766c48ff"     //"wx1611bbef8acfa7ca"
#define WX_AppSecret    @"f6a1bc932df56c4fe0036f16f6f762d5"
#define WB_APPKEY       LYL_UM_KEY
#define OpenSSOWithRedirectURL @"http://sns.whalecloud.com/sina2/callback"



//Php登陆正式接口 不同app接口不同需要更改
//#define WZHLogingPHPWithUrl @"http://cqtv.sinosns.cn/app/"


//Php登陆测试接口 不同app接口不同需要更改
#define WZHLogingPHPWithUrl @"http://192.168.10.11:2043/app/"


@interface ZHLoginInfoManager : NSObject



/**
 *  保存PHP登陆信息
 *
 *  @param json PHP登陆成功后返回的信息
 */
+ (void)addSavePHPCacheInLoginWithJson:(id)json;
/**
 *  保存java登陆信息
 *
 *  @param json  java登陆成功后返回的信息
 */
+ (void)addSaveJavaCacheInLoginWithJson:(id)json;


/**
 *  清除缓存并标记退出登陆
 */
+ (void)removeCacheAndOutLogin;

/**
 *  为捞一捞模块保存Java登陆信息 (用户中心的登陆)
 *
 *  @param userId Java登陆的userID
 *  @param phone  Java登陆的phone
 */
+ (void)saveLoginInforWithUserId:(NSString *)userId andPhone:(NSString *)phone;
@end
