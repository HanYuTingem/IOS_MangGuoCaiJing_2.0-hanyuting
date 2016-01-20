//
//  BounceWithNoLogingView.m
//  LaoYiLao
//
//  Created by wzh on 15/11/11.
//  Copyright (c) 2015年 sunsu. All rights reserved.
//

#import "BounceWithNoLogingView.h"
#import "LYLQuickLoginViewController.h"
//当前视图的Frame
#define BounceWithNoLogingViewX 21 * KPercenX
#define BounceWithNoLogingViewY 98 * KPercenY
#define BounceWithNoLogingViewW kkViewWidth - 2 * BounceWithNoLogingViewX
#define BounceWithNoLogingViewH 275 * KPercenY


//去领钱，去分享 ，继续捞btn宽高
#define BtnW 90 * KPercenX
#define BtnH 30 * KPercenY
#define BtnY self.frame.size.height -  85 * KPercenY
//去领钱，去分享x
#define GoToGetMoneyOrShareBtnX 30 * KPercenX
//继续捞的x 有次数
#define ContinueToMakeBtnX  self.frame.size.width - CGRectGetMaxX(_goToGetMoneyOrShareBtn.frame)

//无次数
#define ContinueToMakeNullNumberBtnW BtnW * 2
//#define ContentCenterY [BounceDumplingInforView shareBounceDumplingInforView].frame.size.height / 2

@implementation BounceWithNoLogingView


- (id)init{
    if(self = [super init]){
        self.frame  = CGRectMake(BounceWithNoLogingViewX, BounceWithNoLogingViewY, BounceWithNoLogingViewW, BounceWithNoLogingViewH);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        [self addSubview:[BounceDumplingInforView shareBounceDumplingInforView]];
    }
    return self;
}
- (void)setModel:(DumplingInforModel *)model{
    _model = model;
    BounceDumplingInforView *inforView = [BounceDumplingInforView shareBounceDumplingInforView];
    [inforView refreshDataWithModel:_model];
    int number = [_model.resultListModel.userHasNum intValue];//剩余次数
    CGFloat totalMoney = [LYLTools todayTotalMoneyWithPath:DumplingInforNoLogingPath];

    if(number == 0){//没有次数
        if(totalMoney > 0){//有钱或劵
            inforView.continueToMakeBtn.hidden = YES;
            inforView.goToGetMoneyOrShareBtn.tag = ButtonTagWithGotoGetMoneyType;
            [inforView.goToGetMoneyOrShareBtn setTitle:@"去领取" forState:UIControlStateNormal];
            [inforView.goToGetMoneyOrShareBtn setBackgroundImage:[UIImage imageNamed:@"7_button"] forState:UIControlStateNormal];
            inforView.goToGetMoneyOrShareBtn.center = CGPointMake(inforView.frame.size.width / 2, inforView.continueToMakeBtn.center.y);
            
        }else{//没钱没卷
            inforView.continueToMakeBtn.hidden = YES;
            [inforView.goToGetMoneyOrShareBtn setTitle:@"登陆继续捞" forState:UIControlStateNormal];
            inforView.goToGetMoneyOrShareBtn.tag = ButtonTagWithGoToLoginType;
            [inforView.goToGetMoneyOrShareBtn setBackgroundImage:[UIImage imageNamed:@"7_button"] forState:UIControlStateNormal];
            inforView.goToGetMoneyOrShareBtn.center = CGPointMake(inforView.frame.size.width / 2, inforView.continueToMakeBtn.center.y);
        }
    }else if (number > 0){//有次数
        if(totalMoney > 0){//有钱或劵
           
            [inforView.goToGetMoneyOrShareBtn setTitle:@"去领取" forState:UIControlStateNormal];
            inforView.goToGetMoneyOrShareBtn.tag = ButtonTagWithGotoGetMoneyType;
            [inforView.continueToMakeBtn setTitle:@"继续捞" forState:UIControlStateNormal];
            inforView.continueToMakeBtn.tag = ButtonTagWithContinueToMakeType;

            
        }else{//没钱没卷
            inforView.continueToMakeBtn.hidden = YES;
            [inforView.goToGetMoneyOrShareBtn setTitle:@"继续捞" forState:UIControlStateNormal];
            inforView.goToGetMoneyOrShareBtn.tag = ButtonTagWithContinueToMakeType;
            [inforView.goToGetMoneyOrShareBtn setBackgroundImage:[UIImage imageNamed:@"7_button"] forState:UIControlStateNormal];
            inforView.goToGetMoneyOrShareBtn.center = CGPointMake(inforView.frame.size.width / 2, inforView.goToGetMoneyOrShareBtn.center.y);
        }
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
