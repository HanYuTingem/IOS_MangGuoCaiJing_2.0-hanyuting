//
//  CJCashDetailsViewController.h
//  GongYong
//
//  Created by zhaochunjing on 16-1-5.
//  Copyright (c) 2016年 DengLu. All rights reserved.
//

#import "Wallet_BaseViewController.h"
#import "CJTopUpModel.h"

@interface CJCashDetailsViewController : Wallet_BaseViewController

/** 提现记录里传入的 具体模型 */
@property (nonatomic, strong) CJTopUpModel *cashTopUpModel;


/** 到账日期的文字 */
@property (nonatomic, copy) NSString *txTemplate3;

@end
