//
//  WalletRequsetHttp.h
//  Wallet
//
//  Created by GDH on 15/10/23.
//  Copyright (c) 2015年 Sinoglobal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Wallet_BaseViewController.h"
@interface WalletRequsetHttp : NSObject

/** 钱包个人中心账户余额1001 接口 */
+(NSDictionary *)WalletPersonAccountBalance1001;
/** 余额明细 列表 */
+(NSDictionary *)WalletPersonAccountBalanceList1002AmountType:(NSString *)amountType andpage:(NSString *)page andCount:(NSString *)count;

/** 设置支付密码 setPassword为输入的支付密码 */
+(NSDictionary *)WalletPersonSettingPayPassWord1003SetPassword:(NSString *)setPassword;

/** 验证支付密码 */
+(NSDictionary *)WalletPersonVerificationPayPassWord1004VerifyPassword:(NSString *)VerifyPassword;

/** 修改支付密码 */
+(NSDictionary *)WalletPersonChangePayPassWord1005;

/** 是否设置了支付密码 */
+(NSDictionary *)WalletPersonIFSettingPayPassWord1006;

/** 提现 payType支付方式（用户充值时用到）0支付 1微信 2U付 3银联 amount提现金额 userbcid用户银行卡记录ID putInPassWord输入的密码 businessTypekey业务类型 0取现 1充值 2捞饺子 */
+(NSDictionary *)WalletPersonGetCash1007WithPayType:(NSString *)payType amount:(NSString *)amount userbcid:(NSString *)userbcid putInPassWord:(NSString *)putInPassWord businessTypekey:(NSString *)businessTypekey num:(NSString *)num;

/** 获取充值/提现记录(包含成功和失败) type 0充值/1提现 page页数 count一页多少数据 */
+(NSDictionary *)WalletPersonRechargeGetCashRecordSuccessFailure1108WithType:(NSString *)type page:(int)page count:(int)count;
/** 获取提现支持的银行列表 */
+(NSDictionary *)WalletPersonGetCashSupportBankCardList1109;

/**
 *  添加银行卡
 *  @param bankID       银行ID
 *  @param bankCardSN   /银行卡卡号
 *  @param bankCardUser 银行卡开户人
 */
+(NSDictionary *)WalletPersonAddBankCard1010andbankID:(NSString *)bankID andBankCardSN:(NSString *)bankCardSN andBankCardUser:(NSString *)bankCardUser;

/** 删除银行卡 */
+(NSDictionary *)WalletPersonDeleteBankCard1111bankCardID:(NSString *)bankCardID;

/** 获取用户银行卡列表 */
+(NSDictionary *)WalletPersonUserBankCardList1112;

/** 1113获取手机验证码接口 */
+(NSDictionary *)WalletPersonUsergetCodet1113;

/** 1115. 获取银行卡详情 */
+ (NSDictionary *)WalletPersonGetBankCardDetail1115andTheBlankID:(NSString *)BlankID;

/** 110 接口获取密码错误次数的接口请求串  */
+(NSDictionary *)WalletPersonPassWordErrorNum110;


/** 时间戳转换成时间字符串 */
+ (NSString *)WalletTimeDateFormatterWithStr:(NSString *)timeDateStr;
/** 金额末尾是否需要添加0 */
+ (NSString *)addMoneyZeroWithMoneyText:(NSString *)moneyText;
/** 去掉 非法字符 */
+(NSString*)encodeString:(NSString*)unencodedString;


+(void)getKeyVC:(Wallet_BaseViewController *)VC andKey:(void(^)( NSString *key, NSString *theID))myKeyAndID;

/** 10000 获取支付加密串“amount”支付金额; ”paySource”支付来源 钱包用wallet捞一捞用dump;“goodName”商品名称 “goodDepice”商品描述 modelId 1：钱包、2：手机充值、3：商城、4：OTO、 orderSn订单号  */
+(NSDictionary *)WalletPersonPayRequest10000WithAmount:(NSString *)amount paySource:(NSString *)paySource goodName:(NSString *)goodName goodDepice:(NSString *)goodDepice modelId:(NSString *)modelId orderSn:(NSString *)orderSn;


/** 10010 接口支付宝订单成功后网络请求服务器 再次确认是否成功 orderSn交易号 */
+ (NSDictionary *)WalletPersonSucceedJudgeRequest10010WithOrderSn:(NSString *)orderSn;

#pragma mark - 优惠券
/**
 *  优惠劵列表
 *
 *  @param userId      用户ID
 *  @param useState    /使用状态 0未使用 1已使用 2已过期
 *  @param currentPage 当前页
 *  @param pageSize    一页多少条
 *
 */
+(NSDictionary *)WalletCouponListUseState:(NSString *)useState andcurrentPage:(NSString *)currentPage andpageSize:(NSString *)pageSize andcouponType:(NSString *)couponType;

/**
 *  优惠券详情
 *
 *  @param claimId 领取ID
 *
 */
+(NSDictionary *)WalletCouponInfoclaimId:(NSString *)claimId;
@end
