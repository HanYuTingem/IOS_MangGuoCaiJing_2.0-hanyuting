//
//  GDHCouponViewController.m
//  GongYong
//
//  Created by GDH on 15/12/30.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "GDHCouponViewController.h"
#import "GDHInvalidCouponViewController.h"
#import "GDHCouponModel.h"
@interface GDHCouponViewController ()

@end

@implementation GDHCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.heaViewIFShow = YES;
//    self.couponType = @"";
    self.couponState = couponUserStateNOtUser;
    [self mycouponRequest];// 网络请求。
    NSLog(@"%d  %d",self.couponState,couponUserStateUsed);
    self.mallTitleLabel.text = @"我的优惠券";
}
#pragma  mark - 跳转到已过期优惠券
-(void)GDHCouponFootViewBeOverdueButton:(UIButton *)beOverdueButton{
    NSLog(@"跳转  已过期优惠券");
    GDHInvalidCouponViewController *vc = [[GDHInvalidCouponViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
