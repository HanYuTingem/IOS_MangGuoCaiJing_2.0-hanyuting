//
//  HeadView.m
//  playerSDK
//
//  Created by ZCS on 15/8/25.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "HeadView.h"
//#import "playerVC.h"
#import "playerView.h"
@interface HeadView () {
    //playerView *playView;
}
/** 返回按钮*/
@property (nonatomic, strong) UIButton* btn;

//
@property (nonatomic, weak) playerView* playView;

//@property(nonatomic,strong)playerView *playView;

/** 写弹幕视图**/
@property (nonatomic, strong) SendDMView* sendView;
@end

@implementation HeadView
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

    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    //左侧返回按钮
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake((25 - 8.5) / 2, (25 - 16) / 2, 8.5, 16)];
    img.image = [UIImage imageNamed:@"video_btn_return"];
    img.backgroundColor = [UIColor clearColor];
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(25 - 8.25, 13.5 - 4.5, 25, 25)];
    btn.backgroundColor = [UIColor clearColor];
    //    [btn setBackgroundImage:[UIImage imageNamed:@"video_btn_return"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backBtn_Click:) forControlEvents:UIControlEventTouchUpInside];
    [btn addSubview:img];
    self.btn = btn;
    [self addSubview:self.btn];
    UILabel* titleLable = [[UILabel alloc] init];
    titleLable.frame = CGRectMake(self.bounds.size.width * 0.5 - 100, 15, 200, 14);
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = @"";
    [titleLable setFont:[UIFont systemFontOfSize:14]];
    titleLable.textColor = [UIColor whiteColor];
    //    titleLable.center = self.center;
    //    [titleLable sizeToFit];
    self.titleLabel = titleLable;
    [self addSubview:self.titleLabel];

    /**右侧弹出广告按钮*/
    if (SHOW_RIGHT_AD) {
        self.popADButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //    [self.popADButton setImage:[UIImage imageNamed:@"popWindow.png"]
        //                      forState:UIControlStateNormal];
        [self.popADButton setTitle:@"发现" forState:UIControlStateNormal];
        [self.popADButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.popADButton setTitleColor:[UIColor colorWithRed:202 / 255 green:48 / 255 blue:130 / 255 alpha:1] forState:UIControlStateNormal];
        [self.popADButton addTarget:self
                             action:@selector(popADButton_Click:)
                   forControlEvents:UIControlEventTouchUpInside];
        self.popADButton.frame = CGRectMake(self.frame.size.width - 60, 11, 40, 20);
        self.popADButton.backgroundColor = [UIColor clearColor];
        //    [self.popADButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.popADButton.tag = 2;
        //    self.popADButton.hidden = YES;
        [self addSubview:self.popADButton];
    }

    //开启弹幕
    //
    //    _startBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.popADButton.frame.origin.x, self.frame.size.height-10, 100, self.frame.size.height)];
    //
    //    [_startBtn setTitle:@"开启弹幕" forState:UIControlStateNormal];
    //
    //    [_startBtn setTitle:@"关闭弹幕" forState:UIControlStateSelected];
    //
    //    _startBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    //
    //    [_startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //
    //
    //    [_startBtn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    //
    //    [_startBtn addTarget:self action:@selector(startDanMu) forControlEvents:UIControlEventTouchUpInside];
    //
    //    _startBtn.hidden=YES;

    //    [self addSubview:_startBtn];
}
- (void)setTitleLableWH:(CGFloat)titleLableWH
{

    self.titleLabel.frame = CGRectMake(self.bounds.size.width * 0.5 - 100, 15, 200, 14);
}

- (void)setPopADButtonWH:(CGFloat)popADButtonWH
{
    self.popADButton.frame = CGRectMake(self.frame.size.width - 60, 11, 40, 20);
}
- (void)backBtn_Click:(UIButton*)sender
{

    [self.delegate closeButton_Click:sender];
}
- (void)popADButton_Click:(UIButton*)sender
{
    [self.delegate popADButton_Click:sender];
}

//开启弹幕
//-(void)startDanMu
//{
//    //寻找上一个响应者，通过响应者找到对象
//    id next = [self nextResponder];
//
//    _playView=next;
//
//    _sendView=_playView.sendView;
//
//    next = [next nextResponder];
//
//    next = [next nextResponder];

//    playerVC *playVC = [self findViewController:self];

//    if (!_startBtn.selected)
//    {
//       [playVC startDanMuBtn_Click:_startBtn];
//
//        //开启弹幕
//
//        _showOrHiddenBtn=YES;
//
//        _startBtn.selected=YES;
//
//        _sendView.hidden=NO;//显示写弹幕按钮
//    }
//    else
//    {
//        //关闭弹幕
//        _showOrHiddenBtn=NO;
//
//        _startBtn.selected=NO;
//
//        _sendView.hidden=YES;//隐藏写弹幕按钮
//
//        [playVC closeDanMuBtn_Click:_startBtn];
//
//    }

//}

@end
