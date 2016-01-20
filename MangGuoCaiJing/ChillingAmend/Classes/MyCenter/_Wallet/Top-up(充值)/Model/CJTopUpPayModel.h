//
//  CJTopUpPayModel.h
//  GongYong
//
//  Created by zhaochunjing on 15-12-18.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//  请求充值加密串 交易号的模型

#import <Foundation/Foundation.h>

@interface CJTopUpPayModel : NSObject
/** 收款方编号(微信、支付宝、U付) */
@property (nonatomic, copy) NSString *mch_id;
/** 应用ID(微信、支付宝) */
@property (nonatomic, copy) NSString *appId;
/** 应用密钥(微信、支付宝、U付) */
@property (nonatomic, copy) NSString *appsecret;
/** 微信返回的流水号(微信) */
@property (nonatomic, copy) NSString *prepay_id;
/** 签名(微信)(又加支付宝) */
@property (nonatomic, copy) NSString *sign;
/** 随机串(微信) */
@property (nonatomic, copy) NSString *nonce_str;
/** 时间戳 (微信) */
@property (nonatomic, copy) NSString *timestamp;

//微信正确
/** 商户id */
@property (nonatomic,copy) NSString *partnerid;
/** appID */
@property (nonatomic,copy) NSString *appid;
/** package */
@property (nonatomic,copy) NSString *package;
/** 预支付订单 */
@property (nonatomic,copy) NSString *prepayid;
/** 时间戳 (微信) */
@property (nonatomic,copy) NSString *noncestr;



/** 收款方帐号(支付宝) */
@property (nonatomic, copy) NSString *seller;
/** 签名数据(支付宝)(作废) */
@property (nonatomic, copy) NSString *sing;
/** 交易号(支付宝) */
@property (nonatomic, copy) NSString *trade_sn;

/** U付返回的流水号 */
@property (nonatomic, copy) NSString *trade_no;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
