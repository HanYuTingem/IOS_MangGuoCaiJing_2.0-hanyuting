//
//  BouncedView.m
//  LaoYiLao
//
//  Created by wzh on 15/10/31.
//  Copyright (c) 2015年 sunsu. All rights reserved.
//

#import "BouncedView.h"


//back 的view
#define BackViewX 
#define BackViewY
#define BackViewW
#define BackViewH

@interface BouncedView ()

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation BouncedView

- (instancetype)init{
    if(self = [super init]){
        self.frame = CGRectMake(0, 0, kkViewWidth, kkViewHeight);
        self.backgroundColor = BackColor;
//        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
//        [self addGestureRecognizer:_tap];
    }
    return self;
}

- (void)addDumplingInforView{
    
    [self removeSelfWithSubviews];
    [BounceDumplingInforView shareBounceDumplingInforView].viewController = _viewController;
    if([LogingState isEqualToString:LoginStateYES]){//已登录
        _logingBounceView = [[BounceWithLogingView alloc]init];
        _logingBounceView.model = _dumplingInforModel;
        [self addSubview:_logingBounceView];
    }else{//未登录
        _noLogingBounceView = [[BounceWithNoLogingView alloc]init];
        _noLogingBounceView.model = _dumplingInforModel;
        [self addSubview:_noLogingBounceView];
    }
}

- (void)addSharedWithLogingView{

    [self removeSelfWithSubviews];
    _bounceWithLogingView = [[BounceShareLogingView alloc]init];
    [_bounceWithLogingView sharedWithLoging];
    [self addSubview:_bounceWithLogingView];

}

- (void)addSharedWithCeilingView{
    
    [self removeSelfWithSubviews];
    _bounceSharedCeilingView = [[BounceSharedCeilingView alloc]init];
    [_bounceSharedCeilingView sharedWithCeiling];
    [self addSubview:_bounceSharedCeilingView];
}

/**
 *  移除本类的子视图
 */
- (void)removeSelfWithSubviews{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}
- (void)tap:(UITapGestureRecognizer *)tap{
//    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
