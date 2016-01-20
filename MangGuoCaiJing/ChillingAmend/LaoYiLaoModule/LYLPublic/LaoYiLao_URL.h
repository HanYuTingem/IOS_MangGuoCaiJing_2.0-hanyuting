//
//  LaoYiLao_URL.h
//  LaoYiLao
//
//  Created by sunsu on 15/11/2.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#ifndef LaoYiLao_URL_h
#define LaoYiLao_URL_h

//应用需要传入的Key
/****   友盟分享  *****/
#define LYL_UM_KEY      @"564a898d67e58eb342005a74"  //@"5328fbfa56240b9ada067458"
#define QQ_APPID        @"1104975154"  //"1101248410"
#define QQ_APPKEY       @"NuR59hoLWPjfKQDd"  //"c7394704798a158208a74ab60104f0ba"
#define WX_APPID        @"wx21679c4c27df0061"     //"wx1611bbef8acfa7ca"
#define WX_AppSecret    @"d4624c36b6795d1d99dcf0547af5443d"
#define WB_APPKEY       LYL_UM_KEY
#define OpenSSOWithRedirectURL @"http://sns.whalecloud.com/sina2/callback"

// 分享的测试地址
#define URL_LYL_SHARE  @"http://192.168.10.86:8082/shareTemplate/"
//捞饺子测试地址
#define URL_LYL_SERVER @"http://192.168.10.86:8099/dumpling/"
//用户中心测试地址 URL
#define URL_LYL_SINOCENTER      @"http://192.168.10.86:8081/sinoCenter/"




////分享的正式地址
//#define URL_LYL_SHARE  @"http://api.platshare.sinosns.cn/shareTemplate/"
////捞饺子正式地址
//#define URL_LYL_SERVER @"http://api.dumpling.sinosns.cn/dumpling/"
////用户中心正式地址 URL
//#define URL_LYL_SINOCENTER @"http://api.ucenter.sinosns.cn/"


//1001. 显示当前饺子剩余总数量
#define NowDumplingNumber @"nowDumplingNumber?"

//1002. 捞饺子用户列表(按时间倒序)
#define  UserWithDumplingList @"acquireDumplingUserList?"

//1003. 查询用户包/捞的饺子列表(一期不做)
#define SearchDoDumplingAndUserList @""

//1004. 标记分享1次
#define MarkShare @"markShare?"

//1005增加捞饺子机会接口 (在前段和APP页面第一次请求捞一捞页面 登陆状态)
#define AddNumberWithDumpling @"addAcquireDumplingChance?"

//1006登陆用户捞饺子
#define LogingUserWithDumpling @"loginUserAcquireDumpling?"

//1007未登录获取捞饺子上限
#define NOLogingNumberCeiling @"loggedOutUserDumplingToplimit?"

//1008未登陆用户捞饺子
#define NOLogingWithDumpling @"loggedOutUserAcquireDumpling?"

//1009未登录用户登陆领取接口
#define NOLogingUserGetWithMoney @"loggedOutUserGoAndGet?"

//1010我的饺子
#define MyDumpling @"myDumpling?"

//1011 获取分享内容接口
#define LYL_GetShareInfo @"getShareInfo?"



/************************************
            用户中心
*************************************/
//1203 发送登陆验证码
#define LYL_validateLogin @"findCode?"

//1204 验证码登录  POST
#define LYL_QucikLogin @"validateLoginCode?"

//1206 获取用户协议和账号说明
#define LYL_GetAgreement @"getAgreement?"




#endif /* LaoYiLao_URL_h */
