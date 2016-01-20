//
//  FootView.m
//  playerSDK
//
//  Created by ZCS on 15/8/25.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "FootView.h"
#import "HMProgressView.h"
@interface FootView () <HMProgressViewDelegate>

@end

@implementation FootView

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

    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];

    /*播放暂停按钮*/
    self.playPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playPauseBtn setImage:[UIImage imageNamed:@"video_btn_broadcast"]
                       forState:UIControlStateNormal];
    self.playPauseBtn.frame = CGRectMake(12, self.bounds.size.height * 0.5 - 17, 24, 34);
    self.playPauseBtn.hidden = NO;
    self.playPauseBtn.tag = 2;
    [self.playPauseBtn addTarget:self
                          action:@selector(playPausebtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.playPauseBtn];

    /*全屏按钮*/
    self.fullscreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fullscreenButton setImage:[UIImage imageNamed:@"video_btn_scaling"]
                           forState:UIControlStateNormal];
    [self.fullscreenButton addTarget:self
                              action:@selector(fullScreenClick:)
                    forControlEvents:UIControlEventTouchUpInside];
    self.fullscreenButton.frame = CGRectMake(self.bounds.size.width - 44, self.bounds.size.height * 0.5 - 16, 32, 32);
    self.fullscreenButton.hidden = NO;
    self.fullscreenButton.tag = 1;
    [self addSubview:self.fullscreenButton];

    /* 进度条 */
    CGRect CGframe = CGRectMake(12 + 24 + 9, 0, self.bounds.size.width - 12 - 24 - 18 - 32 - 12, 41);
    self.progress = [[HMProgressView alloc] initWithFrame:CGframe];
    //    self.progress.backgroundColor = [UIColor redColor];
    self.progress.delegate = self;
    [self addSubview:self.progress];
}
/** 点击播放/暂停按钮 */
- (void)playPausebtnClick:(UIButton*)sender
{

    [self.delegate playPauseBtn_Click:sender];
}
//- (void)autoChangeImg
//{
//    if ([self.fullscreenButton.imageView.image isEqual:[UIImage imageNamed:@"video_btn_scaling"]]) {
//        [self.fullscreenButton setImage:[UIImage imageNamed:@"video_btn_narrow"]
//                               forState:UIControlStateNormal];
//    }
//    else {
//        [self.fullscreenButton setImage:[UIImage imageNamed:@"video_btn_scaling"]
//                               forState:UIControlStateNormal];
//    }
//}
/** 点击全屏按钮 */
- (void)fullScreenClick:(UIButton*)sender
{
    [self.delegate fullScreen_Click:sender];
}
/** 切换横竖屏后保持按钮frame不变 */
- (void)setPlayBtnWH:(CGFloat)playBtnWH
{
    self.playPauseBtn.frame = CGRectMake(12, self.bounds.size.height * 0.5 - playBtnWH * 0.5, 24, playBtnWH);
}
/** 切换横竖屏后保持按钮frame不变 */
- (void)setFullScreenWH:(CGFloat)fullScreenWH
{
    self.fullscreenButton.frame = CGRectMake(self.bounds.size.width - 12 - 32, self.bounds.size.height * 0.5 - fullScreenWH * 0.5, fullScreenWH, fullScreenWH);
}
/** 切换横竖屏后保持按钮frame不变 */
- (void)setProgressWH:(CGFloat)progressWH
{
    self.progress.frame = CGRectMake(self.playPauseBtn.bounds.size.width + 9 + 12, 0, self.bounds.size.width - self.playPauseBtn.bounds.size.width - self.fullscreenButton.bounds.size.width - 18 - 24, progressWH);
}

#pragma mark - ProgressDelegate
//-(void)btnProgressViewDelegate:(HMProgressView *)hmProgressView withButton:(UIButton *)sender{
//    [self.delegate progressBtn_Click:sender];
//}
- (void)handleProgressUpdate:(CGFloat)progress
{
    [self.delegate progressBtn_Moved:progress];
}
@end
