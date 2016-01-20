//
//  GDHCouponFootView.h
//  GongYong
//
//  Created by GDH on 15/12/30.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GDHCouponFootViewDelegate <NSObject>
/** 断尾的点击按钮 */
-(void)GDHCouponFootViewBeOverdueButton:(UIButton *)beOverdueButton;

@end

@interface GDHCouponFootView : UIView

/**  断尾的文字 */
@property (nonatomic,copy) NSString *footerText;

+(instancetype)couponFootView;

@property (nonatomic,assign) id <GDHCouponFootViewDelegate>delegate;

@end
