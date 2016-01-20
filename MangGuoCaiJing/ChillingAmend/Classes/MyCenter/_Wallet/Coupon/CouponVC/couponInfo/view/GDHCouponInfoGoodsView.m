//
//  GDHCouponInfoGoodsView.m
//  GongYong
//
//  Created by GDH on 16/1/4.
//  Copyright (c) 2016年 DengLu. All rights reserved.
//

#import "GDHCouponInfoGoodsView.h"

@implementation GDHCouponInfoGoodsView

+(instancetype)couponInfoGoodsView{
    return [[self alloc] init];
}
-(instancetype)init{
    
    self = [super init];
    if (self) {
           self = [[[NSBundle mainBundle]loadNibNamed:@"GDHCouponInfoGoodsView" owner:self options:nil] lastObject];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];

}

-(void)setGoodsTitle:(NSString *)goodsTitle{
    _goodsTitle = goodsTitle;
    self.goodsTitlelabel.text = goodsTitle;
}
-(void)setCenterImager:(NSString *)centerImager{
    _centerImager = centerImager;
    [self.centerImagerView setImageWithURL:[NSURL URLWithString:centerImager]];
}
-(void)setUnder:(NSString *)under{
    _under = under;
    self.underLabel.text = under;
}
@end
