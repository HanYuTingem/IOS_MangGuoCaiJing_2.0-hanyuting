//
//  FootView.h
//  playerSDK
//
//  Created by ZCS on 15/8/25.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMProgressView.h"

@class FootView;

@protocol FootViewDelegate <NSObject>

-(void)fullScreen_Click:(UIButton *)sender;
-(void)playPauseBtn_Click:(UIButton *)sender;
-(void)progressBtn_Moved:(CGFloat )progress;
@end

@interface FootView : UIView
@property (nonatomic, weak) id<FootViewDelegate> delegate;
/**全屏按钮*/
@property(nonatomic, strong) UIButton *fullscreenButton;
/** 播放按钮 */
@property (nonatomic, strong) UIButton *playPauseBtn;
@property (nonatomic, assign) CGFloat fullScreenWH;
@property (nonatomic, assign) CGFloat playBtnWH;
@property(nonatomic, strong) HMProgressView *progress;
@property (nonatomic, assign) CGFloat progressWH;

@end
