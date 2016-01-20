//
//  HMProgressView.h
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 zcs. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BUTTON_INSET 40
@class HMProgressView;

@protocol HMProgressViewDelegate <NSObject>

/** 更新Progress代理*/
- (void)handleProgressUpdate:(CGFloat)progress;
///**监听按钮点击事件代理*/
//- (void)btnProgressViewDelegate:(HMProgressView *)hmProgressView withButton:(UIButton *)sender;

@end

@interface HMProgressView : UIView

@property (nonatomic, assign) float progress;
@property (nonatomic, strong) UIButton * playButton;
@property (nonatomic, assign) BOOL playcontinue;
@property (nonatomic, weak) id<HMProgressViewDelegate> delegate;
/** 当前播放时间 */
@property (nonatomic, copy) NSString *currentTime;
/** 总时间 */
@property (nonatomic, copy) NSString *totalTime;
//@property (nonatomic, weak) UILabel *fullTimeLable;

- (void)setProgress:(float)progress withOutCallBack:(BOOL)needCallBack;

@end
