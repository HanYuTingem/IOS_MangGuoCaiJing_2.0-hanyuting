//
//  GDHCouponInfoThirdView.m
//  GongYong
//
//  Created by GDH on 16/1/4.
//  Copyright (c) 2016年 DengLu. All rights reserved.
//

#import "GDHCouponInfoThirdView.h"

@interface GDHCouponInfoThirdView ()

@property(nonatomic,strong) UILabel *useInfoLabel;

@end

@implementation GDHCouponInfoThirdView
+(instancetype)couponInfoThirdView{
    return [[self alloc] init];
}
-(instancetype)init{
    
    self = [super init];
    if (self) {
        [self addSubview:self.useInfoLabel];
    }
    return self;
}

-(void)setCouponInfoThirdURL:(NSString *)couponInfoThirdURL{
    _couponInfoThirdURL = couponInfoThirdURL;
    self.useInfoLabel.text = couponInfoThirdURL;
}

-(UILabel *)useInfoLabel{
    if (_useInfoLabel == nil) {
        _useInfoLabel = [[UILabel alloc] init];
        _useInfoLabel.font = [UIFont systemFontOfSize:14];
        _useInfoLabel.textColor = [UIColor colorWithRed:0.22f green:0.22f blue:0.22f alpha:1.00f];
        _useInfoLabel.textAlignment =  NSTextAlignmentCenter;
    }
    return _useInfoLabel;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.useInfoLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
