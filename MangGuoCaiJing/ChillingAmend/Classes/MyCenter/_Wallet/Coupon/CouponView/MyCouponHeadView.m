//
//  MyCouponHeadView.m
//  GongYong
//
//  Created by GDH on 15/12/30.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "MyCouponHeadView.h"

@interface MyCouponHeadView ()
@property(nonatomic,strong)UIButton *notUseButton;
@property(nonatomic,strong)UIButton *alreadyUsedButton;
/** 竖线 */
@property(nonatomic,strong)UIImageView *verticalLineImageView;
/** 水平线 */
@property(nonatomic,strong)UIImageView *levelLineImageView;

@end

@implementation MyCouponHeadView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.notUseButton];
        [self addSubview:self.alreadyUsedButton];
        [self addSubview:self.verticalLineImageView];
        [self addSubview:self.levelLineImageView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(UIButton *)notUseButton{
    if (_notUseButton == nil) {
        _notUseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_notUseButton addTarget:self action:@selector(notUseButtonDown:) forControlEvents:UIControlEventTouchUpInside];
        _notUseButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_notUseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_notUseButton setTitle:@"未使用" forState:UIControlStateNormal];
        [self.notUseButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    return _notUseButton;
}
-(UIButton *)alreadyUsedButton{
    if (_alreadyUsedButton == nil) {
        _alreadyUsedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_alreadyUsedButton addTarget:self action:@selector(alreadyUsedButtonDown:) forControlEvents:UIControlEventTouchUpInside];
        _alreadyUsedButton.titleLabel.font = [UIFont systemFontOfSize:14];
         [_alreadyUsedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_alreadyUsedButton setTitle:@"已使用" forState:UIControlStateNormal];
    }
    return _alreadyUsedButton;
}
-(UIImageView *)verticalLineImageView{
    if (_verticalLineImageView == nil) {
        _verticalLineImageView = [[UIImageView alloc] init];
        _verticalLineImageView.backgroundColor = [UIColor colorWithRed:0.83f green:0.83f blue:0.83f alpha:1.00f];
    }
    return _verticalLineImageView;
}

-(UIImageView *)levelLineImageView{
    if (_levelLineImageView == nil) {
        _levelLineImageView = [[UIImageView alloc] init];
        _levelLineImageView.backgroundColor = [UIColor colorWithRed:0.83f green:0.83f blue:0.83f alpha:1.00f];
    }
    return _levelLineImageView;
}

-(void)notUseButtonDown:(UIButton *)notUseButtonDown{

    [notUseButtonDown setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.alreadyUsedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(MyCouponHeadViewNotUseButtonDown:)]) {
        [self.delegate MyCouponHeadViewNotUseButtonDown:notUseButtonDown];
    }
    NSLog(@"未使用");
}
-(void)alreadyUsedButtonDown:(UIButton *)alreadyUsedButton{
    [alreadyUsedButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.notUseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if ([self.delegate respondsToSelector:@selector(MyCouponHeadViewAlreadyUsedButtonDown:)]) {
        [self.delegate MyCouponHeadViewAlreadyUsedButtonDown:alreadyUsedButton];
    }
    NSLog(@"已使用");
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.notUseButton.frame = CGRectMake(0, 0, kkViewWidth/2, 28);
    self.alreadyUsedButton.frame = CGRectMake(CGRectGetMaxX(self.verticalLineImageView.frame), 0, kkViewWidth/2, self.notUseButton.frame.size.height);
    self.verticalLineImageView.frame = CGRectMake(CGRectGetMaxX(self.notUseButton.frame), 5, 0.5, 18);
    self.levelLineImageView.frame = CGRectMake(0, CGRectGetMaxY(self.notUseButton.frame), kkViewWidth, 0.5);
}

+(instancetype)myCouponHeadView{
    return [[self alloc] init];
}

@end
