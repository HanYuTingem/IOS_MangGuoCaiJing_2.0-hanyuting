//
//  LJHTanChuNeiView.m
//  LaoYiLao
//
//  Created by liujinhe on 15/12/17.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "LJHTanChuNeiView.h"
#define WideMidel           31.5 //图片宽
#define WIDEMIde_X          frame.size.width/2-WideMidel/2
#define TOUBUJIA_Rang       16
#define RES_AJIAN_EG        15
#define REqeueCde           WideMidel+TOUBUJIA_Rang+RES_AJIAN_EG
#define BUTTONWHITH         80
#define BUTTonHIGHt         30
@implementation LJHTanChuNeiView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self makeUI:frame];
    }
    return self;
}
- (void)makeUI:(CGRect)frame{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5;
    _biaoTiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDEMIde_X,TOUBUJIA_Rang, WideMidel, WideMidel)];
    _biaoTiImageView.image = [UIImage imageNamed:@"ljh_iconfont-gantanhao.png"];
    [self addSubview:_biaoTiImageView];
    _biaoTiMiddleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, REqeueCde, frame.size.width - 20, 50)];
    _biaoTiMiddleLabel.textAlignment = NSTextAlignmentCenter;
    _biaoTiMiddleLabel.text = @"饺子已经包好了,不发送给朋友么?";
    _biaoTiMiddleLabel.numberOfLines = 0;
    [self addSubview:_biaoTiMiddleLabel];
    CGFloat wighWiGH = frame.size.width;
    CGFloat wighHiGH = frame.size.height;
    //取消
    _buFatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _buFatButton.frame = CGRectMake(wighWiGH/2-10-BUTTONWHITH, wighHiGH-BUTTonHIGHt-10, BUTTONWHITH, BUTTonHIGHt);
    _buFatButton.layer.borderWidth = 1;
    _buFatButton.tag = 1020;
    _buFatButton.layer.borderColor = [[UIColor redColor]CGColor];
    _buFatButton.layer.cornerRadius = 5;
   
    _buFatButton.backgroundColor = [UIColor whiteColor];
    [_buFatButton setTitle:@"不发" forState:UIControlStateNormal];
        [_buFatButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_buFatButton addTarget:self action:@selector(bufadeButtong:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_buFatButton];
    //发送
    _faJiaoZiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _faJiaoZiButton.backgroundColor = [UIColor redColor];
    _faJiaoZiButton.frame = CGRectMake(wighWiGH/2+10, wighHiGH-BUTTonHIGHt-10, BUTTONWHITH, BUTTonHIGHt);
    _faJiaoZiButton.tag = 1021;
    _faJiaoZiButton.layer.cornerRadius = 5;
    [_faJiaoZiButton setTitle:@"发饺子" forState:UIControlStateNormal];
    [_faJiaoZiButton setTintColor:[UIColor whiteColor]];
    [_faJiaoZiButton addTarget:self action:@selector(bufadeButtong:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_faJiaoZiButton];
    
    
}
- (void)bufadeButtong:(UIButton*)button{
    if (button.tag == 1020) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(buFaSong)]) {
            [self.delegate buFaSong];
        }
        
    }else{
        if (self.delegate&& [self.delegate respondsToSelector:@selector(faSongEwss)]) {
            [self.delegate faSongEwss];
        }
    
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

}
@end
