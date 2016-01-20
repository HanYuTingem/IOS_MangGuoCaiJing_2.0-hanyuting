//
//  WalletHome.h
//  Wallet
//
//  Created by GDH on 15/10/21.
//  Copyright (c) 2015年 Sinoglobal. All rights reserved.
//

#ifndef Wallet_WalletHome_h
#define Wallet_WalletHome_h


#define WalletHomeLeftSize 15
#define  WalletHomeUpSize 13
//最大提现金额
#define MaxMoney  50000

//supView的背景颜色
#define WalletHomeBackGRD [UIColor colorWithRed:0.82f green:0.82f blue:0.82f alpha:1.00f];
//// 导航栏的背景颜色
//#define WalletHomeNAVGRD  [UIColor colorWithRed:0.84f green:0.18f blue:0.13f alpha:1.00f];
////  导航栏 title 字体大小
//#define WalletHomeNAVTitleFont [UIFont systemFontOfSize:18];
// 导航栏 右侧按钮字大小
#define WalletHomeNAVRigthFont [UIFont systemFontOfSize:14]

/**  线条颜色  */
#define walletLineBackGRD  [UIColor colorWithRed:0.82f green:0.82f blue:0.82f alpha:1.00f]
// 圆角大小
#define walletHomeButtonLayer 10

#define WalletHomeHeadGRD [UIColor colorWithRed:0.98f green:0.73f blue:0.49f alpha:1.00f]
////标题栏的文字的颜色
#define WalletHomeNAVTitleColor [UIColor blackColor]


#pragma mark - 优惠券颜色

/** 优惠劵颜色 */
#define walletCouponBackgroundColor  [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
/** 优惠劵过期失效的颜色 */
#define  walletCouponCellInvailColor1  [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f]
#define walletCouponCellInvailColor2   [UIColor colorWithRed:0.44f green:0.44f blue:0.44f alpha:1.00f];
#define walletCouponCellInvailColor3    [UIColor colorWithRed:0.71f green:0.71f blue:0.71f alpha:1.00f];
/** 优惠劵详情颜色 */
#define walletCouponInfoColor       [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f]

#define  walletCouponInfoButtonTypeColor    [UIColor colorWithRed:0.81f green:0.16f blue:0.16f alpha:1.00f]




#define WalletSP_Width [UIScreen mainScreen].bounds.size.width/320
#define WalletSP_height [UIScreen mainScreen].bounds.size.height/568

#ifdef DEBUG
#define DHLog(...) NSLog(__VA_ARGS__)
#else
#define DHLog(...)
#endif

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

/** 余额明细中的活动文字  */
#define AccountBalanceTitle           @"快来捞饺子，大奖等你拿！"
#define ShowMessage                   @"网络状态不佳，请稍侯！"
#define ShowNoMessage                 @"暂无数据"
#define ShowMessageCorrectData        @"请输入正确的金额"

#define Wallet_PROINDEN               LOGO    //辣椒圈的产品标识

#define showMessageNOData             @"没有更多数据了"

#define PayTypeSave                   @"PayTypeSave"

#define HasPassWord                   @"isHasPassWord"
//支付宝的回调名称 再URL 设置
#define ZHIFUBAOAPPSCHEME             @"MangGuoCaiJing"
//微信支付充值跳转的通知名称
#define WeiXinWalletNotification      @"WeiXinWalletNotification"

#define   WalletXeiXinAppID            @"wx0bd20f42766c48ff"




// 请求，模型（三方）SB 解析。
#import "WalletRequsetHttp.h"
#import "MJExtension.h"
#import "NSObject+SBJSON.h"
#import "MJRefresh.h"
//#define kWallet_user_ID  [[NSUserDefaults standardUserDefaults]objectForKey:@"wallet_user"]
#define kWallet_user_ID    [NSString stringWithFormat:@"%@",kkUserCenterId]

#define payMask RGBACOLOR(83, 83, 83, .7)


//线下
#define walletMybankimh_UrL              @"http://192.168.10.86:9902"
///** 钱包地址测试*/
#define   WalletHttp                     @"http://192.168.10.86:8091/"
/** 加密服务器地址（秘钥测试） */
#define   WalletHttp_encryption          @"http://192.168.10.86:8093/"
//临时测试
//#define   WalletHttp_Temp11                @"http://192.168.10.204:8091/"
//#define   WalletHttp_Temp                  @"http://192.168.10.148:8091/"  //刘 宇服务器
//#define   WalletHttp_pay                   @"http://192.168.10.236:8091/"  //王春玺服务器

//////正式
//#define walletMybankimh_UrL                @"http://img.sinosns.cn/wallet_img/"
///** 钱包正式地址 */
//#define    WalletHttp                      @"http://wallet.a.sinosns.cn/"
///** 秘钥线上地址 */
//#define   WalletHttp_encryption            @"http://encrypt.sinosns.cn/"




/** 优惠券列表地址 */
#define wallet_Coupon_URL               @"http://192.168.10.62:8086/"

#define  wallet_Coupon_instuction_URL  @"http://192.168.10.177:8080/"



/** 1001 余额  */
#define   WalletHttp_Balance               [NSString stringWithFormat:@"%@wallet/getBalance?json=",WalletHttp]
/** 1002  获取余额明细列表 */
#define   WalletHttp_BalanceDetail         [NSString stringWithFormat:@"%@balance/getDetail?json=",WalletHttp]

/** 获取手机验证码接口1113 */
#define   WalletHttp_getCode               [NSString stringWithFormat:@"%@pay/getCode.do?json=",WalletHttp]
/** 1003. 设置支付密码 */
#define   WalletHttp_setPassword1003       [NSString stringWithFormat:@"%@pay/setPassword?json=",WalletHttp]
/** 1004. 验证支付密码 */
#define   WalletHttp_checkPassword1004     [NSString stringWithFormat:@"%@pay/checkPassword?json=",WalletHttp]
/** 1010. 添加银行卡 */
#define   WalletHttp_addBankCard           [NSString stringWithFormat:@"%@wallet/addBankCard?json=",WalletHttp]

/** 1007. 提现 */
#define   WalletHttp_Record1107            [NSString stringWithFormat:@"%@tixian/getMoney?json=",WalletHttp]

/** 1108. 获取提现记录 */
#define   WalletHttp_Record1108            [NSString stringWithFormat:@"%@money/getDrawMoneyLog?json=",WalletHttp]
/** 110888. 获取充值记录 */
#define   WalletHttp_Record1108getChargeLog            [NSString stringWithFormat:@"%@money/getChargeLog?json=",WalletHttp]


#define   WalletHttp_CancelBound1111       [NSString stringWithFormat:@"%@bank/CancelBound?json=",WalletHttp]
/** 1112. 获取用户银行卡列表 */
#define   WalletHttp_BankCardList1112      [NSString stringWithFormat:@"%@bankcardlist/getBankCardList.do?json=",WalletHttp]

/** 1109. 获取提现支持的银行列表 */
#define   WalletHttp_getBankCardList1109   [NSString stringWithFormat:@"%@bankcardlist/getBankCardList?json=",WalletHttp]

/** 1115 接口获取银行卡详情  */
#define WalletHttp_getBankCardDetail1115   [NSString stringWithFormat:@"%@bank/getBankCardDetail?json=",WalletHttp]

/** 110 接口获取密码错误次数的接口请求串  */
#define WalletHttp_getPassWordErrorNum110  [NSString stringWithFormat:@"%@wallet/getErrNum?json=",WalletHttp]

/** 120 接口获取密钥的请求接口  */
#define WalletHttp_getPassWordKey120       [NSString stringWithFormat:@"%@encrypt/getkey",WalletHttp_encryption]

/** 10001 接口生成支付宝订单 */
#define WalletHttp_alipayRequest10001      [NSString stringWithFormat:@"%@payment/alipay?json=",WalletHttp]

/** 10002 接口生成支付宝订单 */
#define WalletHttp_wechatpayRequest10002   [NSString stringWithFormat:@"%@payment/wechatpay?json=",WalletHttp]
/** 10003 接口生成支付宝订单 */
#define WalletHttp_ufpayRequest10003       [NSString stringWithFormat:@"%@payment/ufpay?json=",WalletHttp]

/** 10010 接口支付宝订单成功后网络请求服务器 再次确认是否成功 */
#define WalletHttp_succeedJudgeRequest10010      [NSString stringWithFormat:@"%@recharge/getOrderStatus?json=",WalletHttp]

/** 10100 接口手续费相关信息 */
#define WalletHttp_poundageMsg10100      [NSString stringWithFormat:@"%@tixian/getconf",WalletHttp]



#pragma  mark - 优惠劵接口
/** 查询用户领取的优惠券列表 */
#define WalletHttp_Coupon_list      [NSString stringWithFormat:@"%@t2o-ticket-center-server/couponClaim/queryCouponByUser.do",wallet_Coupon_URL]
/** 根据ID查询获取详情 */
#define  WalletHttp_Coupon_info     [NSString stringWithFormat:@"%@t2o-ticket-center-server/couponClaim/queryCouponUseByClaimId.do",wallet_Coupon_URL]

#define  WalletHttp_Coupon_instruction_URL  [NSString stringWithFormat:@"%@t2o-ticket-center-server/coupon/queryCouponDesc.do",wallet_Coupon_instuction_URL]



/**   商户劵筛选的类型  A平台 B 代金券 C 第三方劵  D 商品劵 */
#define couponTypePlatform  @"A"
#define couponTypeVoucher    @"B"
#define couponTypeThird  @"C"
#define couponTypeGoods  @"D"

#define walletCouponInfoProductName @"芒果财经"
#define walletCouponInfoActivityName @"过年秀"
/** 优惠券分享地址 */
#define walletCouponShareURL  @"http://dump.sinosns.cn/#/indexSec"


#endif



