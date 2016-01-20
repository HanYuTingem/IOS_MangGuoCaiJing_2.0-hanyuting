//
//  LJHTanChuViewAnimation.m
//  LaoYiLao
//
//  Created by liujinhe on 15/12/17.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "LJHTanChuViewAnimation.h"
@interface LJHTanChuViewAnimation ()


@end
@implementation LJHTanChuViewAnimation
+ (void)showView:(UIView *)popupView overlayView:(UIView *)overlayView{
    popupView.alpha = 1.0f;
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [popupView.layer addAnimation:popAnimation forKey:nil];
    
}

@end
