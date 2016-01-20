//
//  HMProgressView.h
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 zcs. All rights reserved.
//

#import "HMProgressView.h"
#define LABLEWITH 0

@interface HMProgressView ()

@property (nonatomic, strong) UIImage* bgImage;
@property (nonatomic, strong) UIImage* readyImage;
@property (nonatomic, strong) UIImage* currentImgae;
@property (nonatomic, assign, getter=isPlaying) BOOL playing;
@property (nonatomic, assign, getter=isDraging) BOOL drage;

@end

@implementation HMProgressView

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.playcontinue = NO;
    self.drage = NO;
    self.playing = YES;
    UIButton* btn = [[UIButton alloc] init];
    self.playButton = btn;

    [self.playButton setFrame:CGRectMake(-12, self.bounds.size.height * 0.5 - 17, 24, 34)];
    [self.playButton setImage:[UIImage imageNamed:@"video_btn_progress"] forState:UIControlStateNormal];
    //添加按钮的单击事件target
    [self.playButton addTarget:self action:@selector(buttonDrag:event:) forControlEvents:UIControlEventTouchDragInside];
    //    [self.playButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.playButton];
    self.totalTime = @"00:00";
    self.currentTime = @"00:00";
    //    [self adjustPlayButtonPosition];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // 圆角矩形背景
    self.backgroundColor = [UIColor clearColor];
    //当前播放时间
    NSString* tempStr = [NSString stringWithFormat:@"%@/", self.currentTime];
    NSAttributedString* str = [[NSAttributedString alloc] initWithString:tempStr attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:11] }];
  
    [str drawAtPoint:CGPointMake(self.bounds.size.width - 70, rect.origin.y + 20)];
    //总时间
    NSAttributedString* total = [[NSAttributedString alloc] initWithString:self.totalTime attributes:@{ NSForegroundColorAttributeName : FXQColor(156, 156, 156), NSFontAttributeName : [UIFont systemFontOfSize:11] }];
    [total drawAtPoint:CGPointMake(self.bounds.size.width - 70 + str.size.width, rect.origin.y + 20)];
    //进度条背景
    UIBezierPath* backGround = [UIBezierPath bezierPathWithRect:CGRectMake(0, self.bounds.size.height * 0.5 - 1, self.bounds.size.width, 1)];
    [[UIColor whiteColor] setFill];
    [backGround fill];
    [backGround addClip];
    //进度条前景
    UIBezierPath* forward = [UIBezierPath bezierPathWithRect:CGRectMake(0, self.bounds.size.height * 0.5 - 1, self.bounds.size.width * self.progress, 1)];
//    [FXQColor(202, 48, 130) setFill];
    [FXQColor(255, 112, 56) setFill];
//    [FXQColor(255, 198, 46) setFill];
    [forward fill];
    [forward addClip];
}

//设置进度条
- (void)setProgress:(float)progress withOutCallBack:(BOOL)needCallBack
{
    _progress = progress;
    if (_progress>1) {
        _progress=1;
    } else if(_progress<0){
        _progress=0;
    }
    [self setNeedsDisplay];
    [self adjustPlayButtonPosition];
    if (needCallBack) {
        [self.delegate handleProgressUpdate:progress];
    }
}

- (void)setProgress:(float)progress
{
    [self setProgress:progress withOutCallBack:YES];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    self.drage = YES;
    CGPoint point = [[touches anyObject] locationInView:self];
    CGFloat progress = (point.x + LABLEWITH + 5) / (self.bounds.size.width);
    self.playing = progress;
    [self setProgress:progress];
    [self.delegate handleProgressUpdate:progress];
}

//调整进度条条按钮的位置
- (void)adjustPlayButtonPosition
{
    CGFloat playButtonWH = 24;
    [self.playButton setFrame:CGRectMake(self.bounds.size.width * self.progress - playButtonWH * 0.5, self.bounds.size.height * 0.5 - playButtonWH * 0.5, playButtonWH, playButtonWH)];
}
//拖动进度条
- (void)buttonDrag:(UIButton*)button event:(UIEvent*)event
{
    self.drage = YES;
    self.playing = !self.playing;
    CGFloat x = [[[event touchesForView:button] anyObject] locationInView:self].x - LABLEWITH ;

    //进度条范围内拖拽
    if (x > 1) {
        [self setProgress:x / self.bounds.size.width];
    }

    if (x > self.bounds.size.width) {
        [self setProgress:1];
    }
}

@end
