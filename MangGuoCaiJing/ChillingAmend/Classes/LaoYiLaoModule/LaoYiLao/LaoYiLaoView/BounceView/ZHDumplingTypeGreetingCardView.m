//
//  ZHDumplingTypeGreetingCardView.m
//  LaoYiLao
//
//  Created by wzh on 15/12/17.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "ZHDumplingTypeGreetingCardView.h"

#define ZHDumplingTypeGreetingCardViewX 0//无所谓居中
#define ZHDumplingTypeGreetingCardViewY 0
#define ZHDumplingTypeGreetingCardViewW 450 / 2 * KPercenX
#define ZHDumplingTypeGreetingCardViewH 180 * KPercenY

@implementation ZHDumplingTypeGreetingCardView

- (instancetype)init{
    if(self = [super init]){
        self.frame = CGRectMake(ZHDumplingTypeGreetingCardViewX, ZHDumplingTypeGreetingCardViewY, ZHDumplingTypeGreetingCardViewW, ZHDumplingTypeGreetingCardViewH);
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.image = [UIImage imageNamed:@"shenmiheka_img"];
        [self addSubview:imageView];
        
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
