//
//  playTimeView.h
//  playerSDK
//
//  Created by zuoxiong on 15/8/19.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayTimeView : UIView

@property(nonatomic, assign) NSTimeInterval fullTime;
/** 目前的播放时间*/
@property(nonatomic, assign) NSTimeInterval currentPlayTime;
/** 将要改变的播放时间*/
@property(nonatomic, assign) NSTimeInterval playTime;

- (void)setVisible:(BOOL)vis;
@end
