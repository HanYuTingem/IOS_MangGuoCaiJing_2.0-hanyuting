//
//  BounceSharedCeilingView.m
//  LaoYiLao
//
//  Created by wzh on 15/11/2.
//  Copyright (c) 2015年 sunsu. All rights reserved.
//

#import "BounceSharedCeilingView.h"

#define BounceSharedCeilingViewX 20 * KPercenX
#define BounceSharedCeilingViewY 170 * KPercenY
#define BounceSharedCeilingViewW kkViewWidth - 2 * BounceSharedCeilingViewX
#define BounceSharedCeilingViewH 155 * KPercenY


//关闭按钮
#define ShutDowbBtnX self.frame.size.width - ShutDowbBtnW - ShutDowbBtnY
#define ShutDowbBtnY 5
#define ShutDowbBtnW 45 / 2 * KPercenY
#define ShutDowbBtnH 45 / 2 * KPercenY

//饺子按钮Frame
#define DumpingBtnX  0 //无所谓设置中心点
#define DumpingBtnY  13 * KPercenY
#define DumpingBtnW  55 * KPercenX
#define DumpingBtnH  33 * KPercenY

//titleFrame
#define TitleLabX 0 //无所谓设置中心点
#define TitleLabY CGRectGetMaxY(_dumpingBtn.frame) + 13 * KPercenY
#define TitleLabW 200 * KPercenX
#define TitleLabH 15 * KPercenY

//明天再捞frame
#define TomorrowAgainScoopBtnX 0 //无所谓设置中心
#define TomorrowAgainScoopBtnY CGRectGetMaxY(_titleLab.frame) + 20 * KPercenY
#define TomorrowAgainScoopBtnW 90 * KPercenX
#define TomorrowAgainScoopBtnH 30 * KPercenY


@implementation BounceSharedCeilingView{
    UIButton *_btn;
}



static BounceSharedCeilingView *bounceSharedCeilingView;
+ (BounceSharedCeilingView *)shareBounceSharedCeilingView{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        bounceSharedCeilingView = [[BounceSharedCeilingView alloc]init];
    });
    return bounceSharedCeilingView;
}
- (id)init{
    if(self = [super init]){
        self.frame  = CGRectMake(BounceSharedCeilingViewX, BounceSharedCeilingViewY, BounceSharedCeilingViewW, BounceSharedCeilingViewH);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        [self createUI];
    }
    return self;
}

- (void)createUI{
//    UIButton *shutDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [shutDownBtn setFrame:CGRectMake(ShutDowbBtnX, ShutDowbBtnY, ShutDowbBtnW, ShutDowbBtnH)];
//    [shutDownBtn setBackgroundImage:[UIImage imageNamed:@"9_shut_down"] forState:UIControlStateNormal];
//    [shutDownBtn addTarget:self action:@selector(shutDownBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:shutDownBtn];
    
    _dumpingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_dumpingBtn setBackgroundImage:[UIImage imageNamed:@"4_expression"] forState:UIControlStateNormal];
    [_dumpingBtn setFrame:CGRectMake(DumpingBtnX, DumpingBtnY, DumpingBtnW, DumpingBtnH)];
    _dumpingBtn.center = CGPointMake(self.frame.size.width / 2, _dumpingBtn.center.y);
    [self addSubview:_dumpingBtn];
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(TitleLabX, TitleLabY, TitleLabW, TitleLabH)];
    _titleLab.textAlignment = NSTextAlignmentCenter;
//    _titleLab.backgroundColor = [UIColor brownColor];
    _titleLab.center = CGPointMake(self.frame.size.width / 2, _titleLab.center.y);
    _titleLab.font = UIFont24;
    [self addSubview:_titleLab];
    
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.titleLabel.font = UIFontBild30;
    [_btn setFrame:CGRectMake(TomorrowAgainScoopBtnX, TomorrowAgainScoopBtnY, TomorrowAgainScoopBtnW, TomorrowAgainScoopBtnH)];
    [_btn setTitle:@"明天再捞" forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btn.center = CGPointMake(self.frame.size.width / 2, _btn.center.y);
    [_btn setBackgroundImage:[UIImage imageNamed:@"9_button_b"] forState:UIControlStateNormal];
    [self addSubview:_btn];

}

#pragma mark -- 去关闭点击
- (void)shutDownBtnClicked:(UIButton *)button{
//    [self.superview removeFromSuperview];
    [LYLTools removeBounceViewWithVC:_viewController];

    ZHLog(@"关闭");
    
}

#pragma mark -- 明天再捞点击
- (void)btnClicked:(UIButton *)button{
    [LYLTools removeBounceViewWithVC:_viewController];
    ZHLog(@"明天再捞");
}

- (void)setType:(NSString *)type{
    _type = type;
    if([type isEqualToString:@"1"]){
        [_btn setTitle:@"明天再捞" forState:UIControlStateNormal];
        _titleLab.text = @"表太贪心啦，今天机会已经用完啦~";

    }else if ([type isEqualToString:@"2"]){
        [_btn setTitle:@"知道啦" forState:UIControlStateNormal];
        _titleLab.text = @"挤爆了,过会再来~";
    }else if ([type isEqualToString:@"3"]){
        [_btn setTitle:@"再来一次" forState:UIControlStateNormal];
        _titleLab.text = @"网络太慢啦~";
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
