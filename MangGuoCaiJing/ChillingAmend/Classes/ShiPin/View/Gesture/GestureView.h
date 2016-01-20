//
//  gestureView.h
//  playerSDK
//
//  Created by zuoxiong on 15/8/24.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PlayPromptView.h"
#import "playTimeView.h"

@protocol GestureViewDelegate <NSObject>


/** 双击全屏代理 */
- (void)doubleTapDelegate;
/** 左划右划手势更新进度条代理 */
- (void)playTimeUpdateDelegate:(double)time;
/** 单击隐藏代理 */
- (void)singleTapDelegate;

- (NSTimeInterval)progressUpdateDelegate;
- (NSTimeInterval)fullTimeDelegate;

@end

@interface GestureView : UIView
@property (nonatomic, weak) id<GestureViewDelegate> delegate;
@end
