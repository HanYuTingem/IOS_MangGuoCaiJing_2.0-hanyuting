//
//  playerView.h
//  playerSDK
//
//  Created by nsstring on 15/8/11.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>
//#import "ADView.h"
//#import "QHDanmuManager.h"
#import "FootView.h"
#import "GestureView.h"
#import "HeadView.h"
#import "MBProgressHUD+CZ.h"
#import "RightPopADView.h"
#import "UIView+ResponderViewController.h"
#import "playerObject.h"
//#import "playerVC.h"

//发送弹幕的视图
@class SendDMView, playerView, ADAudioView, ZXRightPopBottonView;
@protocol playerViewComplatePlayDelegate <NSObject>

- (void)playerViewComplatePlayDelegate:(playerView*)playView withisADURL:(BOOL)showAD;

@end

@interface playerView : UIView
/**右側彈出的廣告View*/
@property (nonatomic, strong) RightPopADView* rightPopADView;
@property (nonatomic, assign) BOOL statusBarHidden;
@property (nonatomic, strong) id<playerViewComplatePlayDelegate> delegate;
/**是否展示前置广告*/
@property (nonatomic, assign, getter=isShowHeadAD) BOOL showHeadAD;
/** 是否展示后置广告 */
@property (nonatomic, assign, getter=isShowEndAD) BOOL showEndAD;
/** 前置广告类型 0=视频 1=图片 */
@property (nonatomic, unsafe_unretained) NSUInteger headADType;
/** 后置广告类型 0=视频 1=图片 */
@property (nonatomic, unsafe_unretained) NSUInteger endADType;
@property (nonatomic, strong) MPMoviePlayerViewController* moviePlayer;
//@property (nonatomic, weak) NSTimer *mainTimer;

@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) NSString* playerURL;

/** 发送弹幕的视图 */
@property (nonatomic, strong) SendDMView* sendView;
/** 播放器 */
@property (nonatomic, strong) playerObject* player;
/** 视频要播放 这个相当于一个手动开关 */
@property (nonatomic, assign, getter=isPlaying) BOOL playPlayingState;
/** 中间的播放/暂停按钮 */
@property (nonatomic, strong) UIButton* playBtn;
/** 续播时间记录 */
@property (nonatomic, assign) NSTimeInterval continueTime;
/** 图像前置广告view */
@property (nonatomic, strong) UIImageView* headAdImgView;
/** 前置广告控制界面 */
@property (nonatomic, strong) ADAudioView* adAudioView;
/** 前置广告倒计时总时间 */
@property (nonatomic, strong) NSNumber* headImgCountDownTime;
/** 视频播放前的图像 */
@property (nonatomic, strong) UIImageView* beginImgView;
/** 右侧按时间弹出的按钮 */
@property (nonatomic, strong) ZXRightPopBottonView* rightPopBtnView;
@property (nonatomic, strong) HeadView* headView;
@property (nonatomic, strong) GestureView* gestureView;
/** 前置图片广告倒计时 */
@property (nonatomic, strong) NSTimer* headImgCountDownTimer;
/** 判断视频是不是第一次播放 配合后台接口统计播放次数 1=未播放*/
@property (nonatomic, unsafe_unretained) BOOL neverPlay;

/** 设置各个player中各个元素的位置 */
- (void)setObjects;

/** 判断是不是要隐藏广告 */
- (void)adHIdden;

/**横竖屏判断 YES为竖屏*/
@property (nonatomic, assign) BOOL portraitBool;

/** 视频更改 */
@property (nonatomic,strong)UIViewController *viewController;
@property (nonatomic,copy) NSString      * headADUrl;
@property (nonatomic,copy) NSString      * videoUrl;

//单例
//+ (id)Instence;

//视频继续
- (void)playerContinue;
//视频暂停
- (void)pause;
/** 设置播放URL */
- (void)setPlayerURL:(NSString*)playerURL;
/** 全屏，小屏切换 */
- (void)fullScreen;
/** 显示视频加载中弹窗 */
- (void)showMessage;
/** 隐藏视频加载中弹窗 */
- (void)hideMessage;
/** 跳过广告 */
- (void)skipAD;
/** 是否弹出headview和footview */
- (void)showHeadAndFootView:(BOOL)show;
/** 隐藏右侧广告窗口 */
- (void)hideRightView;
/** 显示右侧广告窗口 */
- (void)showRightView;

- (void)timerStop;
@end
