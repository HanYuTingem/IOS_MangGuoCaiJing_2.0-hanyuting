//
//  LaoYiLao_URL.h
//  LaoYiLao
//
//  Created by sunsu on 15/11/2.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#ifndef LaoYiLao_URL_h
#define LaoYiLao_URL_h

/****************************************************** 一期测试地址 ******************************************************/
////分享的测试地址
//#define URL_LYL_SHARE  @"http://192.168.10.86:8082/shareTemplate/"
////捞饺子测试地址
//#define URL_LYL_SERVER @"http://192.168.10.86:8099/dumpling/"
////用户中心测试地址 URL
//#define URL_LYL_SINOCENTER    @"http://192.168.10.86:8081/sinoCenter/"
////活动规则测试地址
//#define URL_LYL_ActiveRule  @"http://192.168.10.125:86/#/activeRule_APP"


/****************************************************** 一期正式地址 ******************************************************/

////分享的正式地址
//#define URL_LYL_SHARE  @"http://api.platshare.sinosns.cn/shareTemplate/"
////捞饺子正式地址
//#define URL_LYL_SERVER @"http://api.dumpling.sinosns.cn/dumpling/"
////用户中心正式地址 URL
//#define URL_LYL_SINOCENTER @"http://api.ucenter.sinosns.cn/"
////活动规则线上地址
//#define URL_LYL_ActiveRule @"http://dump.sinosns.cn/#/activeRule_APP"


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

//点击更多的链接
#define ClickMoreUrl @"http://vote.sinosns.cn/app/index"

/****************************************************** 二期 ******************************************************/
/****************************************************** 二期测试地址 ******************************************************/

//分享的测试地址
#define URL_LYL_SHARE  @"http://192.168.10.86:8082/shareTemplate/"
//捞饺子测试地址
#define URL_LYL_SERVER @"http://192.168.10.86:8100/dumpling/"
//#define URL_LYL_SERVER @"http://192.168.30.50:8081/dumpling/"
//用户中心测试地址 URL
#define URL_LYL_SINOCENTER    @"http://192.168.10.86:8081/sinoCenter/"
//活动规则测试地址
#define URL_LYL_ActiveRule  @"http://192.168.30.6:90/#/activeRule_APP"  //@"http://192.168.10.125:86/#/activeRule_APP"
//包现金测试地址
#define URL_LYL_BaoCheDi  @"http://192.168.10.86:8100/dumpling/"
//测试支付时的192.168.30.15:8081
//#define URL_LYL_PayChas   @"http://192.168.30.15:8081/dumpling/"
#define URL_LYL_PayChas   @"http://192.168.10.86:8100/dumpling/"
#define URL_LYL_qwyChas   @"http://192.168.30.66:8099/"
//锅logo图
#define PanAdImage @"http://img.sinosns.cn/dumpling_img/h5img/lao_logo.png"


//2001 用户包饺子生成小锅钱包订单
#define LYL_GetMakePretai  @"redPackets"
//2002 选择支付方式后支付
#define LYL_PayForWake  @"payment"
//2003 用户包饺子后查询支付状态-第三方支付（获取分享链接）
#define LYL_GetPayShared  @"getPaymentStatus"
//2004保存上传图片日志
#define LYL_SaveCardDumpling  @"saveCard"
//2005 包贺卡(用户to用户,用户to有缘人)
#define LYL_NewCardDumpling  @"newCardDumpling"

//3002 我包现金
#define LYL_WobaoXianjin    @"putDumpPage?"
//3003我包现金明细
#define LYL_MakeDumplingDetail @"getPutDetailPage?"
//我包贺卡
#define LYL_WobaoHeka       @"putCardPage"
//我的贺卡
#define LYL_MyGreetingCard  @"myCard?"
//分享饺子完后 改变饺子的状态
#define LYL_MarkShareChangeStatus @"changeStatus?"
//3003 获取广告位
#define LYL_GetAdvertisingList @"getAdvertising?"
// 3004 获取时间表
#define LYL_GetTimeAxis @"getTimeAxis?"

#endif /* LaoYiLao_URL_h */ 





