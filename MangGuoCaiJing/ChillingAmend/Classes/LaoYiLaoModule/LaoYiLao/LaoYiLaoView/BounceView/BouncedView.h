//
//  BouncedView.h
//  LaoYiLao
//
//  Created by wzh on 15/10/31.
//  Copyright (c) 2015年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BounceShareLogingView.h"
#import "BounceSharedCeilingView.h"
#import "DumplingInforModel.h"
#import "LaoYiLaoViewController.h"
#import "BounceDumplingInforView.h"
@interface BouncedView : UIView


+ (BouncedView *)shareBounceView;

/**
 *  饺子信息的model
 */
@property (nonatomic, strong) DumplingInforModel *dumplingInforModel;

/**
 *  <#Description#>
 */
@property (nonatomic, strong) LaoYiLaoViewController *viewController;
/**
 *  添加捞到饺子信息的弹框
 */
- (void)addDumplingInforView;


/**
 *  捞饺子上限
 */
- (void)addSharedWithCeilingViewType:(NSString *)type;
@end
