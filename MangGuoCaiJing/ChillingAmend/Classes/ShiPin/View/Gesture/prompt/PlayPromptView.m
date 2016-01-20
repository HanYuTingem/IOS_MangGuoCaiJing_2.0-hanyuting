//
//  PlayPromptView.m
//  ChillingAmend
//
//  Created by 孙瑞 on 16/1/4.
//  Copyright © 2016年 SinoGlobal. All rights reserved.
//

#import "PlayPromptView.h"

@interface PlayPromptView () {
    UIImageView *brightnessImageView;
    NSTimer *brightnessTimer;
    UILabel *labelText;
    NSTimer *labelTimer;
}

@end

@implementation PlayPromptView
// 单例
+ (PlayPromptView *)sharedView {
    static dispatch_once_t once;
    static PlayPromptView *sharedView;
    dispatch_once(&once, ^{
        sharedView =
        [[PlayPromptView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    return sharedView;
}

+ (void)brightness:(CGFloat)brightness
              View:(UIView *)View
             state:(UIGestureRecognizerState)state {
    
    [[PlayPromptView sharedView] showWithStatus:brightness View:View state:state];
}

+ (void)plannedSpeed:(NSString *)plannedSpeed
                View:(UIView *)view
               state:(UIGestureRecognizerState)state {
    [[PlayPromptView sharedView] showPlannedSpeed:plannedSpeed View:view state:state];
}

// 添加一个UILabel，黑底色白字，有动画让alpha从0.6变成1，动画持续0.3秒
- (void)showPlannedSpeed:(NSString *)plannedSpeed
                    View:(UIView *)view
                   state:(UIGestureRecognizerState)state {
    if (!labelText) {
        labelText = [[UILabel alloc] init];
        labelText.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
        [view.window addSubview:labelText];
    }
    labelText.frame = CGRectMake(0, 0, 200, 20);
    labelText.textAlignment = NSTextAlignmentCenter;
    labelText.font = [UIFont systemFontOfSize:20];
    labelText.text = plannedSpeed;
    labelText.hidden = 0;
    labelText.textColor = [UIColor whiteColor];
    labelText.center = view.window.center;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction |
     UIViewAnimationCurveEaseOut |
     UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         labelText.alpha = 1;
                     }
                     completion:NULL];
    // end之后，让uilabel变成透明的
    if (state == UIGestureRecognizerStateEnded) {
        labelTimer =
        [NSTimer scheduledTimerWithTimeInterval:0.3
                                         target:self
                                       selector:@selector(plannedSpeedTimer)
                                       userInfo:nil
                                        repeats:NO];
    }
}
// 让labeltimer失效，0.3秒之后让label透明
- (void)plannedSpeedTimer {
    if (labelTimer) {
        [labelTimer invalidate];
    }
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction |
     UIViewAnimationCurveEaseOut |
     UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         labelText.alpha = 0;
                         
                     }
                     completion:NULL];
}

//根据亮度状态显示亮度窗口
- (void)showWithStatus:(CGFloat)brightness
                  View:(UIView *)View
                 state:(UIGestureRecognizerState)state {
    
    if (!brightnessImageView) {
        UIImage *brightnessImage =
        [UIImage imageNamed:@"public_pop_bg_brightness.png"];
        UIImage *calibrationImage =
        [UIImage imageNamed:@"public_pop_btn_brighten.png"];
        self.frame = CGRectMake(0, 0, brightnessImage.size.width / 1.15,
                                brightnessImage.size.height / 1.15);
        [View addSubview:self];
        self.userInteractionEnabled = NO;
        brightnessImageView.userInteractionEnabled = NO;
        brightnessImageView = [[UIImageView alloc] initWithImage:brightnessImage];
        brightnessImageView.alpha = 0;
        [self addSubview:brightnessImageView];
        
        for (int i = 0; i < 16; i++) {
            UIImageView *calibrationImageView =
            [[UIImageView alloc] initWithImage:calibrationImage];
            calibrationImageView.frame = CGRectMake(
                                                    12.3 + i * (110 / 15), 117, calibrationImage.size.width / 1.2,
                                                    calibrationImage.size.height / 1.2);
            calibrationImageView.tag = 10 + i;
            calibrationImageView.hidden = brightness * 1.6 < i ? YES : NO;
            [self addSubview:calibrationImageView];
        }
    }
    self.backgroundColor = RGBACOLOR(255, 255, 255, 0);
    brightnessImageView.frame =
    CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.center = self.superview.center;
    
    for (int i = 0; i < 16; i++) {
        UIImageView *calibrationImageView =
        (UIImageView *)[self viewWithTag:10 + i];
        calibrationImageView.hidden = (brightness * 1.6) * 10 < i ? YES : NO;
    }
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction |
     UIViewAnimationCurveEaseOut |
     UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         brightnessImageView.alpha = 0.9;
                         self.alpha = 1;
                     }
                     completion:NULL];
    if (state == UIGestureRecognizerStateEnded) {
        brightnessTimer =
        [NSTimer scheduledTimerWithTimeInterval:0.3
                                         target:self
                                       selector:@selector(brightnessAdjustThe)
                                       userInfo:nil
                                        repeats:NO];
    }
}
//渐隐亮度窗口
- (void)brightnessAdjustThe {
    
    if (brightnessTimer) {
        [brightnessTimer invalidate];
    }
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction |
     UIViewAnimationCurveEaseOut |
     UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         brightnessImageView.alpha = 0;
                         self.alpha = 0;
                         
                     }
                     completion:NULL];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
