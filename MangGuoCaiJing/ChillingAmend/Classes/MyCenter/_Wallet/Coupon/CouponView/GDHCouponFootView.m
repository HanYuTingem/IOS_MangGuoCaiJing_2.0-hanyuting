
//
//  GDHCouponFootView.m
//  GongYong
//
//  Created by GDH on 15/12/30.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "GDHCouponFootView.h"

@interface GDHCouponFootView ()

/** 过期的按钮 */
@property(nonatomic,strong) UIButton *beOverdueButton;

/** 下划线 */
@property(nonatomic,strong) UIImageView  *lineImageView;



@end

@implementation GDHCouponFootView
-(instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.beOverdueButton];
        [self addSubview:self.lineImageView];
        self.backgroundColor = walletCouponBackgroundColor;
    }
    return self;
}

-(UIButton *)beOverdueButton{
    if (_beOverdueButton == nil) {
        _beOverdueButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_beOverdueButton addTarget:self action:@selector(beOverdueButton:) forControlEvents:UIControlEventTouchUpInside];
        _beOverdueButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_beOverdueButton setTitleColor:[UIColor colorWithRed:0.22f green:0.22f blue:0.22f alpha:1.00f] forState:UIControlStateNormal];
        [_beOverdueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _beOverdueButton;
}

-(UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        _lineImageView = [[UIImageView alloc] init];
        _lineImageView.backgroundColor = [UIColor colorWithRed:0.22f green:0.22f blue:0.22f alpha:1.00f];
    }
    return _lineImageView;
}
-(void)setFooterText:(NSString *)footerText{
    _footerText = footerText;
    [self.beOverdueButton setTitle:footerText forState:UIControlStateNormal];
}

-(void)beOverdueButton:(UIButton *)beOverdueButton{
    if ([self.delegate respondsToSelector:@selector(GDHCouponFootViewBeOverdueButton:)]) {
        [self.delegate GDHCouponFootViewBeOverdueButton:beOverdueButton];
    }
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    self.beOverdueButton.frame = CGRectMake((kkViewWidth - [GCUtil widthOfString:self.footerText withFont:12])/2, 17, [GCUtil widthOfString:self.footerText withFont:12], 12);
    self.lineImageView.frame =CGRectMake(self.beOverdueButton.frame.origin.x, CGRectGetMaxY(self.beOverdueButton.frame), self.beOverdueButton.frame.size.width, 0.5);
}
+(instancetype)couponFootView{
    return [[self alloc] init];
}
@end
