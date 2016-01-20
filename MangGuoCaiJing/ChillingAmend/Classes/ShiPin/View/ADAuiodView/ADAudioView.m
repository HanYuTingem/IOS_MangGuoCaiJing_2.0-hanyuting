//
//  ADAudioView.m
//  playerSDK
//
//  Created by ZCS on 15/9/10.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "ADAudioView.h"
//#import "playerVC.h"
#import "playerView.h"
#import "PRJ_VideoDetailViewController.h"

@interface ADAudioView ()

@property (nonatomic, assign, getter=isSilent) BOOL silent;
/** 静音按钮背景图片 */
@property (nonatomic, strong) UIImageView* voiceBtnImg;
/** 全屏按钮背景图片 */
@property (nonatomic, strong) UIImageView* fullScreenBtnImg;
//@property (nonatomic, strong) UIButton* playBtn;
@property (nonatomic, strong) UILabel* countdownText;
/** 详情按钮 */
@property (nonatomic, strong) UIButton* detailBtn;
@end
@implementation ADAudioView

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
    self.countTime = 0;
    //VoiceButton
    //静音按钮
    UIButton* voiceBtn = [[UIButton alloc] init];
    self.voiceBtn = voiceBtn;
    self.voiceBtn.backgroundColor = [UIColor colorWithRed:55 / 255 green:55 / 255 blue:55 / 255 alpha:0.9];
    //    [voiceBtn setImage:[UIImage imageNamed:@"video_btn_mute_verticalscreen"] forState:UIControlStateNormal];
    self.voiceBtnImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_btn_voice_horizontalscreen"]];
    self.voiceBtnImg.frame = CGRectMake(12, 7.5, 15, 13);
    voiceBtn.frame = CGRectMake(0, self.bounds.size.height - 30, 45, 30);
    [voiceBtn addSubview:self.voiceBtnImg];
    [voiceBtn addTarget:self action:@selector(voiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    voiceBtn.hidden = YES;
    [self addSubview:voiceBtn];

    //倒数按钮
    UIButton* countButton = [[UIButton alloc] init];
    countButton.titleLabel.font = [UIFont systemFontOfSize:10];
    countButton.backgroundColor = [UIColor colorWithRed:55 / 255 green:55 / 255 blue:55 / 255 alpha:0.9];
    countButton.frame = CGRectMake(self.bounds.size.width - 100, 0, 100, 30);

    self.countdownNumberLabel = [[UILabel alloc] init];
    self.countdownNumberLabel.textColor = [UIColor whiteColor];
    self.countdownNumberLabel.font = [UIFont systemFontOfSize:13];
    self.countdownNumberLabel.textAlignment = NSTextAlignmentCenter;
    self.countdownNumberLabel.text = @"00";
    self.countdownNumberLabel.frame = CGRectMake(11, (countButton.frame.size.height - 13) / 2, 33, 13);

    [self.countdownNumberLabel sizeToFit];

    self.countdownText = [[UILabel alloc] init];
    self.countdownText.text = @"跳过广告";
    self.countdownText.textColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    self.countdownText.font = [UIFont systemFontOfSize:12];
    self.countdownText.frame = CGRectMake(11 + 16 + self.countdownNumberLabel.frame.size.width, (countButton.frame.size.height - 12) / 2, 100, 13);
    [self.countdownText sizeToFit];

    [countButton addSubview:self.countdownText];
    [countButton addSubview:self.countdownNumberLabel];

    [countButton addTarget:self action:@selector(tapCountDownBtn:) forControlEvents:UIControlEventTouchUpInside];
    countButton.hidden = YES;
    self.countButton = countButton;
    [self addSubview:countButton];

    //全屏按钮
    self.fullScreenBtn = [[UIButton alloc] init];
    self.fullScreenBtn.frame = CGRectMake(self.frame.size.width - 45, self.frame.size.height - 30, 45, 30);
    self.fullScreenBtn.backgroundColor = [UIColor colorWithRed:55 / 255 green:55 / 255 blue:55 / 255 alpha:0.9];

    self.fullScreenBtnImg = [[UIImageView alloc] initWithFrame:CGRectMake(45 - 16 - 12, (30 - 16) / 2, 16, 16)];
    self.fullScreenBtnImg.image = [UIImage imageNamed:@"video_btn_scaling"];

    [self.fullScreenBtn addSubview:self.fullScreenBtnImg];
    [self.fullScreenBtn addTarget:self action:@selector(tapFullScreenBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.fullScreenBtn.hidden = YES;
    [self addSubview:self.fullScreenBtn];

}

- (void)setButtonsFrame:(CGRect)frame
{
    self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.fullScreenBtn.frame = CGRectMake(frame.size.width - 45, frame.size.height - 30, 45, 30);
    self.voiceBtn.frame = CGRectMake(0, frame.size.height - 30, 45, 30);
    self.countButton.frame = CGRectMake(frame.size.width - 100, 0, 100, 30);
}

//通过相应者链条找到PlayerVC
- (PRJ_VideoDetailViewController*)findViewController:(UIView*)sourceView
{
    id target = sourceView;
    while (target) {
        target = ((UIResponder*)target).nextResponder;
        if ([target isKindOfClass:[PRJ_VideoDetailViewController class]]) {
            break;
        }
    }
    return target;
}
/** 设置倒计时 */
- (void)setCountTime:(int)countTime
{
    _countTime = countTime;
    [self.countButton setNeedsDisplay];
    //    [self.countButton setTitle:[NSString stringWithFormat:@"广告剩余时间 %zd S", countTime] forState:UIControlStateNormal];
    self.countdownNumberLabel.text = [NSString stringWithFormat:@"%zd", countTime];
    //[self.countButton sizeToFit];
}

- (void)drawRect:(CGRect)rect
{
}
/** 静音按钮点击效果 */
- (void)voiceBtnClick:(UIButton*)sender
{
    MPMusicPlayerController* mpc =
        [MPMusicPlayerController applicationMusicPlayer];
    self.silent = !self.silent;
    self.mpc = mpc;
    if (self.isSilent) {
        self.voiceBtnImg.image = [UIImage imageNamed:@"video_btn_mute_verticalscreen"];
        self.voiceValume = mpc.volume;
        mpc.volume = 0.0;
    }
    else {
        self.voiceBtnImg.image = [UIImage imageNamed:@"video_btn_voice_verticalscreen"];
        mpc.volume = self.voiceValume;
    }
}
/** 自动切换全屏/小窗播放 */ 
- (void)autoChangeImg
{
    if ([self.fullScreenBtnImg.image isEqual:[UIImage imageNamed:@"video_btn_scaling"]]) {
        [self.fullScreenBtnImg setImage:[UIImage imageNamed:@"video_btn_narrow"]];
    }
    else {
        [self.fullScreenBtnImg setImage:[UIImage imageNamed:@"video_btn_scaling"]];
    }
}

/** 全屏按钮点击 */
- (void)tapFullScreenBtn:(id)sender
{
    PRJ_VideoDetailViewController* playervc = [self findViewController:self];
    playervc.tabBarController.tabBar.hidden = YES;
    [playervc.playerV fullScreen];
}

//- (void)tapPlayBtn:(id)sender
//{
//  self.voiceBtn.hidden=NO;
//  self.fullScreenBtn.hidden=NO;
//  self.countButton.hidden=NO;
//    self.playBtn.hidden = YES;
//    PRJ_VideoDetailViewController* playervc = [self findViewController:self];
//    [playervc.playerV playerContinue];
//}

- (void)tapCountDownBtn:(id)sender
{
    PRJ_VideoDetailViewController* playervc = [self findViewController:self];
    if (self.silent) {
        MPMusicPlayerController* mpc =
            [MPMusicPlayerController applicationMusicPlayer];
        mpc.volume = self.voiceValume;
    }

    [playervc.playerV skipAD];
}

@end
