//
//  BounceSharedCeilingView.h
//  LaoYiLao
//
//  Created by wzh on 15/11/2.
//  Copyright (c) 2015年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LaoYiLaoViewController.h"
@interface BounceSharedCeilingView : UIView

+ (BounceSharedCeilingView *)shareBounceSharedCeilingView;
/**
 *  饺子
 */
@property (nonatomic, strong) UIButton *dumpingBtn;

/**
 *  标题
 */
@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) NSString *type; // 0.饺子信息的弹框 1 次数用完 2. 服务器挤爆了 3.网络不好


@property (nonatomic, strong) LaoYiLaoViewController *viewController;

@end
