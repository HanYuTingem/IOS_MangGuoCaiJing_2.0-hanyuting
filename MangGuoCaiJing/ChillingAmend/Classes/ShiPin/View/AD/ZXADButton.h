//
//  ZXADButton.h
//  fanxiaoqi
//
//  Created by xiong on 15/10/8.
//  Copyright (c) 2015年 sinoglobal. All rights reserved.
//

#import "CZView.h"
#import "CZButton.h"
#import "CZImageView.h"

@interface ZXADButton : CZButton <NSCopying>
/** 上方的遮罩画面 */
@property (nonatomic, weak) IBOutlet CZImageView* maskImageView;
/** 要展示的图片 */
@property (nonatomic, weak) IBOutlet CZImageView* backgroundImageView;
/** 序号 */
@property (nonatomic, weak) IBOutlet UILabel* numberLabel;
/** 判断横竖屏 */
@property (nonatomic, assign, getter=isLandscape) BOOL landscape;
//@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *numberBackgroundView;

+ (id)createButton;
/**
 *  根据index设置按钮的状态
 *
 *  @param index 0=未激活，1=竖屏激活，2=横屏激活
 */
- (void)setState:(int)index;

@end
