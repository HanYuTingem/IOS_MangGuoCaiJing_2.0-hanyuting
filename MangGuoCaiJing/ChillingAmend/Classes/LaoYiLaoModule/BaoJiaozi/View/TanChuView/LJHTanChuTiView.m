//
//  LJHTanChuTiView.m
//  LaoYiLao
//
//  Created by liujinhe on 15/12/17.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "LJHTanChuTiView.h"
#import "LJHTanChuNeiView.h"
#import "LJHTanChuViewAnimation.h"
#define TANCHUWITH   kkViewWidth-2*TANCHU_X
#define TANCHUHIGHT  3*(kkViewWidth-TANCHU_X)/5
#define TANCHU_X     20
#define TANCHU_Y     kkViewHeight/2-TANCHUHIGHT/2
@implementation LJHTanChuTiView
+ (LJHTanChuTiView*)sharedManager{
  
    static LJHTanChuTiView *sharedLJHTanChuTiViewInstand = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLJHTanChuTiViewInstand = [[LJHTanChuTiView alloc] initWithFrame:CGRectMake(0 , 0,kkViewWidth, kkViewHeight)];
      
    });
    return sharedLJHTanChuTiViewInstand;

}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self makeUI];
    }
    return self;
}
- (void)makeUI{
    self.backgroundColor = [UIColor colorWithRed:0.2392 green:0.1333 blue:0.1294 alpha:0.5];
    _teeVV = [[LJHTanChuNeiView alloc] initWithFrame:CGRectMake(TANCHU_X, TANCHU_Y, TANCHUWITH, TANCHUHIGHT)];
   
    [self addSubview:_teeVV];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}
- (void)turnDefoutViewWithTyp:(NSInteger)typ{
    if (typ==1) {
      _teeVV.biaoTiMiddleLabel.text = @"饺子已经包好了,不发送给朋友么?";
    }else{
      _teeVV.biaoTiMiddleLabel.text = @"饺子已经包好了,不扔进大锅中让网友捞么?";
    }

}
@end
