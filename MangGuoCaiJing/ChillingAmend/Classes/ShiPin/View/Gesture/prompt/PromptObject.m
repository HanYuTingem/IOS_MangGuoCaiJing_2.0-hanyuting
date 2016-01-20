//
//  PromptObject.m
//  playerSDK
//
//  Created by nsstring on 15/8/18.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "PromptObject.h"

// 获取RGB颜色
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@implementation PromptObject

+ (PromptObject*)sharedView {
    static dispatch_once_t once;
    static PromptObject *sharedView;
    dispatch_once(&once, ^ { sharedView = [[PromptObject alloc] init]; });
    return sharedView;
}

+(void)brightness:(CGFloat)brightness{
    
    [[PromptObject sharedView] showWithStatus:betaStage];
}

- (void)showWithStatus:(CGFloat)brightness{
    static UIImageView *brightnessImageView;
    
    if (brightnessImageView) {
        UIImage *brightnessImage = [UIImage imageNamed:@"public_pop_bg_brightness.png"];
        
        UIView *brightnessView = [[UIView alloc]init];
        brightnessView.frame = CGRectMake(0, 0, brightnessImage.size.width/2, brightnessImage.size.height/2);
        brightnessView.backgroundColor = RGBACOLOR(255, 255, 255, 0);
        
        
        brightnessImageView = [[UIImageView alloc]initWithImage:brightnessImage];
        brightnessImageView.frame = CGRectMake(0, 0, brightnessImage.size.width/2, brightnessImage.size.height/2);
        
    }
    
}

@end
