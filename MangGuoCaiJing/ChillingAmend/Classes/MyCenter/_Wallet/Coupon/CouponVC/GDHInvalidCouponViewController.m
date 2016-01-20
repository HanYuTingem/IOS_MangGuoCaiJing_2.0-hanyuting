//
//  GDHInvalidCouponViewController.m
//  GongYong
//
//  Created by GDH on 15/12/30.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "GDHInvalidCouponViewController.h"

@interface GDHInvalidCouponViewController ()
@end

@implementation GDHInvalidCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = walletCouponBackgroundColor;
    self.heaViewIFShow = NO;
    self.mallTitleLabel.text = @"我的优惠券";
    self.couponState = couponUserStateExpired;
    NSLog(@"%d  %d",self.couponState,couponUserStateUsed);
    [self mycouponRequest];
}

@end
