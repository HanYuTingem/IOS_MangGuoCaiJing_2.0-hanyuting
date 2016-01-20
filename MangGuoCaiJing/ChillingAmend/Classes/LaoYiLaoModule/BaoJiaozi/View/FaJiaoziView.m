//
//  FaJiaoziView.m
//  LaoYiLao
//
//  Created by sunsu on 15/12/15.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "FaJiaoziView.h"
@interface FaJiaoziView()
{
    UIImageView  * _backImgView;
    UIButton     * _faJiaoziBtn;
}
@end

@implementation FaJiaoziView

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        _backImgView = [[UIImageView alloc]init];
        _faJiaoziBtn = [[UIButton alloc]init];
        
        [self addSubview:_backImgView];
        [_backImgView addSubview:_faJiaoziBtn];
        
        [self showUI];
        self.userInteractionEnabled = YES;
    }
    return self;
}


-(void)showUI{
    _backImgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _backImgView.image = [UIImage imageNamed:@"ljh_baohaola_image"];
    _backImgView.userInteractionEnabled = YES;
    
    CGFloat btn_w = 200;
    CGFloat btn_h = 50;
    CGFloat btn_x = (self.frame.size.width - btn_w)/2;
    CGFloat btn_y = self.frame.size.height - btn_h- 44;
    _faJiaoziBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
    
    _faJiaoziBtn.backgroundColor = [UIColor colorWithRed:0.9922 green:0.7176 blue:0.1451 alpha:1.0];
    [_faJiaoziBtn setTitle:@"发饺子" forState:UIControlStateNormal];
    [_faJiaoziBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _faJiaoziBtn.layer.cornerRadius = 5;
    
    [_faJiaoziBtn addTarget:self action:@selector(faJiaoziBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

-(void)faJiaoziBtnClicked{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(faJiaozi)]) {
        [self.delegate faJiaozi];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
