//
//  ClickDelDiBuView.m
//  LaoYiLao
//
//  Created by liujinhe on 15/12/11.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "ClickDelDiBuView.h"

@implementation ClickDelDiBuView


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _morewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _morewBtn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _morewBtn.backgroundColor = [UIColor blackColor];
        [_morewBtn setBackgroundImage:[UIImage imageNamed:@"lao_banner_bottom"] forState:UIControlStateNormal];
        [_morewBtn addTarget:self action:@selector(moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_morewBtn];
    }
    return self;
}

- (void)moreBtnClicked:(UIButton *)button{
    ZHLog(@"点击了查看更多");
    self.bummBtnBlock (button);
        
}
@end
