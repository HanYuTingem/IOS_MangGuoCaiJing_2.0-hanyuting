//
//  ADAudioView.h
//  playerSDK
//
//  Created by ZCS on 15/9/10.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface ADAudioView : UIView
@property (nonatomic, strong) MPMusicPlayerController* mpc;
@property (nonatomic, assign) int countTime;
@property (nonatomic, assign) CGRect fullScreenFrame;
@property(nonatomic,unsafe_unretained) float voiceValume;
@property (nonatomic, strong) UILabel* countdownNumberLabel;

/** 静音按钮 */
@property (nonatomic, strong) UIButton* voiceBtn;
/** 全屏按钮 */
@property (nonatomic, strong) UIButton* fullScreenBtn;
/** 倒计时按钮 */
@property (nonatomic, strong) UIButton* countButton;


- (void)setButtonsFrame:(CGRect)frame;
-(void)autoChangeImg;
@end
