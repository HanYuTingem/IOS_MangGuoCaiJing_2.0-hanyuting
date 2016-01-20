//
//  notCouponView.m
//  GongYong
//
//  Created by GDH on 15/12/31.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "notCouponView.h"


@interface notCouponView ()
@property (weak, nonatomic) IBOutlet UIButton *getCouponButton;

@end

@implementation notCouponView

-(instancetype)init{
    self = [super init];
    if (self) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"notCouponView" owner:self options:nil] lastObject];
        self.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    }
    return self;
}

+(instancetype)notCoupon{
  
    return [[self alloc] init];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.getCouponButton.layer.masksToBounds = YES;
    self.getCouponButton.layer.cornerRadius = 5;
    self.getCouponButton.layer.borderWidth = 1;
    self.getCouponButton.layer.borderColor = [UIColor colorWithRed:0.22f green:0.22f blue:0.22f alpha:1.00f].CGColor;
}

- (IBAction)getCouponButtonDown:(id)sender {
    UIButton * button = (UIButton *)sender;
    if ([self.delegate respondsToSelector:@selector(notCouponViewGetCoupon:)]) {
        [self.delegate notCouponViewGetCoupon:button];
    }
}
- (IBAction)invailButtonDown:(id)sender {
    if ([self.delegate respondsToSelector:@selector(notCouponviewInvailButton:)]) {
        [self.delegate notCouponviewInvailButton:(UIButton *)sender];
    }
}
@end
