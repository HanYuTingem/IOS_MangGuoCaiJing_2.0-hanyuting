//
//  WalletRequsetHttp.m
//  Wallet
//
//  Created by GDH on 15/10/23.
//  Copyright (c) 2015年 Sinoglobal. All rights reserved.
//

#import "WalletRequsetHttp.h"
#import "GDHPassWordModel.h"
#import "DateEditor.h"
@implementation WalletRequsetHttp

/** 钱包个人中心账户余额1001 接口 */

+(NSDictionary *)WalletPersonAccountBalance1001{
    NSMutableDictionary *dict = [self getDictionary];
    
    
    NSLog(@"%@",[GDHPassWordModel passWord].payPassword);
    return dict;
}

/** 余额明细 列表 */

+(NSDictionary *)WalletPersonAccountBalanceList1002AmountType:(NSString *)amountType andpage:(NSString *)page andCount:(NSString *)count{
    NSMutableDictionary *dict = [self getDictionary];
    [dict setObject:amountType forKey:@"amountType"];//收入，支出
    [dict setObject:page forKey:@"page"];
    [dict setObject:count forKey:@"count"];
    return dict;
}
/**  设置支付密码 setPassword为输入的支付密码 */
+(NSDictionary *)WalletPersonSettingPayPassWord1003SetPassword:(NSString *)setPassword{
    
    NSMutableDictionary *dict = [self getDictionary];
    [dict setObject:setPassword forKey:@"payPassword"];// 支付密码
    return dict;
}
/**  验证支付密码 */
+(NSDictionary *)WalletPersonVerificationPayPassWord1004VerifyPassword:(NSString *)VerifyPassword{
    
    NSMutableDictionary *dict = [self getDictionary];
    [dict setObject:VerifyPassword forKey:@"payPassword"];// 支付密码
    return dict;
}
/** 修改支付密码 */
+(NSDictionary *)WalletPersonChangePayPassWord1005{
    
    NSMutableDictionary *dict = [self getDictionary];
    [dict setObject:[GDHPassWordModel passWord].oldPayPassword forKey:@"oldPayPassword"];//原支付密码
    [dict setObject:[GDHPassWordModel passWord].newpayPassword forKey:@"newPayPassword"];// 新支付密码
    return dict;
}
/** 是否设置了支付密码 */
+(NSDictionary *)WalletPersonIFSettingPayPassWord1006{
    
    NSMutableDictionary *dict = [self getDictionary];
    return dict;
}
/** 提现 payType支付方式（用户充值时用到）0支付 1微信 2U付 3银联 amount提现金额 userbcid用户银行卡记录ID putInPassWord输入的密码 businessTypekey业务类型 0取现 1充值 2捞饺子 */
+(NSDictionary *)WalletPersonGetCash1007WithPayType:(NSString *)payType amount:(NSString *)amount userbcid:(NSString *)userbcid putInPassWord:(NSString *)putInPassWord businessTypekey:(NSString *)businessTypekey num:(NSString *)num{
    
    NSMutableDictionary *dict = [self getDictionary];
    [dict setObject:putInPassWord forKey:@"payPassWord"];//支付密码
    [dict setObject:[self getNowDateTime] forKey:@"tradeSn"];//交易号  默认为当前时间年月日时分秒eg：20151031171035
    [dict setObject:@"dumping" forKey:@"modelid"];//所属模块  默认 dumping
    [dict setObject:businessTypekey forKey:@"businessTypekey"];//业务类型 0取现 1充值 2捞饺子
    
    [dict setObject:payType forKey:@"payType"];//支付方式（用户充值时用到）0支付 1微信 2U付 3银联
    [dict setObject:amount forKey:@"amount"];// 提现金额
    [dict setObject:[NSString stringWithFormat:@"%@",userbcid] forKey:@"userbcid"];//用户银行卡记录ID
    
    [dict setObject:num forKey:@"num"];
    return dict;
}
/** 获取充值/提现(type 0/1)记录(包含成功和失败) page页数 count一页多少数据 */
+(NSDictionary *)WalletPersonRechargeGetCashRecordSuccessFailure1108WithType:(NSString *)type page:(int)page count:(int)count{
    NSMutableDictionary *dict = [self getDictionary];
    //    [dict setObject:type forKey:@"amountType"];//充值和提现，充值，提现
    [dict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [dict setObject:[NSString stringWithFormat:@"%d",count] forKey:@"count"];
    
    return dict;
}
/** 获取提现支持的银行列表 */
+(NSDictionary *)WalletPersonGetCashSupportBankCardList1109{
    NSMutableDictionary *dict = [self getDictionary];
    return dict;
}
/** 添加银行卡 */
+(NSDictionary *)WalletPersonAddBankCard1010andbankID:(NSString *)bankID andBankCardSN:(NSString *)bankCardSN andBankCardUser:(NSString *)bankCardUser{
    NSMutableDictionary *dict = [self getDictionary];
    [dict setObject:bankID forKey:@"bankId"];//银行ID
    [dict setObject:bankCardSN forKey:@"bankCardSN"];//银行卡卡号
    [dict setObject:bankCardUser forKey:@"bankCardUser"];//银行卡开户人
    
    return dict;
}
/** 删除银行卡 */
+(NSDictionary *)WalletPersonDeleteBankCard1111bankCardID:(NSString *)bankCardID
{
    //    NSMutableDictionary *dict = [self getDictionary];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:Wallet_PROINDEN forKey:@"productCode"];//  产品标识
    [dict setObject:@"1" forKey:@"status"]; //银行卡绑定状态  传参数 status只写 1
    [dict setObject:bankCardID forKey:@"userbcid"];//用户银行卡记录ID
    return dict;
    
    
}
/** . 获取用户银行卡列表 */
+(NSDictionary *)WalletPersonUserBankCardList1112{
    NSMutableDictionary *dict = [self getDictionary];
    
    return dict;
}

/** 1113获取手机验证码接口 */
+(NSDictionary *)WalletPersonUsergetCodet1113{
    
    NSMutableDictionary *dict = [self getDictionary];
    return dict;
}
/** 1115. 获取银行卡详情 */
+ (NSDictionary *)WalletPersonGetBankCardDetail1115andTheBlankID:(NSString *)BlankID{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:Wallet_PROINDEN forKey:@"productCode"];//  产品标识
    [dict setObject:BlankID forKey:@"userbcid"];
    return dict;
}

/** 110 接口获取密码错误次数的接口请求串  */
+(NSDictionary *)WalletPersonPassWordErrorNum110{
    NSMutableDictionary *dict = [self getDictionary];
    return dict;
}

/** 10000 获取支付加密串“amount”支付金额; ”paySource”支付来源 钱包用wallet捞一捞用dump;“goodName”商品名称 “goodDepice”商品描述 modelId 1：钱包、2：手机充值、3：商城、4：OTO、 orderSn订单号  */
+(NSDictionary *)WalletPersonPayRequest10000WithAmount:(NSString *)amount paySource:(NSString *)paySource goodName:(NSString *)goodName goodDepice:(NSString *)goodDepice modelId:(NSString *)modelId orderSn:(NSString *)orderSn{
    NSMutableDictionary *dict = [self getDictionary];
    [dict setObject:modelId forKey:@"modelId"]; //
    [dict setObject:amount forKey:@"amount"];
    [dict setObject:paySource forKey:@"paySource"];
    [dict setObject:goodName forKey:@"goodName"];
    [dict setObject:goodDepice forKey:@"goodDepice"];
    if (orderSn) {
        [dict setObject:orderSn forKey:@"orderSn"];
    } else {
        [dict setObject:@"" forKey:@"orderSn"];
    }
    return dict;
}

/** 10010 接口支付宝订单成功后网络请求服务器 再次确认是否成功 orderSn交易号 */
+ (NSDictionary *)WalletPersonSucceedJudgeRequest10010WithOrderSn:(NSString *)orderSn
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:orderSn forKey:@"orderSn"];
    return dict;
}




/** 得到字典 产品标识 用户userId 公用的 */
+ (NSMutableDictionary *)getDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
#warning 需要更改里面的userId
    [dict setObject:kkUserCenterId forKey:@"userId"];//用户ID
  //  NSLog(@"kWallet_user_ID == %@",kk);
  //  NSLog(@"kWallet_user_ID == %@",kkNickDic_UserId);
//        [dict setObject:@"98634" forKey:@"userId"];//用户ID
    [dict setObject:Wallet_PROINDEN forKey:@"productCode"];//  产品标识
    
    return dict;
}

/** 得到字典 产品标识 用户userid 公用的 */
+ (NSMutableDictionary *)getDictionaryUsersid
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:Wallet_PROINDEN forKey:@"productCode"];//  产品标识
    [dict setObject:kkUserCenterId forKey:@"userid"];//用户ID
    return dict;
}

/** 时间戳转换成时间字符串 */
+ (NSString *)WalletTimeDateFormatterWithStr:(NSString *)timeDateStr{
    double createTime = [timeDateStr doubleValue];
    if (createTime >= 1000000000000) {//如果返回毫秒
        createTime = createTime/1000;
    }
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:createTime];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:confromTimesp];
    return dateStr;
}

/** 获取当前日期年月日 YYYY-MM-dd HH:mm:ss */
+ (NSString *) getCurrentTime:(NSDate *)today{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *currentTime = [dateFormatter stringFromDate:today];
    return currentTime;
}
/** 得到当前时间 没有分隔符号的字符串 */
+ (NSString *)getNowDateTime
{
    NSDate *date = [NSDate date];
    NSString *dateStr = [self getCurrentTime:date];
    NSString *str1 = [dateStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *str = [str2 stringByReplacingOccurrencesOfString:@":" withString:@""];
    return str;
}

/** 金额末尾是否需要添加0 */
+ (NSString *)addMoneyZeroWithMoneyText:(NSString *)moneyText
{
    NSArray *array = [moneyText componentsSeparatedByString:@"."];
    NSMutableString *text = [NSMutableString stringWithString:moneyText];
    if (array.count == 1) {
        [text appendFormat:@".00"];
    } else if (array.count == 2) {
        NSString *textStr = array[1];
        if (textStr.length == 0) {
            [text appendFormat:@"00"];
        } else if (textStr.length == 1) {
            [text appendFormat:@"0"];
        }
    }
    return text;
}


/** 去掉非法字符 */
+(NSString*)encodeString:(NSString*)unencodedString{
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

+(void)getKeyVC:(Wallet_BaseViewController *)VC andKey:(void (^)(NSString *key, NSString *theID))myKeyAndID{
    [VC chrysanthemumOpen];
    [SINOAFNetWorking postWithBaseURL:WalletHttp_getPassWordKey120 controller:VC success:^(id json) {
        
        NSLog(@"%@",WalletHttp_getPassWordKey120);
        if (json) {
            myKeyAndID(json[@"encryptKey"],json[@"id"]);
        }
        NSLog(@"%@",json);
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        [VC chrysanthemumClosed];
        
    } noNet:^{
        [VC chrysanthemumClosed];
    }];
    
}

#pragma mark - 优惠券
+(NSDictionary *)WalletCouponListUseState:(NSString *)useState andcurrentPage:(NSString *)currentPage andpageSize:(NSString *)pageSize andcouponType:(NSString *)couponType{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:kkUserCenterId forKeyPath:@"userId"];
    [dict setValue:useState forKeyPath:@"useState"];
    [dict setValue:currentPage forKeyPath:@"currentPage"];
    [dict setValue:pageSize forKeyPath:@"pageSize"];
    [dict setValue:couponType forKeyPath:@"couponType"];
    return dict;
}
+(NSDictionary *)WalletCouponInfoclaimId:(NSString *)claimId{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:kkUserCenterId forKeyPath:@"userId"];
    [dict setValue:claimId forKeyPath:@"claimId"];
    return dict;
}
@end
