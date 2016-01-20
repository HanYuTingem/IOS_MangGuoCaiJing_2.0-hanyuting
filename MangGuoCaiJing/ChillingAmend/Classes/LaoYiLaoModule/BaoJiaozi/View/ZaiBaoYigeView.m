//
//  ZaiBaoYigeView.m
//  LaoYiLao
//
//  Created by sunsu on 15/12/15.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "ZaiBaoYigeView.h"
@interface ZaiBaoYigeView()
{
    UIImageView  * _backImgView;
    UIButton     * _zaibaoBtn;
    UIButton     * _shareBtn;
}
@end

@implementation ZaiBaoYigeView

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        _backImgView = [[UIImageView alloc]init];
        _zaibaoBtn = [[UIButton alloc]init];
        _shareBtn = [[UIButton alloc]init];
        
        [self addSubview:_backImgView];
        [_backImgView addSubview:_zaibaoBtn];
        [_backImgView addSubview:_shareBtn];
        
        [self showUI];
        self.userInteractionEnabled = YES;
    }
    return self;
}


-(void)showUI{
    _backImgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _backImgView.image = [UIImage imageNamed:@"ljh_baoheka_bg_img.png"];
    _backImgView.userInteractionEnabled = YES;

    CGFloat space = 15;
    CGFloat btn_w = 100;
    CGFloat btn_h = 40;
    CGFloat btn_x = (self.frame.size.width-2*btn_w-space)/2;
    CGFloat btn_y = self.frame.size.height - btn_h - 100;
    
    _zaibaoBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
    _shareBtn.frame = CGRectMake(btn_x+space+btn_w, btn_y, btn_w, btn_h);
    
    
    [_zaibaoBtn setBackgroundColor:[UIColor clearColor]];
    [_zaibaoBtn setTitle:@"再去包一个" forState:UIControlStateNormal];
    [_zaibaoBtn setTitleColor:[UIColor colorWithRed:0.9922 green:0.7176 blue:0.1451 alpha:1.0] forState:UIControlStateNormal];
    _zaibaoBtn.layer.cornerRadius = 10;
    _zaibaoBtn.layer.borderColor = [UIColor colorWithRed:0.9922 green:0.7176 blue:0.1451 alpha:1.0].CGColor;
    _zaibaoBtn.layer.borderWidth = 1.0;
    
    [_shareBtn setBackgroundColor:[UIColor colorWithRed:0.9922 green:0.7176 blue:0.1451 alpha:1.0]];
    [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [_shareBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _shareBtn.layer.cornerRadius = 10;
    
    
    
    
    [_zaibaoBtn addTarget:self action:@selector(zaibaoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
}



-(void)zaibaoBtnClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZaiBaoYige)]) {
        [self.delegate ZaiBaoYige];
    }
}


-(void)shareBtnClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ShareBaoJiaozi)]) {
        [self.delegate ShareBaoJiaozi];
    }
}
@end
