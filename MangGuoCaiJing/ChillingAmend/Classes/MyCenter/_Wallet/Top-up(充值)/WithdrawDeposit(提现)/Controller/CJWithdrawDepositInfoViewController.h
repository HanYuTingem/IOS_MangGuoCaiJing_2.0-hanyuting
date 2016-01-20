//
//  CJWithdrawDepositInfoViewController.h
//  Wallet
//
//  Created by zhaochunjing on 15-10-23.
//  Copyright (c) 2015年 Sinoglobal. All rights reserved.
//

#import "Wallet_BaseViewController.h"

@interface CJWithdrawDepositInfoViewController : Wallet_BaseViewController


/** 银行卡的名字 */
@property (nonatomic, copy) NSString *bankCardName;
/** 价格 */
@property (nonatomic, copy) NSString *moneyCash;
/** 充值方式 */
@property (nonatomic, copy) NSString *cardType;

/** 网络请求传过来的提现到账日期文字 */
@property (nonatomic, copy) NSString *txTemplate3;
/** 手续费 */
@property (nonatomic, copy) NSString *fees;

@end
