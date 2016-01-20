//
//  CJTopUpDetailsViewController.h
//  GongYong
//
//  Created by zhaochunjing on 15-12-15.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "Wallet_BaseViewController.h"
#import "CJTopUpModel.h"
#import "CJTopUpPayModel.h"

/** 支付类型 */
typedef NS_ENUM(int, PayType) {
    PayTypeWallet = 1,
    PayTypeZhiFuBao,
    PayTypeUFu,
    PayTypeWeiXin
};

/** 状态 0失败 1成功 2关闭 3处理中 4待处理 */
typedef NS_ENUM(int, ResultPay) {
    /** 0失败 */
    ResultPayFailure = 0,
    /** 1成功 */
    ResultPaySucceed,
    /** 2关闭 */
    ResultPayClose,
    /** 3处理中 */
    ResultPayInHand,
    /** 4待处理 */
    ResultPayPending
};

@interface CJTopUpDetailsViewController : Wallet_BaseViewController

/** 充值记录来的模型 */
@property (nonatomic, strong) CJTopUpModel *topUpDetailsModel;
/** 充值后传来的数据 */
@property (nonatomic, strong) CJTopUpModel *topUpModel;
@property (nonatomic, strong) CJTopUpPayModel *payModel;
/** 充值后传来的数据 (支付方式) */
@property (nonatomic, assign) ResultPay paytypeTopUp;
/** 标注来自哪里的标记 */
@property (nonatomic, copy) NSString *comeHereStr;

@end
