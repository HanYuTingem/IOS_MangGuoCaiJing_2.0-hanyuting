//
//  CJTopUpModel.h
//  Wallet
//
//  Created by zhaochunjing on 15-10-29.
//  Copyright (c) 2015年 Sinoglobal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJTopUpPayModel.h"

@interface CJTopUpModel : NSObject

/** 提现手续费 有值则有手续费 */
@property (nonatomic, copy) NSString *fees;

/** 金额 */
@property (nonatomic, copy) NSString *amount;
/** 类型  0充值 还是 1提现 */
@property (nonatomic, copy) NSString *amountType;
/** 银行名称 */
@property (nonatomic, copy) NSString *bankName;
//@property (nonatomic, copy) NSString *bankTradeSn;
//@property (nonatomic, copy) NSString *businessTypeKey;
/** 银行卡后四位 */
@property (nonatomic, copy) NSString *cardSn;
/** 创建时间 */
@property (nonatomic, copy) NSString *createDate;
/** 支付方式 （用户充值时用到）1余额 2支付宝 3微信 4U付 */
@property (nonatomic, copy) NSString *payType;
//@property (nonatomic, copy) NSString *modelid;
//@property (nonatomic, copy) NSString *productCode;
/** 状态 0失败 1成功 2关闭 3处理中 */
@property (nonatomic, copy) NSString *status;
/** 交易号 */
@property (nonatomic, copy) NSString *tradeSn;
/** 用户提现银行卡id */
@property (nonatomic, copy) NSString *userbcid;

/** 充值记录 交易号 */
@property (nonatomic, copy) NSString *orderSn;
/** 状态 1:成功 2:失败 3:待支付 4:充值中 5:已关闭 */
@property (nonatomic, copy) NSString *payStatus;

//@property (nonatomic, copy) NSString *userid;
//@property (nonatomic, copy) NSString *walletSn;

/** 充值记录请求的充值信息 */
@property (nonatomic, strong) CJTopUpPayModel *backJson;


@end
