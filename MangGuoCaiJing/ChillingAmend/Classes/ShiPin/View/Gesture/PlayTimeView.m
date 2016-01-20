//
//  playTimeView.m
//  playerSDK
//
//  Created by zuoxiong on 15/8/19.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "PlayTimeView.h"

@interface PlayTimeView ()

/** 快进快退图标*/
@property (nonatomic, strong) UIImage* icon;
@property (nonatomic, strong) UILabel* timeLabel;
@end

@implementation PlayTimeView
- (void)setPlayTime:(NSTimeInterval)playTime
{
    if (self.fullTime < playTime) {
        _playTime = self.fullTime;
    }
    _playTime = playTime;

    if (_playTime < 0) {
        _playTime = 0;
    }
    [self setNeedsDisplay];
}
/** 设置显示/隐藏 */ 
- (void)setVisible:(BOOL)vis
{
    if (vis) {
        //      [UIView animateWithDuration:0.2 animations:^{
        //          self.alpha=0.8;
        //      }];
        [UIView animateWithDuration:0.35
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.alpha = 0.8;
                         }
                         completion:NULL];
        //      self.alpha=0.8;
    }
    else {
        [UIView animateWithDuration:0.35
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.alpha = 0;
                         }
                         completion:NULL];
    }
}

/**
 *  将double的秒数变成人类可阅读的时间形式
 *
 *  @param time 一个NSTimeInterval 秒数
 *
 *  @return 返回一个“分：秒”的string
 */
- (NSString*)timeToString:(NSTimeInterval)time
{
    NSString *minuteString, *secondString;
    NSInteger intTime = (NSInteger)time;
    NSInteger minute = intTime / 60;
    NSInteger second = intTime % 60;
    if (minute < 0) {
        minute = 0;
    }
    if (second < 0) {
        second = 0;
    }
    if (minute < 10) {
        minuteString = [NSString stringWithFormat:@"0%zd", minute];
    }
    else {
        minuteString = [NSString stringWithFormat:@"%zd", minute];
    }
    if (second < 10) {
        secondString = [NSString stringWithFormat:@"0%zd", second];
    }
    else {
        secondString = [NSString stringWithFormat:@"%zd", second];
    }
    NSString* res =
        [[NSString alloc] initWithFormat:@"%@:%@", minuteString, secondString];
    return res;
}

/**
 *  绘制进度条
 *
 *  @param oriPoint 进度条左上角的原点
 */
- (void)drawProgressingBarAtPoint:(CGPoint)oriPoint
{
    // 全部进度条
    UIBezierPath* rect = [UIBezierPath
        bezierPathWithRoundedRect:CGRectMake(oriPoint.x, oriPoint.y, 80, 6)
                     cornerRadius:0.1];
    [[UIColor blackColor] setFill];
    [rect fill];

    // 指示播放了多久的进度条
    CGFloat currentPrograss = self.playTime / self.fullTime * 80;
    if (currentPrograss < 0) {
        currentPrograss = 0;
    }
    else if (currentPrograss > 80) {
        currentPrograss = 80;
    }
    rect =
        [UIBezierPath bezierPathWithRoundedRect:CGRectMake(oriPoint.x, oriPoint.y, currentPrograss, 3)
                                   cornerRadius:0.1];
    [FXQColor(202, 48, 130) setFill];
    [rect fill];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // 圆角矩形背景
    UIBezierPath* roundRect =
        [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                   cornerRadius:0.05 * self.bounds.size.height];
    [[UIColor blackColor] setFill];
    [roundRect fill];
    [roundRect addClip];

    //当前播放时间
    NSString* tempStr = [NSString stringWithFormat:@"%@/", [self timeToString:self.playTime]];
    NSAttributedString* str = [[NSAttributedString alloc] initWithString:tempStr attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    [str drawAtPoint:CGPointMake(20, 40)];

    //总时间
    NSAttributedString* total = [[NSAttributedString alloc] initWithString:[self timeToString:self.fullTime] attributes:@{ NSForegroundColorAttributeName : FXQColor(156, 156, 156) }];
    [total drawAtPoint:CGPointMake(20 + str.size.width, 40)];

    // drawing playtime icon
    if (self.playTime < self.currentPlayTime) {
        self.icon = [UIImage imageNamed:@"video_btn_rewind"];
    }
    else {
        self.icon = [UIImage imageNamed:@"video_btn_fastforward"];
    }
    [self.icon drawInRect:CGRectMake((self.frame.size.width - 32) / 2, 16, 32, 23)];

    [self drawProgressingBarAtPoint:CGPointMake(10, 54)];
}

#pragma mark - Initialization
- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    self.alpha = 0.8;
    [self addSubview:self.timeLabel];
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

@end
