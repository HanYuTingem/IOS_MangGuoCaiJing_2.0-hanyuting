//
//  LYLaoYiLaoViewController.h
//  LaoYiLao
//
//  Created by Li on 15/12/17.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "LaoYiLaoBaseViewController.h"

@interface LYLaoYiLaoViewController : LaoYiLaoBaseViewController

/**
 包的饺子的状态
 1 : 未领完
 2 : 已领完
 3 : 已过期
 4 : 未发送
 */
@property (nonatomic, copy) NSString *dumplingStates;
/**
 *  小锅id
 */
@property (nonatomic, copy) NSString *dumplingUserPutmoneytid;

@end
