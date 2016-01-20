//
//  BaoheLweView.m
//  LaoYiLao
//
//  Created by liujinhe on 16/1/14.
//  Copyright © 2016年 sunsu. All rights reserved.
//

#import "BaoheLweView.h"
#define DingBu_HigrtY      12//照片起点
#define DingBu_WithtX      10
#define DingBu_Witht_li    kkViewWidth-2*DingBu_WithtX
#define DingBu_Higrt_li    0.83*DingBu_Witht_li
#define ZHonBu_Higrt_X     20
#define ZHonBu_Higrt_H     70 //字体高度
#define XianBU_Higrt_X     30
#define XianBU_Higrt_H     50
#define Jiange_Higrt_G     10
@implementation BaoheLweView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self makeUI:frame];
        
    }
    return self;
}
- (void)makeUI:(CGRect)frame{
    CGRect imageTest = CGRectMake(DingBu_WithtX, DingBu_HigrtY, DingBu_Witht_li, DingBu_Higrt_li);
    _iWmageView = [[UIImageView alloc] initWithFrame:imageTest];
    _iWmageView.image = [UIImage imageNamed:@"ljh_baoheka_bgdefault.png"];
    _iWmageView.userInteractionEnabled = YES;
    _iWmageView.backgroundColor = [UIColor blueColor];
    [self addSubview:_iWmageView];
    CGRect preLTest = CGRectMake(ZHonBu_Higrt_X, CGRectGetMaxY(imageTest)+Jiange_Higrt_G, kkViewWidth - 2*ZHonBu_Higrt_X, 50);
    _preFrecrLabel = [[UILabel alloc] initWithFrame:preLTest];
    _preFrecrLabel.textColor = [UIColor whiteColor];
    _preFrecrLabel.font = UIFont30;
  //  _preFrecrLabel.backgroundColor = [UIColor yellowColor];
    _preFrecrLabel.numberOfLines = 0;
    _preFrecrLabel.text = @"愿一切最美好的祝福都能用这张贺卡表达,真诚地祝你幸福.快乐.成功";
    [self addSubview:_preFrecrLabel];
    CGRect sendLTest = CGRectMake(XianBU_Higrt_X,frame.size.height-(frame.size.height-CGRectGetMaxY(preLTest))/2-10, kkViewWidth - 2*XianBU_Higrt_X, 50);
    _sendColede = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendColede.frame = sendLTest;
    _sendColede.backgroundColor = [UIColor colorWithRed:0.9922 green:0.7176 blue:0.1451 alpha:1.0];
    _sendColede.layer.cornerRadius = 4;
    [_sendColede addTarget:self action:@selector(butooClode:) forControlEvents:UIControlEventTouchUpInside];
    [_sendColede setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sendColede setTitle:@"发贺卡" forState:UIControlStateNormal];
    [self addSubview:_sendColede];

}

-(void)setModel:(WobaoCardResultModel *)model{
    _model  =  model;
    [_iWmageView sd_setImageWithURL:[NSURL URLWithString:_model.cardPic] placeholderImage:[UIImage imageNamed:@"ljh_baoheka_bgdefault.png"]];
    
    _preFrecrLabel.text = _model.cardWish;
}



- (void)butooClode:(UIButton*)button{
    _buttonClicBook(button);
}
@end
