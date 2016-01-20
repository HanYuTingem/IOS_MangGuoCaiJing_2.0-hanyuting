//
//  HeadView.h
//  playerSDK
//
//  Created by ZCS on 15/8/25.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeadView;

@protocol HeadViewDelegate <NSObject>

-(void)closeButton_Click:(UIButton *)sender;
-(void)popADButton_Click:(UIButton *)sender;


@end
@interface HeadView : UIView
@property (nonatomic, weak) id<HeadViewDelegate> delegate;
@property (nonatomic, assign) CGFloat btnWH;
@property (nonatomic, assign) CGFloat popADButtonWH;
@property (nonatomic, assign) CGFloat titleLableWH;
/**弹出广告按钮*/
@property(nonatomic, strong) UIButton *popADButton;
@property (nonatomic, strong) UILabel *titleLabel;


//开启弹幕按钮
//@property(nonatomic,strong)UIButton *startBtn;
//@property(nonatomic,assign)BOOL showOrHiddenBtn;
@end
