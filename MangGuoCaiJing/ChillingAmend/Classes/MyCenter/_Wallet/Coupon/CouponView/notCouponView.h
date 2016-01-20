//
//  notCouponView.h
//  GongYong
//
//  Created by GDH on 15/12/31.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol notCouponViewDelegate  <NSObject>

/** 获取优惠券 */
- (void)notCouponViewGetCoupon:(UIButton *)getCoupon;

- (void)notCouponviewInvailButton:(UIButton *)invailButton;

@end

@interface notCouponView : UIView

+(instancetype)notCoupon;

@property (nonatomic,assign) id <notCouponViewDelegate> delegate;
- (IBAction)getCouponButtonDown:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *invailButton;
- (IBAction)invailButtonDown:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *invailView;
@end
