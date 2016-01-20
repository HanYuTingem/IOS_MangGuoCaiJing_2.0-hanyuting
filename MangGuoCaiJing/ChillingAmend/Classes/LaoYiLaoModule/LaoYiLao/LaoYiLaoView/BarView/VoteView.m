//
//  VoteView.m
//  LaoYiLao
//
//  Created by sunsu on 16/1/7.
//  Copyright © 2016年 sunsu. All rights reserved.
//

#import "VoteView.h"
@interface VoteView()

@end

@implementation VoteView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addVoteButton];
    }
    return self;
}


-(void)addVoteButton{
    CGFloat buttonX = 0;
    CGFloat buttonY = 0;
    CGFloat buttonW = 224/2;
    CGFloat buttonH = buttonW;
    CGRect btnFrame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    _voteBtn = [[UIButton alloc]initWithFrame:self.bounds];
    [self addSubview:_voteBtn];
    [_voteBtn setBackgroundImage:[UIImage imageNamed:@"toupiao"] forState:UIControlStateNormal];
    
}
@end
