//
//  PlayPromptView.h
//  ChillingAmend
//
//  Created by 孙瑞 on 16/1/4.
//  Copyright © 2016年 SinoGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayPromptView : UIView

+(void)brightness:(CGFloat)brightness View:(UIView *)View state:(UIGestureRecognizerState)state;

+(void)plannedSpeed:(NSString *)plannedSpeed View:(UIView *)view state:(UIGestureRecognizerState)state;

@end
