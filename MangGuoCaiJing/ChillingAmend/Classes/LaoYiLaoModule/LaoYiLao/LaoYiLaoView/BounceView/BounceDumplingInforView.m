//
//  BounceDumplingInforView.m
//  LaoYiLao
//
//  Created by wzh on 15/11/11.
//  Copyright (c) 2015年 sunsu. All rights reserved.
//

#import "BounceDumplingInforView.h"
#import "LYLQuickLoginViewController.h"
#import "mineWalletViewController.h"
#import "ShareInfoManage.h"


//当前视图的Frame
#define BounceDumplingInforViewX 0
#define BounceDumplingInforViewY 0
#define BounceDumplingInforViewW kkViewWidth
#define BounceDumplingInforViewH kkViewHeight

//iconBtnFrame
#define IconBtnX 0 //无所谓居中了
#define IconBtnY 70 * KPercenY
#define IconBtnW 70 * KPercenX
#define IconBtnH IconBtnW

#define ShutDowbBtnX 270 * KPercenX
#define ShutDowbBtnY 35 * KPercenY
#define ShutDowbBtnW 25 * KPercenY
#define ShutDowbBtnH ShutDowbBtnW

//titleBtnFrame
#define TitleLabX 0 //无所谓居中了
#define TitleLabY CGRectGetMaxY(bounceDumplingInforView.iconBtn.frame) + 20 * KPercenY
#define TitleLabW 250 * KPercenX
#define TitleLabH 15 * KPercenY

//dumplingTypeView
#define DumplingTypeViewY CGRectGetMaxY(bounceDumplingInforView.titleLab.frame) + 20 * KPercenY

//contentLabFrame
#define ContentLabX 0 //无所谓居中了
#define ConTentLabY CGRectGetMaxY(bounceDumplingInforView.dumplingTypeView.frame) + 20 * KPercenY
#define ContentLabW 200
#define ContentLabH 15


//去领钱，去分享 ，继续捞btn宽高
#define BtnW 90 * KPercenX
#define BtnH 30 * KPercenY
#define BtnY bounceDumplingInforView.contentLab.hidden ? CGRectGetMaxY(bounceDumplingInforView.dumplingTypeView.frame) + 35 * KPercenY : CGRectGetMaxY(bounceDumplingInforView.contentLab.frame) + 35 * KPercenY
//去领钱，去分享x
#define GoToGetMoneyOrShareBtnX 40 * KPercenX
//继续捞的x 有次数
#define ContinueToMakeBtnX  BounceDumplingInforViewW - CGRectGetMaxX(bounceDumplingInforView.goToGetMoneyOrShareBtn.frame)
//无次数
#define ContinueToMakeNullNumberBtnW BtnW * 2

//remainingNumberLabFrme
#define RemainingNumberLabX 0//无所谓居中了
#define RemainingNumberLabY CGRectGetMaxY(bounceDumplingInforView.continueToMakeBtn.frame) + 20 * KPercenY
#define RemainingNumberLabW 200
#define RemainingNumberLabH 15

static BounceDumplingInforView *bounceDumplingInforView;

@implementation BounceDumplingInforView

+ (BounceDumplingInforView *)shareBounceDumplingInforView{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        
        bounceDumplingInforView = [[BounceDumplingInforView alloc]init];
        bounceDumplingInforView.layer.masksToBounds = YES;
        bounceDumplingInforView.layer.cornerRadius = 5;
        bounceDumplingInforView.frame = CGRectMake(BounceDumplingInforViewX, BounceDumplingInforViewY, BounceDumplingInforViewW, BounceDumplingInforViewH);
        //头像固定
        bounceDumplingInforView.iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bounceDumplingInforView.iconBtn.backgroundColor = [UIColor brownColor];
        bounceDumplingInforView.iconBtn.layer.cornerRadius = IconBtnW / 2;
        bounceDumplingInforView.iconBtn.layer.masksToBounds = YES;
        [bounceDumplingInforView.iconBtn setFrame:CGRectMake(IconBtnX, IconBtnY, IconBtnW, IconBtnH)];
        bounceDumplingInforView.iconBtn.center = CGPointMake(kkViewWidth / 2, bounceDumplingInforView.iconBtn.center.y);
        [bounceDumplingInforView addSubview:bounceDumplingInforView.iconBtn];
        
        //关闭按钮
        UIButton *shutDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shutDownBtn setFrame:CGRectMake(ShutDowbBtnX, ShutDowbBtnY, ShutDowbBtnW, ShutDowbBtnH)];
        [shutDownBtn setBackgroundImage:[UIImage imageNamed:@"laodaoqian_delete"] forState:UIControlStateNormal];
        [shutDownBtn addTarget:bounceDumplingInforView action:@selector(shutDownBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bounceDumplingInforView addSubview:shutDownBtn];
        
        
        //标题固定
        bounceDumplingInforView.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(TitleLabX, TitleLabY, TitleLabW, TitleLabH)];
        bounceDumplingInforView.titleLab.text = @"恭喜你捞到了一个饺子";
        bounceDumplingInforView.titleLab.textAlignment = NSTextAlignmentCenter;
        bounceDumplingInforView.titleLab.textColor = [UIColor whiteColor];
        //_titleLab.backgroundColor = [UIColor brownColor];
        bounceDumplingInforView.titleLab.font = UIFont26;
        bounceDumplingInforView.titleLab.center = CGPointMake(kkViewWidth / 2, bounceDumplingInforView.titleLab.center.y);
        [bounceDumplingInforView addSubview:bounceDumplingInforView.titleLab];

        
        
        bounceDumplingInforView.dumplingTypeView = [[ZHDumplingWithTypeView alloc]init];
        bounceDumplingInforView.dumplingTypeView.frame = CGRectMake(0, DumplingTypeViewY, kkViewWidth, 0);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:bounceDumplingInforView action:@selector(tap:)];
        [bounceDumplingInforView.dumplingTypeView addGestureRecognizer:tap];
        [bounceDumplingInforView addSubview:bounceDumplingInforView.dumplingTypeView];
        
        bounceDumplingInforView.contentLab = [[UILabel alloc]init ];
        bounceDumplingInforView.contentLab.text = [NSString stringWithFormat:@"今日共捞到%@,棒棒哒~",bounceDumplingInforView.contentLab.text];
        bounceDumplingInforView.contentLab.textAlignment = NSTextAlignmentCenter;
        bounceDumplingInforView.contentLab.textColor = [UIColor whiteColor];
        bounceDumplingInforView.contentLab.numberOfLines = 0;
        bounceDumplingInforView.contentLab.font = UIFont22;
//        bounceDumplingInforView.contentLab.backgroundColor = [UIColor brownColor];
        [bounceDumplingInforView addSubview:bounceDumplingInforView.contentLab];
        
        
        
        bounceDumplingInforView.goToGetMoneyOrShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bounceDumplingInforView.goToGetMoneyOrShareBtn.titleLabel.font = UIFontBild30;
        [bounceDumplingInforView.goToGetMoneyOrShareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bounceDumplingInforView.goToGetMoneyOrShareBtn addTarget:bounceDumplingInforView action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bounceDumplingInforView addSubview:bounceDumplingInforView.goToGetMoneyOrShareBtn];
        
        
        bounceDumplingInforView.continueToMakeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bounceDumplingInforView.continueToMakeBtn.titleLabel.font = UIFontBild30;
        [bounceDumplingInforView.continueToMakeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bounceDumplingInforView.continueToMakeBtn addTarget:bounceDumplingInforView action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bounceDumplingInforView addSubview:bounceDumplingInforView.continueToMakeBtn];

        
        
        bounceDumplingInforView.remainingNumberLab = [[UILabel alloc]init];
        bounceDumplingInforView.remainingNumberLab.font = UIFont24;
        bounceDumplingInforView.remainingNumberLab.textColor = [UIColor whiteColor];
        bounceDumplingInforView.remainingNumberLab.text = [NSString stringWithFormat:@"还有%d次机会",1];
        bounceDumplingInforView.remainingNumberLab.textAlignment = NSTextAlignmentCenter;
        [bounceDumplingInforView addSubview:bounceDumplingInforView.remainingNumberLab];
    
        
        [LYLTools setViewWithBorder:bounceDumplingInforView.goToGetMoneyOrShareBtn cornerRadius:5 borderColor:[UIColor whiteColor] borderWidth:1];
        [LYLTools setViewWithBorder:bounceDumplingInforView.continueToMakeBtn  cornerRadius:5 borderColor:[UIColor whiteColor] borderWidth:1];

        
    });
    return bounceDumplingInforView;
}


- (void)refreshDataWithModel:(DumplingInforModel *)model{
    
//    model.resultListModel.dumplingModel.dumplingType = @"3";
//    model.resultListModel.dumplingModel.cardType = @"1";
//    model.resultListModel.dumplingModel.prizeInfo = @"恭喜发财，万事如医";
//    model.resultListModel.dumplingModel.prizeAmount = @"1.0021";

    
    //单利model赋值
    bounceDumplingInforView.model = model;
    
    //头像赋值
    if(IsStrWithNUll(model.resultListModel.dumplingModel.userImg)){
        [bounceDumplingInforView.iconBtn  setBackgroundImage:[UIImage imageNamed:@"9_default_avatar"] forState:UIControlStateNormal];
    }else{
        [bounceDumplingInforView.iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.resultListModel.dumplingModel.userImg] forState:UIControlStateNormal];
    }
    //标题赋值
    
    NSString *titleStr = [NSString stringWithFormat:@"%@ 给你包了一个饺子",model.resultListModel.dumplingModel.putUser];
    bounceDumplingInforView.titleLab.attributedText = [LYLTools attributeWithStr:titleStr rangeStr:model.resultListModel.dumplingModel.putUser rangColor:[UIColor yellowColor]];
    
    //饺子类型的赋值
    bounceDumplingInforView.dumplingTypeView.model = model;
    
    //设置内容提示语的显示
    bounceDumplingInforView.contentLab.text = [self returnContentLabText];
    //设置初始的位置及状态即默认状态
    [self setDefaultState];
    
    //设置btn改变的frame
    [self setDumplingInforViewBtnFrame];
    
    //剩余次数
    [self setRemainingNumberWithText];
}

#pragma mark -- 设置默认
- (void)setDefaultState{
    if([LYLTools boundingRectWithStrH:bounceDumplingInforView.contentLab.text labStrW:ContentLabW andFont:bounceDumplingInforView.contentLab.font] > ContentLabH){
        bounceDumplingInforView.contentLab.frame = CGRectMake(ContentLabX, ConTentLabY, ContentLabW, ContentLabH * 2);
    }else{
        bounceDumplingInforView.contentLab.frame = CGRectMake(ContentLabX, ConTentLabY, ContentLabW, ContentLabH);
    }
    bounceDumplingInforView.contentLab.center = CGPointMake(bounceDumplingInforView.frame.size.width / 2, bounceDumplingInforView.contentLab.center.y);
    
    [bounceDumplingInforView.goToGetMoneyOrShareBtn setFrame:CGRectMake(GoToGetMoneyOrShareBtnX, BtnY, BtnW, BtnH)];
    bounceDumplingInforView.goToGetMoneyOrShareBtn.hidden = NO;
    [bounceDumplingInforView.goToGetMoneyOrShareBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    [bounceDumplingInforView.continueToMakeBtn setFrame:CGRectMake(ContinueToMakeBtnX, BtnY, BtnW, BtnH)];
    [bounceDumplingInforView.continueToMakeBtn setTitle:@"取消" forState:UIControlStateNormal];
    bounceDumplingInforView.continueToMakeBtn.hidden = NO;
    
    bounceDumplingInforView.remainingNumberLab.frame = CGRectMake(RemainingNumberLabX, RemainingNumberLabY, RemainingNumberLabW, RemainingNumberLabH);
    bounceDumplingInforView.remainingNumberLab.center = CGPointMake(bounceDumplingInforView.frame.size.width / 2, bounceDumplingInforView.remainingNumberLab.center.y);
}


#pragma mark -- 内容的text
- (NSString *)returnContentLabText{
    CGFloat totalMoney;
    int couponCount;
    int greetingCardCount;
    if(LYLIsLoging){
        totalMoney = [[ZHDataBase sharedDataBase]selectLogingstateWithReturnTodayTotalMoney:@"1" andUserId:LYLUserId];
        couponCount = [[ZHDataBase sharedDataBase]selectLogingstateWithReturnTodayCouponCount:@"1" andUserId:LYLUserId];
        greetingCardCount = [[ZHDataBase sharedDataBase]selectLogingstateWithReturnTodayGreetingCardCount:@"1" andUserId:LYLUserId];
    }else{
        totalMoney = [[ZHDataBase sharedDataBase]selectLogingstateWithReturnTodayTotalMoney:@"0" andUserId:@""];
        couponCount = [[ZHDataBase sharedDataBase]selectLogingstateWithReturnTodayCouponCount:@"0" andUserId:@""];
        greetingCardCount = [[ZHDataBase sharedDataBase]selectLogingstateWithReturnTodayGreetingCardCount:@"0" andUserId:@""];
    }
    bounceDumplingInforView.totalMoney = totalMoney;
    bounceDumplingInforView.couponCount = couponCount;
    bounceDumplingInforView.greetingCardCount = greetingCardCount;
    
    
    bounceDumplingInforView.contentLab.hidden = NO;
    if(totalMoney == 0 && couponCount == 0 && greetingCardCount == 0){
        bounceDumplingInforView.contentLab.hidden = YES;
        return @"";
    }else if (totalMoney == 0 && couponCount == 0 && greetingCardCount > 0){
        return [NSString stringWithFormat:@"今日共捞到%d张贺卡,棒棒哒~",greetingCardCount];
    }else if (totalMoney == 0 && couponCount > 0 && greetingCardCount == 0){
        return [NSString stringWithFormat:@"今日共捞到%d张优惠劵,棒棒哒~",couponCount];
    }else if (totalMoney > 0 && couponCount == 0 && greetingCardCount == 0){
        return [NSString stringWithFormat:@"今日共捞到%.2f元,棒棒哒~",totalMoney];
    }else if (totalMoney == 0 && couponCount > 0 && greetingCardCount > 0){
        return [NSString stringWithFormat:@"今日共捞到%d张优惠劵,%d张贺卡,棒棒哒~",couponCount,greetingCardCount];
    }else if(totalMoney > 0 && couponCount == 0 && greetingCardCount > 0){
        return [NSString stringWithFormat:@"今日共捞到%.2f元,%d张贺卡,棒棒哒~",totalMoney,greetingCardCount];
    }else if (totalMoney > 0 && couponCount > 0 && greetingCardCount == 0){
        return [NSString stringWithFormat:@"今日共捞到%.2f元,%d张优惠劵,棒棒哒~",totalMoney,couponCount];
    }else if (totalMoney > 0 && couponCount > 0 && greetingCardCount > 0 ){
        return [NSString stringWithFormat:@"今日共捞到%.2f元,%d张优惠劵,%d张贺卡,棒棒哒~",totalMoney,couponCount,greetingCardCount];
    }else{
        bounceDumplingInforView.contentLab.hidden = YES;
        return @"";
    }
}

#pragma mark -- 设置btn 的frame
- (void)setDumplingInforViewBtnFrame{
    int number = [bounceDumplingInforView.model.resultListModel.userHasNum intValue];//剩余次数
    
    CGFloat totalMoney = bounceDumplingInforView.totalMoney;
    int couponCount = bounceDumplingInforView.couponCount;
    int greetingCardCount = bounceDumplingInforView.greetingCardCount;
    if(LYLIsLoging){
        if(number == 0){//没有次数
            if(totalMoney > 0 || couponCount > 0 || greetingCardCount > 0){//有钱或劵
                
                [bounceDumplingInforView.goToGetMoneyOrShareBtn setTitle:@"马上分享" forState:UIControlStateNormal];
                bounceDumplingInforView.goToGetMoneyOrShareBtn.tag = ButtonTagWithGoToShareType;
                [bounceDumplingInforView.continueToMakeBtn setTitle:@"查看我的钱包" forState:UIControlStateNormal];
                bounceDumplingInforView.continueToMakeBtn.tag = ButtonTagWithCheckTheBalanceType;
            }else{//没钱没卷
                
                bounceDumplingInforView.goToGetMoneyOrShareBtn.hidden = YES;
                [bounceDumplingInforView.continueToMakeBtn setTitle:@"明天再捞" forState:UIControlStateNormal];
                bounceDumplingInforView.continueToMakeBtn.tag = ButtonTagWithTomorrowAgainScoopType;
                //                [inforView.continueToMakeBtn setBackgroundImage:[UIImage imageNamed:@"7_button"] forState:UIControlStateNormal];
                bounceDumplingInforView.continueToMakeBtn.center = CGPointMake(bounceDumplingInforView.frame.size.width / 2, bounceDumplingInforView.continueToMakeBtn.center.y);
                
            }
        }else if (number > 0){//有次数
            if(totalMoney > 0 || couponCount > 0 || greetingCardCount > 0){//有钱或劵
                
                [bounceDumplingInforView.goToGetMoneyOrShareBtn setTitle:@"马上分享" forState:UIControlStateNormal];
                bounceDumplingInforView.goToGetMoneyOrShareBtn.tag = ButtonTagWithGoToShareType;
                [bounceDumplingInforView.continueToMakeBtn setTitle:@"继续捞" forState:UIControlStateNormal];
                bounceDumplingInforView.continueToMakeBtn.tag = ButtonTagWithContinueToMakeType;
                
            }else{//没钱没卷
                bounceDumplingInforView.goToGetMoneyOrShareBtn.hidden = YES;
                [bounceDumplingInforView.continueToMakeBtn setTitle:@"继续捞" forState:UIControlStateNormal];
                bounceDumplingInforView.continueToMakeBtn.tag = ButtonTagWithContinueToMakeType;
                //                [inforView.continueToMakeBtn setBackgroundImage:[UIImage imageNamed:@"7_button"] forState:UIControlStateNormal];
                bounceDumplingInforView.continueToMakeBtn.center = CGPointMake(bounceDumplingInforView.frame.size.width / 2, bounceDumplingInforView.continueToMakeBtn.center.y);
                
            }
        }
        
    }else{
        if(number == 0){//没有次数
            if(totalMoney > 0 || couponCount > 0 || greetingCardCount > 0){//有钱或劵
                bounceDumplingInforView.continueToMakeBtn.hidden = YES;
                bounceDumplingInforView.goToGetMoneyOrShareBtn.tag = ButtonTagWithGotoGetMoneyType;
                [bounceDumplingInforView.goToGetMoneyOrShareBtn setTitle:@"去领取" forState:UIControlStateNormal];
                //                [inforView.goToGetMoneyOrShareBtn setBackgroundImage:[UIImage imageNamed:@"7_button"] forState:UIControlStateNormal];
                bounceDumplingInforView.goToGetMoneyOrShareBtn.center = CGPointMake(bounceDumplingInforView.frame.size.width / 2, bounceDumplingInforView.continueToMakeBtn.center.y);
                
            }else{//没钱没卷
                bounceDumplingInforView.continueToMakeBtn.hidden = YES;
                [bounceDumplingInforView.goToGetMoneyOrShareBtn setTitle:@"登陆继续捞" forState:UIControlStateNormal];
                bounceDumplingInforView.goToGetMoneyOrShareBtn.tag = ButtonTagWithGoToLoginType;
                //                [inforView.goToGetMoneyOrShareBtn setBackgroundImage:[UIImage imageNamed:@"7_button"] forState:UIControlStateNormal];
                bounceDumplingInforView.goToGetMoneyOrShareBtn.center = CGPointMake(bounceDumplingInforView.frame.size.width / 2, bounceDumplingInforView.continueToMakeBtn.center.y);
            }
        }else if (number > 0){//有次数
            if(totalMoney > 0 || couponCount > 0 || greetingCardCount > 0){//有钱或劵或贺卡
                
                [bounceDumplingInforView.goToGetMoneyOrShareBtn setTitle:@"去领取" forState:UIControlStateNormal];
                bounceDumplingInforView.goToGetMoneyOrShareBtn.tag = ButtonTagWithGotoGetMoneyType;
                [bounceDumplingInforView.continueToMakeBtn setTitle:@"继续捞" forState:UIControlStateNormal];
                bounceDumplingInforView.continueToMakeBtn.tag = ButtonTagWithContinueToMakeType;
                
                
            }else{//没钱没卷
                bounceDumplingInforView.continueToMakeBtn.hidden = YES;
                [bounceDumplingInforView.goToGetMoneyOrShareBtn setTitle:@"继续捞" forState:UIControlStateNormal];
                bounceDumplingInforView.goToGetMoneyOrShareBtn.tag = ButtonTagWithContinueToMakeType;
                //                [inforView.goToGetMoneyOrShareBtn setBackgroundImage:[UIImage imageNamed:@"7_button"] forState:UIControlStateNormal];
                bounceDumplingInforView.goToGetMoneyOrShareBtn.center = CGPointMake(bounceDumplingInforView.frame.size.width / 2, bounceDumplingInforView.goToGetMoneyOrShareBtn.center.y);
            }
        }
        
    }
}

#pragma mark -- 设置剩余次数
- (void)setRemainingNumberWithText{
    DumplingInforModel *model = bounceDumplingInforView.model;
    int number = [model.resultListModel.userHasNum intValue];//剩余次数
    CGFloat totalMoney = bounceDumplingInforView.totalMoney;
    int couponCount = bounceDumplingInforView.couponCount;
    int greetingCardCount = bounceDumplingInforView.greetingCardCount;
    
    NSString *str = [NSString stringWithFormat:@"还有%@次机会",model.resultListModel.userHasNum];
    bounceDumplingInforView.remainingNumberLab.attributedText = [LYLTools attributeWithStr:str rangeStr:model.resultListModel.userHasNum rangColor:[UIColor yellowColor]];
    
    if(LYLIsLoging){//已登录
//        totalMoney = [[ZHDataBase sharedDataBase]selectLogingstateWithReturnTodayTotalMoney:@"1" andUserId:LYLUserId];
        if(number == 0){
            if(totalMoney > 0 || couponCount > 0 || greetingCardCount > 0){//有钱
                
                /**
                 *  分享是否增加次数，0 增加 1不增加
                 */
                if([model.resultListModel.isMarkShare isEqualToString:@"0"]){
                    bounceDumplingInforView.remainingNumberLab.attributedText = [LYLTools attributeWithStr:@"马上分享，再得 1 次机会" rangeStr:@"1" rangColor:[UIColor yellowColor]];
                }else if ([model.resultListModel.isMarkShare isEqualToString:@"1"]){
                    bounceDumplingInforView.remainingNumberLab.text = [NSString stringWithFormat:@"机会用完啦"];
                }
                
            }else{//没钱
                bounceDumplingInforView.remainingNumberLab.text = [NSString stringWithFormat:@"机会用完啦"];
            }
        }
    }else{
//        totalMoney = [[ZHDataBase sharedDataBase]selectLogingstateWithReturnTodayTotalMoney:@"0" andUserId:@""];
        if(number == 0){
            if(totalMoney > 0 || couponCount > 0 || greetingCardCount > 0){
                bounceDumplingInforView.remainingNumberLab.attributedText = [LYLTools attributeWithStr:@"马上领取，再得 1 次机会" rangeStr:@"1" rangColor:[UIColor yellowColor]];
            }else{
                bounceDumplingInforView.remainingNumberLab.attributedText = [LYLTools attributeWithStr:@"登录后，再得 2 次机会" rangeStr:@"2" rangColor:[UIColor yellowColor]];
            }
        }
    }

}

#pragma mark -- 按钮的点击事件
- (void)buttonClicked:(UIButton *)button{
    [LYLTools removeBounceViewWithVC:_viewController];
    switch (button.tag) {
        case ButtonTagWithGotoGetMoneyType:
        case ButtonTagWithGoToLoginType:
        {
            LYLQuickLoginViewController *quickLogingVc = [[LYLQuickLoginViewController alloc]init];
            quickLogingVc.enterType = EnterTypeMainWithBounce;
            quickLogingVc.backBlock = ^void(){};
            [_viewController.navigationController pushViewController:quickLogingVc animated:YES];
            
        }
            break;
            
        case ButtonTagWithGoToShareType://马上分享
        {
            MySetObjectForKey(ShareTypeWithBounce, ShareTypeKey);
//            if([bounceDumplingInforView.model.resultListModel.dumplingModel.dumplingType isEqualToString:@"3"]){//当前捞到的是优惠劵
//                [ShareInfoManage shareWithType:@"0" andContentStr:@"" andViewController:_viewController];
//            }else{//当前
//                [ShareInfoManage shareWithType:@"1" andContentStr:@"" andViewController:_viewController];
//            }
            [ShareInfoManage shareWithType:ShareTypeWithMainBounce andContentStr:@"" andViewController:_viewController];
            
        }
            break;
        case ButtonTagWithTomorrowAgainScoopType:
        case ButtonTagWithContinueToMakeType:
            
        {
            
            
        }
            break;
        case ButtonTagWithCheckTheBalanceType:
        {
            mineWalletViewController *wallerViewController = [[mineWalletViewController alloc]init];

            [_viewController.navigationController pushViewController:wallerViewController animated:YES];
            
        }
            break;
        default:
            break;
    }
    
}

#pragma maek -- 贺卡点击
- (void)tap:(UITapGestureRecognizer *)tap{
    ZHLog(@"点击了贺卡");
}

#pragma mark -- 去关闭点击
- (void)shutDownBtnClicked:(UIButton *)button{
    
    [LYLTools removeBounceViewWithVC:_viewController];
    ZHLog(@"关闭");
    
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
