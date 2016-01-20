//
//  LMDotIndicatorView.m
//  fanxiaoqi
//
//  Created by 李敏 on 15/12/07.
//  Copyright (c) 2015年 sinoglobal. All rights reserved.
//

#import "LMDotIndicatorView.h"

static const NSUInteger dotNumber = 3;
static const CGFloat dotSeparatorDistance = 10.0f;

@interface LMDotIndicatorView ()

@property (nonatomic, assign) LMDotIndicatorViewStyle dotStyle;
@property (nonatomic, assign) CGSize dotSize;
@property (nonatomic, retain) NSMutableArray *dots;
@property (nonatomic, assign) BOOL animating;
@end

@implementation LMDotIndicatorView
+ (LMDotIndicatorView *)createDotShowView:(UIView *)showView
{
    static LMDotIndicatorView *dot = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect dotFrame = CGRectMake(0, 0, screenWidth, showView.bounds.size.height);
        dot = [[LMDotIndicatorView alloc] initWithFrame:dotFrame dotStyle:LMDotIndicatorViewStyleSquare dotColor:[UIColor lightGrayColor] dotSize:CGSizeMake(10, 10)];
        dot.backgroundColor = [UIColor whiteColor];;
        dot.layer.cornerRadius = 5.0f;
        
    });
    [showView addSubview:dot];
    return dot;
}
- (id)initWithFrame:(CGRect)frame
           dotStyle:(LMDotIndicatorViewStyle)style
           dotColor:(UIColor *)dotColor
            dotSize:(CGSize)dotSize
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _dotStyle = style;
        _dotSize = dotSize;
        
        _dots = [[NSMutableArray alloc] init];
        //CGFloat xPos = CGRectGetWidth(frame) / 2 - dotSize.width * 3 / 2 - dotSeparatorDistance;
        CGFloat xPos = screenWidth / 2 - dotSize.width * 3 / 2 - dotSeparatorDistance;
        CGFloat yPos = (CGRectGetHeight(frame) / 2 - _dotSize.height / 2);
//        if (screenHeight <= 490) {
//            yPos = screenHeight*0.16;
//        }else if (screenHeight <= 570)
//        {
//            yPos = (CGRectGetHeight(frame) / 2 - _dotSize.height / 2)*0.5;
//        }
        for (int i = 0; i < dotNumber; i++)
        {
            CAShapeLayer *dot = [CAShapeLayer new];
            dot.path = [self createDotPath].CGPath;
            dot.frame = CGRectMake(xPos, yPos, _dotSize.width, _dotSize.height);
            dot.opacity = 0.3 * i;
            dot.fillColor = dotColor.CGColor;
            
            [self.layer addSublayer:dot];
            
            [_dots addObject:dot];
            
            xPos = xPos + (dotSeparatorDistance + _dotSize.width);
        }

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((screenWidth-75)*0.5, yPos+30, 75, 12)];
        [label setText:@"正在加载中..."];
        [label setFont:[UIFont systemFontOfSize:12]];
        [label setTextColor:FXQColor(156, 156, 156)];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    
    return self;
}

- (UIBezierPath *)createDotPath
{
    CGFloat cornerRadius = 0.0f;
    if (_dotStyle == LMDotIndicatorViewStyleSquare)
    {
        cornerRadius = 0.0f;
    }
    else if (_dotStyle == LMDotIndicatorViewStyleRound)
    {
        cornerRadius = 2;
    }
    else if (_dotStyle == LMDotIndicatorViewStyleCircle)
    {
        cornerRadius = self.dotSize.width / 2;
    }
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.dotSize.width, self.dotSize.height) cornerRadius:cornerRadius];
    
    return bezierPath;
}

- (CAAnimation *)fadeInAnimation:(CFTimeInterval)delay
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(0.3f);
    animation.toValue = @(1.0f);
    animation.duration = 0.9f;
    animation.beginTime = delay;
    animation.autoreverses = YES;
    animation.repeatCount = HUGE_VAL;
    return animation;
}

- (void)startAnimating
{
    if (_animating)
    {
        return;
    }

    for (int i = 0; i < _dots.count; i++)
    {
        [_dots[i] addAnimation:[self fadeInAnimation:i * 0.4] forKey:@"fadeIn"];
    }
    
    _animating = YES;
}

- (void)stopAnimating
{
    if (!_animating)
    {
        return;
    }
    
    for (int i = 0; i < _dots.count; i++)
    {
        [_dots[i] addAnimation:[self fadeInAnimation:i * 0.4] forKey:@"fadeIn"];
    }
    
    _animating = NO;
}

- (BOOL)isAnimating
{
    return _animating;
}

- (void)removeFromSuperview
{
    [self stopAnimating];
    
    [super removeFromSuperview];
}

@end
