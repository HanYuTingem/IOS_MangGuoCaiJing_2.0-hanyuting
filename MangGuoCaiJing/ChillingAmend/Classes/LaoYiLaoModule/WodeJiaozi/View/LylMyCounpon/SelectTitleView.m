//
//  SelectTitleView.m
//  LaoYiLao
//
//  Created by sunsu on 15/12/17.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "SelectTitleView.h"
#define AnimateDuration 0.3

@implementation SelectTitleView{
    int _currentIndex;
    UIView *_backView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
//        self.layer.borderColor = [UIColor redColor].CGColor;
//        self.layer.borderWidth = 1;
        _defaultIndex = 0;
    }
    return  self;
}

- (void)createItem:(NSArray *)itemsArray{
    _itemsArray = itemsArray;
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/itemsArray.count, self.frame.size.height)];
    _backView.backgroundColor = [UIColor clearColor];//RGBACOLOR(242, 242, 242, 1);//[UIColor whiteColor];
    [self addSubview:_backView];
    for (int i = 0;  i < itemsArray.count; i++ ) {
        
        
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        itemBtn.frame = CGRectMake(i * self.frame.size.width/itemsArray.count, 0, self.frame.size.width/itemsArray.count, self.frame.size.height);
        itemBtn.titleLabel.font = UIFont28;
        [itemBtn setTitle:itemsArray[i] forState:UIControlStateNormal];
        [itemBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        //        [itemBtn addTarget:self action:@selector(buttonDragInside:event:) forControlEvents:UIControlEventTouchDragInside];
        //        [itemBtn addTarget:self action:@selector(buttonDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        
        itemBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        itemBtn.tag = i;
        if(itemBtn.tag == _defaultIndex){
            itemBtn.selected = YES;
        }
        [itemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [itemBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        
        [itemBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        [self addSubview:itemBtn];
        
        
        if(i != 0){
            CGFloat y = 6;
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/itemsArray.count  * i , y, 1, self.frame.size.height-2*y)];
            lineView.backgroundColor = RGBACOLOR(217, 217, 217, 1);//[UIColor lightGrayColor];
            [self addSubview:lineView];
        }
    }
    CGRect lineLabelFrame = CGRectMake(0, CGRectGetMaxY(_backView.frame)-1,self.frame.size.width, 1);
    UILabel  * lineLabel = [[UILabel alloc]initWithFrame:lineLabelFrame];
    lineLabel.backgroundColor = RGBACOLOR(223, 223, 223, 1);//[UIColor redColor];
    [_backView addSubview:lineLabel];
    
    
}

- (void)buttonClicked:(UIButton *)button{
    [self rollingBackViewWithIndex:(int)button.tag];
}

//- (void)buttonDragInside:(UIButton *)button event:(UIEvent *)event{
//    UITouch *touch = [[event allTouches] anyObject];
//    //获取当前点
//    CGPoint point = [touch locationInView:self];
//    //获取前一点
//    CGPoint prePoint = [touch previousLocationInView:self];
////    ZHLog(@"%2")
//    ZHLog(@"buttonDragInside");
//}
//- (void)buttonDragEnter:(UIButton *)button{
//    ZHLog(@"buttonDragEnter");
//
//}
- (void)rollingBackViewWithIndex:(int)selectIndex{
    [self selectIndex:selectIndex];
    
//    [UIView animateWithDuration:AnimateDuration animations:^{
//        _backView.frame = CGRectMake(self.frame.size.width / _itemsArray.count * selectIndex, _backView.frame.origin.y, _backView.frame.size.width, _backView.frame.size.height);
//        self.userInteractionEnabled = NO;
//        
//    } completion:^(BOOL finished) {
//        self.selectIndexWithBlock(selectIndex);
//        self.userInteractionEnabled = YES;
//    }];
}

- (void)selectIndex:(int)selectIndex{
    for (UIView *subView in self.subviews) {
        if([subView isKindOfClass:[UIButton class]]){
            ((UIButton *)subView).selected = NO;
            if(selectIndex == ((UIButton *)subView).tag){
                ((UIButton *)subView).selected = YES;
            }
        }
    }
}

- (void)setDefaultIndex:(int)defaultIndex{
    _defaultIndex = defaultIndex;    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
