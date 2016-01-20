//
//  NewNoDumpView.m
//  LaoYiLao
//
//  Created by sunsu on 15/12/9.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "NewNoDumpView.h"
#define JiaoziView_Y (160.0/2)
#define JiaoziView_X ((kkViewWidth-JiaoziView_W)/2)
#define JiaoziView_W (194.0/2)
#define JiaoziView_H (115.0/2)




@interface NewNoDumpView ()
{
    UIImageView * _jiaoziImgView1;
    UILabel * _textLabel;
}
@end

@implementation NewNoDumpView
- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
//        self.backgroundColor = [UIColor colorWithPatternImage:[LYLTools scaleImage:[UIImage imageNamed:@"lao_bg"] ToSize:CGSizeMake(kkViewWidth, self.frame.size.height)]];
        self.backgroundColor = RGBACOLOR(242, 242, 242, 1);
    }
    return self;
}

-(void)initUI{
    _jiaoziImgView1 = [[UIImageView alloc]init];
    [self addSubview:_jiaoziImgView1];
    
    _textLabel = [[UILabel alloc]init];
    [self addSubview:_textLabel];
    
    [self createNoDumplingView];
}

- (void) createNoDumplingView{
//    CGRect infoFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    self.frame = infoFrame;
    
    CGRect jiaoziFrame = CGRectMake(JiaoziView_X,JiaoziView_Y, JiaoziView_W, JiaoziView_H);
    _jiaoziImgView1.frame = jiaoziFrame;

    _textLabel.frame = CGRectMake(0, CGRectGetMaxY(_jiaoziImgView1.frame)+17, kkViewWidth, 30);
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = UIFont30;
    _textLabel.textColor = RGBACOLOR(130, 0, 0, 1);
//    _textLabel.textColor = [UIColor yellowColor];
    
}


-(void)showViewWithType:(NSString *)noType{
    _jiaoziImgView1.image = [UIImage imageNamed:@"4_expression"];
    if ([noType isEqualToString:NoTypeJiaozi]) {
        
        _textLabel.text = @"还没有捞到饺子哎~";
    }else if ([noType isEqualToString:NoTypeCounpon]){
//        _jiaoziImgView1.image = [UIImage imageNamed:@"4_expression"];
        _textLabel.text = @"还没有捞到优惠券哎~";
    }else if([noType isEqualToString:NoTypeGreetCard]){
//        _jiaoziImgView1.image = [UIImage imageNamed:@"4_expression"];
        _textLabel.text = @"还没有捞到神秘贺卡哎~";
    }else if ([noType isEqualToString:NoTypeBaoJiaozi]){
//        _jiaoziImgView1.image = [UIImage imageNamed:@"4_expression"];
        _textLabel.text = @"还没有包饺子哎~";
    }else if ([noType isEqualToString:NoTypeBaoHeka]){
        _textLabel.text = @"还没有包贺卡哎~";
    }
}

@end
