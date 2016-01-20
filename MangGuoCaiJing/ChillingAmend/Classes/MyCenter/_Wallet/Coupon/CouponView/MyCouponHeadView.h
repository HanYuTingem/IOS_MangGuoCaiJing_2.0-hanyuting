//
//  MyCouponHeadView.h
//  GongYong
//
//  Created by GDH on 15/12/30.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MyCouponHeadViewDelegate <NSObject>

/** 未使用 */
-(void)MyCouponHeadViewNotUseButtonDown:(UIButton *)notUseButtonDown;
/**  已使用 */
-(void)MyCouponHeadViewAlreadyUsedButtonDown:(UIButton *)alreadyUsedButton;

@end

@interface MyCouponHeadView : UIView

@property (nonatomic,assign) id <MyCouponHeadViewDelegate> delegate;

+(instancetype)myCouponHeadView;
@end
