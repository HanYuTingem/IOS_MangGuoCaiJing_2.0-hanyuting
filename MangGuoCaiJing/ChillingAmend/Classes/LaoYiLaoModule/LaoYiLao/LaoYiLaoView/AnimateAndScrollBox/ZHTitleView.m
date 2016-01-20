//
//  ZHTitleView.m
//  LaoYiLao
//
//  Created by wzh on 16/1/7.
//  Copyright © 2016年 sunsu. All rights reserved.
//

#import "ZHTitleView.h"
#define TitleContentLabX 0 //无所谓
#define TitleContentLabY 0 // 无所为
#define TitleContentLabW 180
#define TitleContentLabH 30
@implementation ZHTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self createUI];
    }
    return self;
}

- (instancetype)init{
    if(self = [super init]){
        
    }
    return self;
}
- (void)createUI{
    _contentlab= [[UILabel alloc]initWithFrame:CGRectMake(TitleContentLabX, TitleContentLabY, TitleContentLabW, TitleContentLabH)];
    //        contentlab.backgroundColor = [UIColor brownColor];
    _contentlab.center = CGPointMake(self.center.x, self.center.y);
    _contentlab.textAlignment = NSTextAlignmentCenter;
    _contentlab.textColor = [UIColor whiteColor];
    _contentlab.font = UIFont32;
    [self addSubview:_contentlab];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
