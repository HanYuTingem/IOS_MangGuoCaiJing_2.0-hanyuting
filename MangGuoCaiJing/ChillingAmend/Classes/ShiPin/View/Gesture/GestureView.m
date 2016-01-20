//
//  gestureView.m
//  playerSDK
//
//  Created by zuoxiong on 15/8/24.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "gestureView.h"

@interface GestureView ()
@property (nonatomic, strong) PlayTimeView* playTimeView;
@property (nonatomic, strong) UIPanGestureRecognizer* panGRForCurrentTime;
@property (nonatomic, strong) UITapGestureRecognizer* singleTapForPop;
@property (nonatomic, strong) UITapGestureRecognizer* doubleTapForFullScreen;
//@property(nonatomic, assign) CGFloat viewAlpha;
@end

@implementation GestureView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)preparePlayTimeView
{
    self.playTimeView = [[PlayTimeView alloc]
        initWithFrame:CGRectMake((self.bounds.size.width - 100) / 2,
                          (self.bounds.size.height - 67) / 2, 100, 67)];
    self.playTimeView.fullTime = [self.delegate fullTimeDelegate];
    self.playTimeView.currentPlayTime = [self.delegate progressUpdateDelegate];
    [self addSubview:self.playTimeView];
    self.playTimeView.alpha = 0;
}

// 滑动改变播放时间、亮度、音量
- (void)changeCurrentTime:(UIPanGestureRecognizer*)recognizer
{
    NSInteger timeChange = 0;
    //    音量调节
    MPMusicPlayerController* mpc =
        [MPMusicPlayerController applicationMusicPlayer];
    //    亮度调节
    UIScreen* screen = [UIScreen mainScreen];
    //  [self currentPlayTime];
    self.playTimeView.currentPlayTime = [self.delegate progressUpdateDelegate];
    CGPoint translation = [recognizer translationInView:self];
    CGPoint touchPoint = [recognizer locationInView:self];
    //        获取当前亮度
    CGFloat screenFloat = screen.brightness;
    //        获取当前音量
    CGFloat volumeFloat = mpc.volume;
   
    
    //    判断手势方向
    static int judge = 0, panDirection = 0;
    //  static CGFloat durationFloat;

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        judge = 1;
    }
    if (judge == 1) {
        if ([self panGestureOrientation:translation] != 0) {
            judge = 2;
            panDirection = (int)[self panGestureOrientation:translation];
        }
    }
    else if (judge == 2) {
        //水平移动
        if (panDirection == 3 || panDirection == 4) {
            if (!self.playTimeView) {
                [self preparePlayTimeView];
            }
            else {
                self.playTimeView.frame = CGRectMake((self.bounds.size.width - 100) / 2,
                    (self.bounds.size.height - 67) / 2, 100, 67);
            }
            if (recognizer.state == UIGestureRecognizerStateChanged) {
                timeChange = translation.x;
                [self.playTimeView setVisible:YES];
                self.playTimeView.playTime =
                    [self.delegate progressUpdateDelegate] + timeChange;
                if (self.playTimeView.playTime > self.playTimeView.fullTime) {
                    self.playTimeView.playTime = self.playTimeView.fullTime;
                }
            }
            if (recognizer.state == UIGestureRecognizerStateEnded) {
                [self.delegate playTimeUpdateDelegate:self.playTimeView.playTime];
                [self.playTimeView setVisible:NO];
            }
        }
        else if (panDirection == 1 || panDirection == 2) { //垂直移动
            if (touchPoint.x > self.frame.size.width / 2) { //右边
                mpc.volume = volumeFloat - (translation.y / 16.00) / 80; //声音
            }
            else { //左边
                [PlayPromptView brightness:screenFloat - (translation.y / 16.00) / 200
                                  View:self.window
                                 state:recognizer.state];
                //                亮度调节
                [screen setBrightness:screenFloat - (translation.y / 16.00) / 200];
            }
        }
    }
}

// 判断手势方向
- (NSInteger)panGestureOrientation:(CGPoint)globalPan
{
    //    Judge:(int)judge
    //    if (judge == 1) {
    if (globalPan.x > 4 && globalPan.y < 4) {
        return 4;
    }
    else if (globalPan.x < -4 && globalPan.y > -4) {
        return 3;
    }
    else if (globalPan.y > 4 && globalPan.x < 4) {
        return 2;
    }
    else if (globalPan.y < -4 && globalPan.x > -4) {
        return 1;
    }
    //    }
    return 0;
}

- (instancetype)init
{
    self = [super init];
    // 初始化手势view

    [self setOpaque:NO];
    //添加拖动手势
    self.panGRForCurrentTime = [[UIPanGestureRecognizer alloc]
        initWithTarget:self
                action:@selector(changeCurrentTime:)];
    [self addGestureRecognizer:self.panGRForCurrentTime];
    //添加单击手势
    self.singleTapForPop = [[UITapGestureRecognizer alloc]
        initWithTarget:self
                action:@selector(popBySingleTap:)];
    self.singleTapForPop.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:self.singleTapForPop];

    //添加双击手势
    self.doubleTapForFullScreen = [[UITapGestureRecognizer alloc]
        initWithTarget:self
                action:@selector(fullScreenByDoubleTap:)];
    [self addGestureRecognizer:self.doubleTapForFullScreen];
    self.doubleTapForFullScreen.numberOfTapsRequired = 2;
    //设置手势冲突
    [self.singleTapForPop
        requireGestureRecognizerToFail:self.doubleTapForFullScreen];
    [self.singleTapForPop
        requireGestureRecognizerToFail:self.panGRForCurrentTime];
    return self;
}

//双击手势识别
- (void)fullScreenByDoubleTap:(UITapGestureRecognizer*)tapGR
{
    if (tapGR.state == UIGestureRecognizerStateRecognized) {
        [self.delegate doubleTapDelegate];
    }
}

// 单击手势识别
- (void)popBySingleTap:(UITapGestureRecognizer*)tapGR
{
    if (tapGR.state == UIGestureRecognizerStateRecognized) {
        [self.delegate singleTapDelegate];
    }
}

@end
