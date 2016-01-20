//
//  GDHCouponInfoPlatformView.m
//  GongYong
//
//  Created by GDH on 16/1/4.
//  Copyright (c) 2016年 DengLu. All rights reserved.
//

#import "GDHCouponInfoPlatformView.h"

@interface GDHCouponInfoPlatformView ()

/** 优惠券详情  平台的通用券 */
@property(nonatomic,strong) UILabel  *couponInfoLabel;
@end

@implementation GDHCouponInfoPlatformView



-(instancetype)init{

   self = [super init];
    if (self) {
        [self addSubview:self.couponInfoLabel];
    }
    return self;
}
+(instancetype)couponInfoPlatformView{
 
    return [[self alloc] init];
}

-(void)setPaltform:(NSString *)paltform{
    _paltform = paltform;
    self.couponInfoLabel.text = paltform;

}

-(UILabel *)couponInfoLabel{
    if (_couponInfoLabel == nil) {
        _couponInfoLabel = [[UILabel alloc] init];
        _couponInfoLabel.font = [UIFont systemFontOfSize:14];
        _couponInfoLabel.textColor = [UIColor colorWithRed:0.22f green:0.22f blue:0.22f alpha:1.00f];
        _couponInfoLabel.textAlignment =  NSTextAlignmentCenter;
    }
    return _couponInfoLabel;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.couponInfoLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
