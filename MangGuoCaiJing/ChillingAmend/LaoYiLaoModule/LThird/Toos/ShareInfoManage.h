//
//  ShareInfoManage.h
//  LaoYiLao
//
//  Created by sunsu on 15/11/16.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareInfoManage : NSObject
+ (void) shareJiaoziInfoWithButton:(UIButton *)btn andController:(LaoYiLaoBaseViewController *)controller;
+ (void) shareActivityWithButton:(UIButton *)btn andController:(LaoYiLaoBaseViewController *)controller;
@end
