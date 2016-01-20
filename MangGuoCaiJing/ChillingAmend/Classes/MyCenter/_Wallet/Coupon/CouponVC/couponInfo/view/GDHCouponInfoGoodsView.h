//
//  GDHCouponInfoGoodsView.h
//  GongYong
//
//  Created by GDH on 16/1/4.
//  Copyright (c) 2016年 DengLu. All rights reserved.
//     商品券

#import <UIKit/UIKit.h>

@interface GDHCouponInfoGoodsView : UIView
@property (weak, nonatomic) IBOutlet UILabel *goodsTitlelabel;
@property (weak, nonatomic) IBOutlet UIImageView *centerImagerView;

@property (weak, nonatomic) IBOutlet UILabel *underLabel;



@property (nonatomic,copy) NSString *goodsTitle;


@property (nonatomic,copy) NSString *centerImager;


@property (nonatomic,copy) NSString *under;

+(instancetype)couponInfoGoodsView;

@end
