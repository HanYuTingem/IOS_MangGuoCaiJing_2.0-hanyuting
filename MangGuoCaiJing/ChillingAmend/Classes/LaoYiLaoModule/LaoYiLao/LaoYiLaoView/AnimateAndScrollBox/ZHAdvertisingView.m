//
//  ZHAdvertisingView.m
//  LaoYiLao
//
//  Created by wzh on 16/1/7.
//  Copyright © 2016年 sunsu. All rights reserved.
//

#import "ZHAdvertisingView.h"
#define TitleViewX 0
#define TitleViewY 0
#define TitleViewW kkViewWidth
#define TitleViewH 35
@implementation ZHAdvertisingView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageView.image = [UIImage imageNamed:@"bth"];
        [self addSubview:imageView];
        
        _titleView = [[ZHTitleView alloc]initWithFrame:CGRectMake(TitleViewX, TitleViewY, TitleViewW, TitleViewH)];
        _titleView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
        _titleView.backgroundColor = [UIColor clearColor];
        _titleView.contentlab.text = [NSString stringWithFormat:@"特约赞助伙伴"];
        [self addSubview:_titleView];
        
        _advertisingItemView = [[ZHAdvertisingItemView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), self.frame.size.width, self.frame.size.height - TitleViewH)];
//        _advertisingItemView.backgroundColor = [
//        _advertisingItemView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bth"]];
        [self addSubview:_advertisingItemView];
        
    }
    return self;
}
//- (void)createItems:(NSArray *)items{
//    [_advertisingItemView createItems:items];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
