//
//  mineWalletViewController.h
//  Wallet
//
//  Created by GDH on 15/10/21.
//  Copyright (c) 2015年 Sinoglobal. All rights reserved.
//

#import "Wallet_BaseViewController.h"

@interface mineWalletViewController : Wallet_BaseViewController
/**
 *  必须实现
 */
@property (nonatomic, copy) void(^backBlock)();
@property (nonatomic, copy) NSString *type;//1 登录界面进入的钱包

@end
