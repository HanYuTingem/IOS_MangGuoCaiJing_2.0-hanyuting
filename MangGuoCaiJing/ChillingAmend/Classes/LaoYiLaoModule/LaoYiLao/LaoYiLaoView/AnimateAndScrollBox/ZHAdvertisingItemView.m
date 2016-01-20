//
//  ZHAdvertisingItemView.m
//  LaoYiLao
//
//  Created by wzh on 16/1/7.
//  Copyright © 2016年 sunsu. All rights reserved.
//

#import "ZHAdvertisingItemView.h"
#import "LYLAdvertisingResultModel.h"
@implementation ZHAdvertisingItemView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){

    }
    return self;
}
- (void)createItems:(NSArray *)items{
    for (int  i = 0; i < items.count; i ++ ) {
        if(i > 14)
            break;
        int xCount = 3;
        int yCount = 5;
        CGFloat xh = i % xCount;
        CGFloat ys = i / xCount;
        CGFloat topMid = 30 / 2 * KPercenY;
        CGFloat bottomMid = 50 / 2 * KPercenY;
        CGFloat leftMid = 88 / 2 * KPercenX;
        CGFloat rightMid = leftMid;
        CGFloat leftAndRightMid = 8 / 2 * KPercenX;
        CGFloat topAndBottomMid = 16 / 2 * KPercenY;
        CGFloat btnW = (self.frame.size.width - (leftMid + rightMid + leftAndRightMid * (xCount -1))) / xCount;
        CGFloat btnH = (self.frame.size.height - (topMid + bottomMid + topAndBottomMid * (yCount - 1))) / yCount;
        CGFloat btnX = leftMid + (btnW + leftAndRightMid) * xh;
        CGFloat btnY = topMid + (btnH + topAndBottomMid) * ys;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        button.frame = CGRectMake(btnX, btnY, btnW, btnH);
        button.tag = i;
//        [button setTitle:[NSString stringWithFormat:@"%ld",(long)button.tag] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        LYLAdvertisingResultModel *model = items[i];
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:model.advpic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"img_default"]];
        [self addSubview:button];
        
    }
}

- (void)buttonClicked:(UIButton *)button{
    ZHLog(@"%d",(int)button.tag);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
