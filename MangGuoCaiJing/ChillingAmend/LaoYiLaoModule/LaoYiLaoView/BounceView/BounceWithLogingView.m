//
//  BounceWithLogingView.m
//  LaoYiLao
//
//  Created by wzh on 15/11/11.
//  Copyright (c) 2015年 sunsu. All rights reserved.
//

#import "BounceWithLogingView.h"
#import "mineWalletViewController.h"
#import "LaoYiLaoViewController.h"
#import "GetShareInfoModel.h"

//当前视图的Frame
#define BounceWithLogingViewX 21 * KPercenX
#define BounceWithLogingViewY 98 * KPercenY
#define BounceWithLogingViewW kkViewWidth - 2 * BounceWithLogingViewX
#define BounceWithLogingViewH 275 * KPercenY

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
@implementation BounceWithLogingView

- (id)init{
    if(self = [super init]){
        self.frame  = CGRectMake(BounceWithLogingViewX, BounceWithLogingViewY, BounceWithLogingViewW, BounceWithLogingViewH);
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
    CGFloat totalMoney = [LYLTools todayTotalMoneyWithPath:DumplingInforLogingPath];

    if(number == 0){//没有次数
        if(totalMoney > 0){//有钱或劵
            
            [inforView.goToGetMoneyOrShareBtn setTitle:@"马上分享" forState:UIControlStateNormal];
            inforView.goToGetMoneyOrShareBtn.tag = ButtonTagWithGoToShareType;
            [inforView.continueToMakeBtn setTitle:@"查看我的钱包" forState:UIControlStateNormal];
            inforView.continueToMakeBtn.tag = ButtonTagWithCheckTheBalanceType;
        }else{//没钱没卷
            
            inforView.goToGetMoneyOrShareBtn.hidden = YES;
            [inforView.continueToMakeBtn setTitle:@"明天再捞" forState:UIControlStateNormal];
            inforView.continueToMakeBtn.tag = ButtonTagWithTomorrowAgainScoopType;
            [inforView.continueToMakeBtn setBackgroundImage:[UIImage imageNamed:@"7_button"] forState:UIControlStateNormal];
            inforView.continueToMakeBtn.center = CGPointMake(inforView.frame.size.width / 2, inforView.continueToMakeBtn.center.y);

        }
    }else if (number > 0){//有次数
        if(totalMoney > 0){//有钱或劵
            
            [inforView.goToGetMoneyOrShareBtn setTitle:@"马上分享" forState:UIControlStateNormal];
            inforView.goToGetMoneyOrShareBtn.tag = ButtonTagWithGoToShareType;
            [inforView.continueToMakeBtn setTitle:@"继续捞" forState:UIControlStateNormal];
            inforView.continueToMakeBtn.tag = ButtonTagWithContinueToMakeType;
            
        }else{//没钱没卷
            inforView.goToGetMoneyOrShareBtn.hidden = YES;
            [inforView.continueToMakeBtn setTitle:@"继续捞" forState:UIControlStateNormal];
            inforView.continueToMakeBtn.tag = ButtonTagWithContinueToMakeType;
            [inforView.continueToMakeBtn setBackgroundImage:[UIImage imageNamed:@"7_button"] forState:UIControlStateNormal];
            inforView.continueToMakeBtn.center = CGPointMake(inforView.frame.size.width / 2, inforView.continueToMakeBtn.center.y);
        
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
