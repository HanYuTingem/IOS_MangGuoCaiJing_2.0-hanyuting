//
//  LJHShuRuView.m
//  LaoYiLao
//
//  Created by liujinhe on 15/12/9.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "LJHShuRuView.h"

#define MinCHenWith 80    //名称宽度
#define MilIUUAWith 60    //留言起点
#define MinCHenHigt self.bounds.size.height*4/5  //高度
#define TEXTHenWith self.bounds.size.width-MinCHenWith-DANWEIWITH - 14 -16 //
#define TEXTQWEWith self.bounds.size.width-MilIUUAWith-10
#define MingChenY   self.bounds.size.height/10   //地点高度
#define DISKAiSHi   7    //起点坐标
#define DANWEIWITH  20   //单位宽度
@implementation LJHShuRuView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self makeUIandWith:frame];
    }
    return self;
}
- (void)makeUIandWith:(CGRect)frame{
    
    CGFloat trWidth = frame.size.width;
    CGFloat trHeight = frame.size.height;
    /**
     *  设置虚线框
     */
//    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.1];
//    self.layer.cornerRadius = CGRectGetWidth(self.bounds)/2;
//    CAShapeLayer *borderLayer = [CAShapeLayer layer];
//    borderLayer.bounds = CGRectMake(0, 0, trWidth, trHeight);
//    borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
//    
//    //    borderLayer.path = [UIBezierPath bezierPathWithRect:borderLayer.bounds].CGPath;
//    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:CGRectGetWidth(borderLayer.bounds)/2].CGPath;
//    borderLayer.lineWidth = 1. / [[UIScreen mainScreen] scale];
//    //虚线边框
//  //  borderLayer.lineDashPattern = @[@5, @3];
//    //实线边框
//        borderLayer.lineDashPattern = nil;
//    borderLayer.fillColor = [UIColor whiteColor].CGColor;
//    borderLayer.strokeColor = [UIColor lightGrayColor].CGColor;
//    [self.layer addSublayer:borderLayer];
    /**
     *  设置实现框
     */
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.backgroundColor = [UIColor whiteColor];
    
    //名称
    _cheHulabel = [[UILabel alloc] initWithFrame:CGRectMake(DISKAiSHi, MingChenY, MinCHenWith, MinCHenHigt)];
   // _cheHulabel.backgroundColor = [UIColor yellowColor];
    _cheHulabel.textAlignment = NSTextAlignmentLeft;
    _cheHulabel.font = UIFont30;
    
    [self addSubview:_cheHulabel];
    //输入
    _shuRulabel = [[UITextField alloc] initWithFrame:CGRectMake(MinCHenWith, 0, TEXTHenWith, trHeight)];
  //  _shuRulabel.backgroundColor = [UIColor purpleColor];
     _shuRulabel.placeholder = @"password";
     _shuRulabel.font = UIFont30;
     [_shuRulabel setBorderStyle:UITextBorderStyleNone];

    _shuRulabel.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    _shuRulabel.clearButtonMode = UITextFieldViewModeWhileEditing;//清除
    [self addSubview:_shuRulabel];
    //单位
    _danWeilabel = [[UILabel alloc] initWithFrame:CGRectMake(trWidth-7-DANWEIWITH, MingChenY, DANWEIWITH, MinCHenHigt)];
    _danWeilabel.textColor = [UIColor blackColor];
    _danWeilabel.textAlignment = NSTextAlignmentRight;
    _danWeilabel.font = UIFont30;
   // _danWeilabel.backgroundColor = [UIColor blueColor];
    [self addSubview:_danWeilabel];
    //留言
    _textTlike = [[LJHTextView alloc] initWithFrame:CGRectMake(MilIUUAWith,9, TEXTQWEWith, trHeight-10)];
    _textTlike.font = UIFont32;
    _textTlike.scrollEnabled = NO;
    _textTlike.hidden = YES;
   // _textTlike.backgroundColor = [UIColor redColor];
    _textTlike.myPlaceholder = @"新年快乐,恭喜发财!";
    _textTlike.myPlaceholderColor = [UIColor grayColor];
    [self addSubview:_textTlike];
}



@end
