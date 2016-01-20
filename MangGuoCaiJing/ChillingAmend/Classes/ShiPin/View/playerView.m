//
//  playerView.m
//  playerSDK
//
//  Created by nsstring on 15/8/11.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "ADAudioView.h"

#import "ADModel.h"
#import "AppDelegate.h"
#import "CZJudgeNetWork.h"
#import "NetWorkTool.h"
#import "NotFoundNetworkView.h"
#import "UIImageView+WebCache.h"
#import "VideoModel.h"
#import "playerView.h"
#import "PRJ_VideoDetailViewController.h"

//#import "MiddleView.h"

static playerView* instence;
static BOOL IsOpen = YES;

#define HIDDENTIME 3

@interface playerView () <MPMediaPickerControllerDelegate, GestureViewDelegate,
    HeadViewDelegate, FootViewDelegate> {
    /**加载背景*/
    UIImageView* backgroundImageView;
}

@property (nonatomic, weak) PRJ_VideoDetailViewController* playerVC;
@property (nonatomic, assign) NSTimeInterval delegateProgress;
@property (nonatomic, assign) CGFloat viewAlpha;
//@property(nonatomic, strong) ADWebView *adWebView;
// PlayerView 's head/footView

@property (nonatomic, strong) FootView* footView;

//@property (nonatomic, strong) MiddleView* middleView;
/** 显示/隐藏head和foot的计时器 */
@property (nonatomic, strong) NSTimer* delayShowTimer;

/** 右侧弹出按钮是不是已经显示 */
@property (nonatomic, unsafe_unretained) BOOL showRightBtn;
/** 正在加载窗口 */
@property (nonatomic, weak) MBProgressHUD* loadingHud;

@end

@implementation playerView
#pragma mark init
@synthesize statusBarHidden;
@synthesize moviePlayer;

////单例
//+ (id)Instence
//{
//    if (!instence) {
//        instence = [[playerView alloc] init];
//    }
//    return instence;
//}
//
//+ (id)allocWithZone:(NSZone*)zone
//{
//    @synchronized(self)
//    {
//        if (!instence) {
//            instence = [super allocWithZone:zone]; //确保使用同一块内存地址
//            return instence;
//        }
//        return nil;
//    }
//}
//
//- (id)init;
//{
//    @synchronized(self)
//    {
//        if (self = [super init]) {
//            return self;
//        }
//        return nil;
//    }
//}
//
//- (id)copyWithZone:(NSZone*)zone;
//{
//    return self; //确保copy对象也是唯一
//}

- (void)setObjects
{
    self.clipsToBounds = NO;
    if (!moviePlayer) {
        self.player = [playerObject Instence];
        self.viewAlpha = 0;
        self.showRightBtn = NO;
        // 加载播放器
        moviePlayer = [[MPMoviePlayerViewController alloc] init];
        //设置全屏
        moviePlayer.moviePlayer.scalingMode = MPMovieScalingModeFill; // 拉伸填充view
        moviePlayer.moviePlayer.controlStyle = MPMovieControlStyleNone; // 隐藏控制条
        moviePlayer.moviePlayer.allowsAirPlay = NO;
        moviePlayer.moviePlayer.shouldAutoplay = NO;
        [moviePlayer.view setFrame:self.bounds]; // player的尺寸
        [self addSubview:moviePlayer.view];
        //播放速率
        // moviePlayer.moviePlayer.currentPlaybackRate = 5.0;

        /*绘制背景*/
        //        backgroundImageView = [[UIImageView alloc]
        //            initWithFrame:moviePlayer.moviePlayer.backgroundView.bounds];
        //#warning 这里也许要加一个新背景？
        //        backgroundImageView.image = [UIImage imageNamed:@"加载背景.png"];
        //        [moviePlayer.moviePlayer.backgroundView addSubview:backgroundImageView];
        //记录竖屏的位置信息
        self.player.playerX = self.frame.origin.x;
        self.player.playerY = self.frame.origin.y;
        self.player.playerHeight = self.bounds.size.height;
        self.player.playerWidth = self.bounds.size.width;
        //横竖屏切换通知
        [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(statusBarOrientationChange:)
                   name:UIApplicationDidChangeStatusBarOrientationNotification
                 object:nil];
        //-0-------------------------------------0-//
        // 手势View
        self.gestureView = [[GestureView alloc] init];
        self.gestureView.frame = self.bounds;
        //    self.gestureView.fullTime = self.moviePlayer.moviePlayer.duration;
        self.gestureView.delegate = self;
        [self addSubview:self.gestureView];
        self.gestureView.hidden = YES;

        //前置图片广告
        self.headAdImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.headAdImgView setContentMode:UIViewContentModeScaleAspectFill];
        self.headAdImgView.clipsToBounds = YES;
        [self addSubview:self.headAdImgView];

        // ADAudioView
        self.adAudioView = [[ADAudioView alloc]
            initWithFrame:CGRectMake(0, 0, self.bounds.size.width,
                              self.bounds.size.height)];
        self.adAudioView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.adAudioView];

        CGFloat headViewWith = moviePlayer.moviePlayer.view.bounds.size.width;

        //自定义headView
        HeadView* headView =
            [[HeadView alloc] initWithFrame:CGRectMake(0, 0, headViewWith, 44)];
        self.headView = headView;
        self.headView.alpha = 0;
        self.headView.hidden = YES;
        self.headView.delegate = self;
        [self addSubview:self.headView];

        //自定义footView
        FootView* footView = [[FootView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 41, headViewWith, 41)];
        self.footView = footView;
        footView.delegate = self;
        [self addSubview:footView];
        self.footView.alpha = 0;

        //----------------------------------------------------------------------------------
        //创建横评时发送弹幕的视图
        //        _sendView = [[SendDMView alloc] initWithFrame:CGRectMake([UIScreen
        //        mainScreen].bounds.size.height - 60, 40, 60, [UIScreen
        //        mainScreen].bounds.size.width)];
        //        [self addSubview:_sendView];
        //        self.sendView.backgroundColor = [UIColor blackColor];
        //        //竖屏状态下先隐藏
        //        _sendView.hidden = YES;

        //        //右侧按时间轴弹出的按钮
        //        self.rightPopBtnView = [[ZXRightPopBottonView alloc] initWithFrame:CGRectMake(self.frame.size.width, (self.frame.size.height - 40) / 2, 20, 40)];
        //        [self addSubview:self.rightPopBtnView];
        //        self.rightPopBtnView.button.frame = CGRectMake(4, 4, 16, 32);
        //        self.rightPopBtnView.delegate = self;

        //设置竖屏
        //                [self sRotation];
        //前置图片
        self.beginImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.beginImgView setContentMode:UIViewContentModeScaleAspectFill];
        self.beginImgView.clipsToBounds = YES;
        [self addSubview:self.beginImgView];
        //播放按钮
        self.playBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - 35) / 2, (self.frame.size.height - 35) / 2, 35, 35)];
        [self.playBtn setBackgroundImage:[UIImage imageNamed:@"video_btn_broadcast_verticalscreen"] forState:UIControlStateNormal];
        [self.playBtn addTarget:self action:@selector(tapPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.playBtn];
        self.showHeadAD = YES;
        self.playPlayingState = NO;
        _portraitBool = YES;
    }
}

#pragma mark - videoPlayer及各种view和button的添加
//----------------以下添加到playerView中-------------------------
//添加右侧按钮

//添加右侧按钮点击事件（除了弹出之外还要隐藏自己）

//特效

//添加右侧按钮按时淡入淡出

- (void)setPlayerURL:(NSString*)playerURL
{
    if ([playerURL isEqualToString:@""] || !playerURL || [playerURL isEqual:[NSNull null]]) {
    }
    else {
        NSURL* tempURL = [[NSURL alloc] initWithString:playerURL];
        if (![self.moviePlayer.moviePlayer.contentURL isEqual:tempURL]) {
            [moviePlayer.moviePlayer stop];
            moviePlayer.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
            moviePlayer.moviePlayer.contentURL = tempURL;
        }
    }
}

//根据视频播放类型显示不同的View
- (void)adHIdden
{
    if (self.isShowHeadAD == NO) {
        [moviePlayer.moviePlayer pause];
        self.footView.hidden = NO;
        self.rightPopADView.hidden = NO;
        self.gestureView.hidden = NO;
        self.adAudioView.mpc.volume = self.adAudioView.voiceValume;
        self.adAudioView.hidden = YES;
        self.headAdImgView.hidden = YES;
    }
    else {
        switch (self.headADType) {
        case 0: {
            [moviePlayer.moviePlayer pause];
            self.footView.hidden = YES;
            self.headView.hidden = YES;
            self.rightPopADView.hidden = YES;
            self.gestureView.hidden = YES;
            self.adAudioView.hidden = NO;
            break;
        }
        case 1: {
            [moviePlayer.moviePlayer pause];
            self.headAdImgView.hidden = NO;
            self.footView.hidden = YES;
            self.headView.hidden = YES;
            self.rightPopADView.hidden = YES;
            self.gestureView.hidden = YES;
            self.adAudioView.hidden = NO;
            self.adAudioView.voiceBtn.hidden = YES;
            break;
        }
        default:
            break;
        }
    }
}
- (void)timerStart
{
    if (!self.timer) {
        self.timer =
            [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(setProgressView)
                                           userInfo:nil
                                            repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)timerStop
{
    [self.timer invalidate];
    self.timer = nil;
}
- (void)showMessage
{

    if (!self.loadingHud) {
        self.loadingHud = [MBProgressHUD showMessage:@"正在努力加载中..." toView:self];
    }
    self.loadingHud.hidden = NO;
}

- (void)hideMessage
{
    //  [MBProgressHUD hideHUDForView:self];
    [self.loadingHud setHidden:YES];
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

- (void)setProgressView
{
    //视频全部的时间
    NSTimeInterval totalTime = [self.moviePlayer.moviePlayer duration];
    //当前播放时间
    NSTimeInterval currentTime =
        [self.moviePlayer.moviePlayer currentPlaybackTime];
    int tempTime = totalTime - currentTime;
    self.adAudioView.countTime = tempTime;

    [self safeToPlay];
    //计算进度条进度
    if (self.playPlayingState == MPMoviePlaybackStatePlaying) {
        if (totalTime > 0 && currentTime >= 0) {
            CGFloat progress = currentTime / totalTime;
            [self.footView.progress setProgress:progress withOutCallBack:NO];
        }
        self.footView.progress.currentTime = [self timeToString:currentTime];
        self.footView.progress.totalTime = [self timeToString:totalTime];
        //        self.continueTime = currentTime;
    }

//    PRJ_VideoDetailViewController* tempVC = [self findViewController:self];
//    [tempVC adImageVisible];

    if (currentTime >= totalTime && (fabs(totalTime) > 0.01)) {
        if (self.isShowHeadAD) {
            [self skipAD];
        }
        else {
            [self playFinished];
        }
    }
}

/** 播放完成 */
- (void)playFinished
{
    PRJ_VideoDetailViewController* tmpVC = [self findViewController:self];
    [tmpVC requstTheAwardOfLookVideoInCompleteTime];
    [self pause];
    if (self.showEndAD) {
        self.gestureView.hidden = YES;
        self.rightPopADView.hidden = YES;
        self.footView.hidden = YES;
        self.headView.hidden = YES;
        self.adAudioView.hidden = NO;
        self.adAudioView.countButton.hidden = YES;
//        [self setPlayerURL:tmpVC.endADModel.spurl];
//        [self setPlayerURL:tmpVC.detailDic[@"video_url"]];
        self.playPlayingState = YES;
        self.showEndAD = NO;
        [self playerContinue];
    }
    else {
        self.moviePlayer.moviePlayer.currentPlaybackTime = 0;
//        [self setPlayerURL:tmpVC.videoModel.spurl];
        [self setPlayerURL:tmpVC.detailDic[@"video_url"]];
        self.gestureView.hidden = YES;
        self.footView.hidden = NO;
        self.playBtn.hidden = NO;
        self.adAudioView.countButton.hidden = NO;
        self.adAudioView.hidden = YES;
        self.neverPlay = YES;
        [self pause];
        if (!self.showEndAD) {
            [self timerStop];
        }
    }
}

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

#pragma mark - 自定义progress delegate

/**拖动进度条*/
- (void)progressBtn_Moved:(CGFloat)progress
{
    // 1.暂停timer
    // 2.修改播放器的currentTime
    // 3.继续timer
    [self timerStop];
    NSTimeInterval totalTime = [self.moviePlayer.moviePlayer duration];
    NSTimeInterval newCurrent = progress * totalTime;
    [self.moviePlayer.moviePlayer setCurrentPlaybackTime:newCurrent];
    [self timerStart];
}

- (void)pause
{
    [self.footView.playPauseBtn setImage:[UIImage imageNamed:@"video_btn_broadcast"]
                                forState:UIControlStateNormal];
    [self.moviePlayer.moviePlayer pause];
    self.playPlayingState = NO;
}

//是否可以安全播放
- (BOOL)safeToPlay
{
    if (!self.moviePlayer.moviePlayer.isPreparedToPlay) {
        [self.moviePlayer.moviePlayer prepareToPlay];
    }
    if (self.moviePlayer.moviePlayer.loadState == MPMovieLoadStateUnknown || self.moviePlayer.moviePlayer.loadState == MPMovieLoadStateStalled) {
        [self showMessage];
    }
    else if (self.moviePlayer.moviePlayer.playbackState != MPMoviePlaybackStatePlaying && self.moviePlayer.moviePlayer.duration > 0 && self.playPlayingState == YES && self.moviePlayer.moviePlayer.isPreparedToPlay) {
        [self hideMessage];
        [self.moviePlayer.moviePlayer pause];
        [self.footView.playPauseBtn
            setImage:[UIImage imageNamed:@"video_btn_pause"]
            forState:UIControlStateNormal];
        if (self.continueTime > 0) {

            self.moviePlayer.moviePlayer.currentPlaybackTime = self.continueTime;
            self.continueTime = 0;
        }
        [self.moviePlayer.moviePlayer play];
        return YES;
    }
    return NO;
}

- (void)playerContinue
{

    if (self.moviePlayer.moviePlayer.playbackState != MPMoviePlaybackStatePlaying && self.playPlayingState == YES) {
        [self safeToPlay];
    }
}

//#pragma mark - 右侧弹出按钮
//- (void)tapBtn
//{
//    [self openRightPopView:YES];
//    self.rightPopBtnView.frame = CGRectMake(self.frame.size.width, (self.frame.size.height - 40) / 2, 20, 40);
//    self.showRightBtn = NO;
//}
//
//- (void)showRightPopBtn
//{
//    if (_portraitBool && self.showRightBtn) {
//        [UIView animateWithDuration:0.35
//                         animations:^{
//                             self.rightPopBtnView.frame = CGRectMake(self.frame.size.width - 20, (self.frame.size.height - 40) / 2, 20, 40);
//                         }];
//        [self delayHideRightPopBtn];
//        self.showRightBtn = !self.showRightBtn;
//    }
//    else {
//        [UIView animateWithDuration:0.35
//                         animations:^{
//                             self.rightPopBtnView.frame = CGRectMake(self.frame.size.width, (self.frame.size.height - 40) / 2, 20, 40);
//                         }];
//        self.showRightBtn = !self.showRightBtn;
//    }
//}

- (void)delayHideRightPopBtn
{
//    self.beginImgView.hidden = NO;
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(showRightPopBtn) userInfo:nil repeats:NO];
}

#pragma mark - button和view的互动
- (void)PlayPause:(id)sender
{
    UIButton* but = (UIButton*)sender;
    but.enabled = NO;
    if (but.tag == 1) { //横竖屏切换
        [self fullScreen];
    }
    else if (but.tag == 2) { //侧边View显示与隐藏
        // 暂停就弹出侧边广告，否则就隐藏广告并播放
//        PRJ_VideoDetailViewController* tempPVC = (PRJ_VideoDetailViewController*)[self responderViewController];
//        if (!tempPVC.rightModel.count) {
//#warning 这里的逻辑需要测试
//            //弹无数据的窗口
//            self.rightPopADView.hidden = YES;
//            [MBProgressHUD showError:@"小七没有找到活动券" toView:self];
//        }
//        else {
//            self.rightPopADView.hidden = NO;
//            [self openRightPopView:YES];
//            [self showHeadAndFootView:NO];
//        }
    }
    //延时，在动画完成之后才让button.enable=YES
    [NSTimer scheduledTimerWithTimeInterval:.35f
                                     target:self
                                   selector:@selector(shijian:)
                                   userInfo:but
                                    repeats:NO];
}
/** 最初在全屏正中的播放按钮 */
- (void)tapPlayBtn:(id)sender
{
    self.beginImgView.hidden = YES;
    self.playBtn.hidden = YES;
    if (self.neverPlay == YES) {
        self.neverPlay = NO;
    }

    NSString* networkInfo = [CZJudgeNetWork networkInfo];
    if ([networkInfo isEqualToString:@"3G4G"]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"警告"
                                                        message:@"亲现在是手机流量，看视频小心了哦!"
                                                       delegate:nil
                                              cancelButtonTitle:@"知道啦"
                                              otherButtonTitles:nil];
        [alert show];
    }
//    [self showMessage];
    if (self.isShowHeadAD) {
        self.adAudioView.hidden = NO;
        self.adAudioView.fullScreenBtn.hidden = NO;
        self.adAudioView.countButton.hidden = NO;

        switch (self.headADType) {
        case 0:
            self.adAudioView.voiceBtn.hidden = NO;
            //[self.moviePlayer.moviePlayer prepareToPlay];
            if (!self.moviePlayer.moviePlayer.contentURL) {
                [MBProgressHUD show:@"没有找到视频数据，请检查网络并刷新" icon:nil view:self];
            }
            else {
                //[self.moviePlayer.moviePlayer play];
                [self timerStart];
                self.playPlayingState = YES;
                //                [self playerContinue];
            }
            break;
        case 1:
            self.adAudioView.countdownNumberLabel.text = [NSString stringWithFormat:@"%zd", [self.headImgCountDownTime intValue]];
            self.headImgCountDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(headADImgCountDown) userInfo:nil repeats:YES];
            break;
        default:
            break;
        }
    }
    else {
        self.gestureView.hidden = NO;
        if (!self.moviePlayer.moviePlayer.contentURL) {
            [MBProgressHUD showError:@"没有找到视频数据，请检查网络并刷新" toView:self];
        }
        else {
            self.playPlayingState = YES;
            [self timerStart];
        }
    }
}

/** 计算图片前置广告倒计时 */
- (void)headADImgCountDown
{
    int intCDTime = [self.headImgCountDownTime intValue];

    if (intCDTime == 0) {
        [self skipAD];
    }
    self.adAudioView.countdownNumberLabel.text = [NSString stringWithFormat:@"%zd", intCDTime];
    intCDTime = intCDTime - 1;
    self.headImgCountDownTime = [NSNumber numberWithInt:intCDTime];
}

- (void)shijian:(id)sender
{
    NSTimer* shijian = (NSTimer*)sender;
    UIButton* but = (UIButton*)[shijian userInfo];
    but.enabled = YES;
}

/** 侧边View的显示与隐藏 */
- (void)openRightPopView:(BOOL)open
{
    [UIView animateWithDuration:.35f
        animations:^{
            if (open) {
                [self showRightView];
            }
            else {
                [self hideRightView];
            }
        }
        completion:^(BOOL finished) {
            IsOpen = open;
        }];
}

- (void)hideRightView
{
    self.rightPopADView.frame = CGRectMake(1000, 0, 267, self.superview.frame.size.height);
}

- (void)showRightView
{
    self.rightPopADView.frame = CGRectMake(self.frame.size.width - self.rightPopADView.frame.size.width, 0,
        267, self.superview.frame.size.height);
}

#pragma mark - rotation
//切换全屏和竖屏
- (void)fullScreen
{
//    PRJ_VideoDetailViewController* playervc = [self findViewController:self];
    statusBarHidden = _portraitBool;
    if (_portraitBool == YES) {
        //横屏 显示右侧弹出广告窗口
        [self hRotation];
        
//        playervc.backBtn.hidden = YES;
        _portraitBool = NO;
        IsOpen = YES;
    }
    else {
        //竖屏 隐藏右侧弹出广告窗口
//        playervc.backBtn.hidden = NO;
        [self sRotation];
        _portraitBool = YES;
    }
}

/**竖屏*/
- (void)sRotation
{
    if ([[UIDevice currentDevice]
            respondsToSelector:@selector(setOrientation:)]) {
        [[UIDevice currentDevice]
            setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait]
              forKey:@"orientation"];
    }
}
/**横屏*/
- (void)hRotation
{
    if ([[UIDevice currentDevice]
            respondsToSelector:@selector(setOrientation:)]) {
        [[UIDevice currentDevice]
            setValue:[NSNumber
                         numberWithInteger:UIInterfaceOrientationLandscapeRight]
              forKey:@"orientation"];
    }
}

//状态栏改变（检测横屏/竖屏的改变）
- (void)statusBarOrientationChange:(NSNotification*)notification
{
    self.player = [playerObject Instence];
    UIInterfaceOrientation orientation =
        [[UIApplication sharedApplication] statusBarOrientation];
    PRJ_VideoDetailViewController* tempVC = (PRJ_VideoDetailViewController*)[self responderViewController];
    //横屏
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) // home键靠右
    {
        
        tempVC.backBtn.hidden = YES;
        
        //重新计算PlayerView的Frame
        self.frame = self.window.frame;

        [self setHeadViewFrame:44];
        self.headView.hidden = NO;

        [self setFootViewFrame];
        self.headView.popADButton.hidden = NO;
        //调整视频广告View
        self.adAudioView.fullScreenFrame = self.frame;
        //改变侧边弹出广告窗口的位置
        [self hideRightView];

//        self.rightPopADView.hidden = NO;
//        _portraitBool = NO;

        //进度条全屏/缩小图片
        [self.footView.fullscreenButton setImage:[UIImage imageNamed:@"video_btn_narrow"]
                                        forState:UIControlStateNormal];

        //横屏时显示弹幕
        self.headAdImgView.frame = self.frame;
        //        _headView.startBtn.hidden = NO;

        //当播放弹幕的时候显示“发送弹幕”的按钮

        //        if (_headView.showOrHiddenBtn) {
        //            [playVC continueDanMu]; //横屏时继续播放
        //            _sendView.hidden = NO; //发送弹幕的视图显示
        //        }
        /** 控制导航隐藏 */
        tempVC.navigationController.navigationBar.hidden = YES;
        tempVC.tabBarController.tabBar.hidden = YES;
//        tempVC.noADDataView.hidden = YES;
    }
    //竖屏
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        tempVC.backBtn.hidden = NO;
        
        [self hideRightView];
        self.rightPopADView.hidden = YES;

        CGRect tmpFrame = CGRectMake(self.player.playerX, self.player.playerY,
            self.player.playerWidth, self.player.playerHeight);
        self.frame = tmpFrame;
        _portraitBool = YES;
        //重新计算footview的frame
        [self setFootViewFrame];
        self.headView.hidden = YES;

        //调整视频广告View
        self.adAudioView.fullScreenFrame = self.frame;

        //进度条全屏/缩小图片
        [self.footView.fullscreenButton setImage:[UIImage imageNamed:@"video_btn_scaling"]
                                        forState:UIControlStateNormal];

        self.headAdImgView.frame = self.bounds;
        /** 控制导航显示隐藏 */

//        tempVC.navigationController.navigationBar.hidden = NO;
//        tempVC.tabBarController.tabBar.hidden = NO;
//        tempVC.noADDataView.hidden = NO;
    } // end竖屏
    // 调整手势view大小
    self.gestureView.frame = self.bounds;
    [moviePlayer.view setFrame:self.bounds]; // player的尺寸
    backgroundImageView.frame = moviePlayer.moviePlayer.backgroundView.bounds;
    [self.adAudioView setButtonsFrame:self.frame];
    self.playBtn.frame = CGRectMake((self.frame.size.width - 35) / 2, (self.frame.size.height - 35) / 2, 35, 35);
    self.beginImgView.frame = self.bounds;
    [self.adAudioView autoChangeImg];
}

#pragma mark - popADButton代理方法
- (void)popADButton_Click:(UIButton*)sender
{
    [self PlayPause:sender];
    [self.headView.popADButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [self hiddenView:0];
}
/** 中间View的按钮点击事件 */
- (void)playPuseButton_Click
{
    [self playerContinue];
}

#pragma mark - gesture delegate
//下面两个功能暂时不需要
/** 手势开始时显示headView和footView */
- (void)gestureStart
{
}
/** 手势结束时隐藏headVie和footView */
- (void)gestureEnd
{
}
- (void)doubleTapDelegate
{
    [self fullScreen];
}
- (void)playTimeUpdateDelegate:(double)time
{
    [self.moviePlayer.moviePlayer pause];
    //    [self pause];
    self.moviePlayer.moviePlayer.currentPlaybackTime = time;
    //    [self.moviePlayer.moviePlayer play];
    [self playerContinue];
}

- (void)singleTapDelegate
{
    [self openRightPopView:NO];

    [self showHeadAndFootView:!self.footView.alpha];
}
- (void)setAlphaWithTapDelegate:(CGFloat)alpha {}

- (NSTimeInterval)progressUpdateDelegate
{
    return self.moviePlayer.moviePlayer.currentPlaybackTime;
}

- (NSTimeInterval)fullTimeDelegate
{
    return self.moviePlayer.moviePlayer.duration;
}

#pragma mark - HeadView的代理方法
- (void)closeButton_Click:(UIButton*)sender
{
    [[UIDevice currentDevice]
        setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait]
          forKey:@"orientation"];
}

/** 设置HeadView的Frame */
- (void)setHeadViewFrame:(CGFloat)height
{
    self.headView.frame = CGRectMake(0, 0, self.bounds.size.width, height);
    self.headView.btnWH = height;
    self.headView.popADButtonWH = height;
    self.headView.titleLableWH = height;
}

#pragma FootView的代理方法
- (void)fullScreen_Click:(UIButton*)sender
{
    [self PlayPause:sender];
}
- (void)playPauseBtn_Click:(UIButton*)sender
{
    if (self.moviePlayer.moviePlayer.playbackState == MPMoviePlaybackStatePlaying) {
        [self pause];
    }
    else {
        self.playPlayingState = YES;
        [self playerContinue];
    }
}
/** 设置FootView的Frame */
- (void)setFootViewFrame
{
    self.footView.frame = CGRectMake(0, self.bounds.size.height - 41, self.bounds.size.width, 41);
    self.footView.fullScreenWH = 32;
    //  self.footView.playBtnWH = 34;
    self.footView.progressWH = 41;
}

#pragma mark - 隐藏控件
/** 显示head和footview，show为YES时显示 */
- (void)showHeadAndFootView:(BOOL)show
{
    CGFloat alpha;
    if (show) {
        alpha = 1;
    }
    else {
        alpha = 0;
    }
    [UIView animateWithDuration:0.35
                     animations:^{
                         self.headView.alpha = alpha;
                         self.footView.alpha = alpha;
                     }];
    NSNumber* nAlpha = 0;
    if (alpha) {
        [self.delayShowTimer invalidate];
        self.delayShowTimer =
            [NSTimer scheduledTimerWithTimeInterval:5.0f
                                             target:self
                                           selector:@selector(delayShow:)
                                           userInfo:nAlpha
                                            repeats:NO];
    }
}

/** 延迟显示或隐藏head和foot */
- (void)delayShow:(id)sender
{
    NSNumber* alpha = [self.delayShowTimer userInfo];
    BOOL show = alpha.boolValue;
    [self showHeadAndFootView:show];
}

/** 跳过广告 */
- (void)skipAD
{
    [self showMessage];
    if (self.showHeadAD) {
        self.showHeadAD = NO;
        //  [self.moviePlayer.moviePlayer stop];

        [self adHIdden];
        PRJ_VideoDetailViewController* tempVC = [self findViewController:self];
//        [self setPlayerURL:tempVC.videoModel.spurl];
        [self setPlayerURL:tempVC.detailDic[@"video_url"]];
        [self.headImgCountDownTimer invalidate];
        self.headImgCountDownTimer = nil;

        self.continueTime = 0;
        //    [self.moviePlayer.moviePlayer prepareToPlay];

        self.playPlayingState = YES;
        //    [self playerContinue];
        [self timerStart];
    }
    //    else if (self.showEndAD) {
    //        self.showEndAD = NO;
    //        [self playFinished];
    //    }

    //    [self.delegate playerViewComplatePlayDelegate:self withisADURL:NO];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end