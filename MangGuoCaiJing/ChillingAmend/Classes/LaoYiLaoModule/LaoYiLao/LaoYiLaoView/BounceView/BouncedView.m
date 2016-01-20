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
static BouncedView *bouncedView;
@implementation BouncedView

+ (BouncedView *)shareBounceView{
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            bouncedView = [[BouncedView alloc]init];
        });
        return bouncedView;
}
 
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
    [self addAnaimationWithDuration:0.2 view:[BounceDumplingInforView shareBounceDumplingInforView]];
    [self addSubview:[BounceDumplingInforView shareBounceDumplingInforView]];
    
}

- (void)addSharedWithCeilingViewType:(NSString *)type{
    
    [self removeSelfWithSubviews];
    [BounceSharedCeilingView shareBounceSharedCeilingView].viewController = _viewController;
    [BounceSharedCeilingView shareBounceSharedCeilingView].type = type;
    [self addAnaimationWithDuration:0.2 view:[BounceSharedCeilingView shareBounceSharedCeilingView]];
    [self addSubview:[BounceSharedCeilingView shareBounceSharedCeilingView]];
}

/**
 *  移除本类的子视图
 */
- (void)removeSelfWithSubviews{
    
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [_viewController.view addSubview:self];
}
- (void)tap:(UITapGestureRecognizer *)tap{
//    [self removeFromSuperview];
}


- (void)setDumplingInforModel:(DumplingInforModel *)dumplingInforModel{
    _dumplingInforModel = dumplingInforModel;
    [BounceDumplingInforView shareBounceDumplingInforView].viewController = _viewController;
    [[BounceDumplingInforView shareBounceDumplingInforView] refreshDataWithModel:_dumplingInforModel];
}



#pragma mark --调动动画
- (void)addBeatingAnimationWithDuration:(int)duration
{
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [[BounceDumplingInforView shareBounceDumplingInforView].layer addAnimation:animation forKey:nil];
//    UIView *view = [BounceDumplingInforView shareBounceDumplingInforView];
//    //创建一个CABasicAnimation对象
//    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    view.layer.anchorPoint = CGPointMake(.5,.5);
//    // animation.fromValue = @2.0f;
//    animation.toValue = @0.5f;
//    
//    //动画时间
//    animation.duration=1;
//    animation.beginTime=CACurrentMediaTime()+1;
//    //是否反转变为原来的属性值
//    // animation.autoreverses=YES;
//    //把animation添加到图层的layer中，便可以播放动画了。forKey指定要应用此动画的属性
//    [view.layer addAnimation:animation forKey:@"scale"];
//    
//    
//    
//    CABasicAnimation *theAnimation;
//    // create the animation object, specifying the position property as the key path
//    // the key path is relative to the target animation object (in this case a CALayer)
//    theAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
//    
//    // set the fromValue and toValue to the appropriate points
//    theAnimation.fromValue=[NSValue valueWithCGPoint:CGPointMake(74.0,74.0)];
//    theAnimation.toValue=[NSValue valueWithCGPoint:CGPointMake(300.0,406.0)];
//    
//    // set the duration to 3.0 seconds
//    theAnimation.duration=3.0;
//    
//    // set a custom timing function
//    theAnimation.timingFunction=[CAMediaTimingFunction functionWithControlPoints:0.25f :0.1f :0.25f :1.0f];
//    [view.layer addAnimation:theAnimation forKey:@"move"];
    
}

#pragma mark-- 弹框动画
- (void)addAnaimationWithDuration:(int)duration view:(UIView *)view{
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    view.layer.anchorPoint = CGPointMake(.5,.5);
    animation.fromValue = @0.0f;
    animation.toValue = @1.0f;
    
    //动画时间
    animation.duration=duration;
    //是否反转变为原来的属性值
    // animation.autoreverses=YES;
    //把animation添加到图层的layer中，便可以播放动画了。forKey指定要应用此动画的属性
    [view.layer addAnimation:animation forKey:@"scale"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
