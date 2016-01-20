//
//  NoGetMoneyView.m
//  LaoYiLao
//
//  Created by wzh on 15/11/10.
//  Copyright (c) 2015年 sunsu. All rights reserved.
//

#import "NoGetMoneyView.h"
#import "DumplingInforModel.h"
#import "LYLQuickLoginViewController.h"
//未领取钱的Frame
#define NoGetMoneyViewX 0//无所谓居中
#define NoGetMoneyViewY 80 * KPercenY
#define NoGetMoneyViewW kkViewWidth - 100
#define NoGetMoneyViewH 40

#define TitleW getMoneyBtn.frame.size.width - 50
static NoGetMoneyView *noGetMoneyView;
static UIButton *getMoneyBtn;
static UILabel *titlelab;
static UILabel *desLab;
@implementation NoGetMoneyView

+ (NoGetMoneyView *)shareGetMoneyView{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        noGetMoneyView = [[NoGetMoneyView alloc]init];
//        noGetMoneyView.backgroundColor = [UIColor whiteColor];
        noGetMoneyView.frame = CGRectMake(NoGetMoneyViewX, NoGetMoneyViewY, NoGetMoneyViewW, NoGetMoneyViewH);
        noGetMoneyView.center = CGPointMake(kkViewWidth / 2, noGetMoneyView.center.y);
        
        getMoneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        getMoneyBtn.backgroundColor = [UIColor blueColor];
//        getMoneyBtn.titleLabel.font = UIFont26;
        getMoneyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        getMoneyBtn.frame = CGRectMake(0, 0, noGetMoneyView.frame.size.width, noGetMoneyView.frame.size.height);
        [getMoneyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [getMoneyBtn addTarget:noGetMoneyView action:@selector(getMoneybtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        getMoneyBtn.titleLabel.numberOfLines = 0;
        //        _noGetMoneyView.noGetMoneyStr = @"";
        [noGetMoneyView addSubview:getMoneyBtn];
        
        titlelab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,TitleW , 15)];
        titlelab.center = CGPointMake(getMoneyBtn.frame.size.width / 2, titlelab.center.y);
        titlelab.textAlignment = NSTextAlignmentCenter;
        titlelab.font = UIFont26;
        titlelab.textColor = [UIColor whiteColor];
        titlelab.userInteractionEnabled = NO;
//        titlelab.backgroundColor = [UIColor redColor];
        [getMoneyBtn addSubview:titlelab];
        
        desLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titlelab.frame), getMoneyBtn.frame.size.width, getMoneyBtn.frame.size.height - titlelab.frame.size.height)];
        desLab.textAlignment = NSTextAlignmentCenter;
        desLab.font = UIFont30;
        desLab.textColor = [UIColor yellowColor];
        desLab.userInteractionEnabled = NO;
//        desLab.backgroundColor = [UIColor greenColor];
        [getMoneyBtn addSubview:desLab];
    
    });
    return noGetMoneyView;
}

- (void)refreshShareGetMoneyView{
    
    NSString *desStr;
    if(LYLIsLoging){
        desStr = @"换个手机号领取";
    }else{
        desStr = @"点击领取";
    }
    titlelab.text = [self returnGetMoneyBtnTitle];
    desLab.text = desStr;
    
//    NSString *contentStr = [NSString stringWithFormat:@"%@\n%@",@"今日共捞到1000元,2张优惠劵,100张贺卡"/*[self returnGetMoneyBtnTitle]*/,desStr];
//    
//    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:contentStr];
//    NSRange range = [contentStr rangeOfString:desStr];
//    [attributeStr addAttribute:NSFontAttributeName value:UIFont30 range:range];
//    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:range];
//    [getMoneyBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];

}

- (NSString *)returnGetMoneyBtnTitle{
    CGFloat totalMoney;
    int couponCount;
    int greetingCardCount;
    totalMoney = [[ZHDataBase sharedDataBase]selectLogingstateWithReturnTodayTotalMoney:@"0" andUserId:@""];
    couponCount = [[ZHDataBase sharedDataBase]selectLogingstateWithReturnTodayCouponCount:@"0" andUserId:@""];
    greetingCardCount = [[ZHDataBase sharedDataBase]selectLogingstateWithReturnTodayGreetingCardCount:@"0" andUserId:@""];
    noGetMoneyView.hidden = NO;
    if(totalMoney == 0 && couponCount == 0 && greetingCardCount == 0){
        noGetMoneyView.hidden = YES;
        return @"";
    }else if (totalMoney == 0 && couponCount == 0 && greetingCardCount > 0){
        return [NSString stringWithFormat:@"今日共捞到%d张贺卡",greetingCardCount];
    }else if (totalMoney == 0 && couponCount > 0 && greetingCardCount == 0){
        return [NSString stringWithFormat:@"今日共捞到%d张优惠劵",couponCount];
    }else if (totalMoney > 0 && couponCount == 0 && greetingCardCount == 0){
        return [NSString stringWithFormat:@"今日共捞到%.2f元",totalMoney];
    }else if (totalMoney == 0 && couponCount > 0 && greetingCardCount > 0){
        return [NSString stringWithFormat:@"今日共捞到%d张优惠劵,%d张贺卡",couponCount,greetingCardCount];
    }else if(totalMoney > 0 && couponCount == 0 && greetingCardCount > 0){
        return [NSString stringWithFormat:@"今日共捞到%.2f元,%d张贺卡",totalMoney,greetingCardCount];
    }else if (totalMoney > 0 && couponCount > 0 && greetingCardCount == 0){
        return [NSString stringWithFormat:@"今日共捞到%.2f元,%d张优惠劵",totalMoney,couponCount];
    }else if (totalMoney > 0 && couponCount > 0 && greetingCardCount > 0 ){
        return [NSString stringWithFormat:@"今日共捞到%.2f元,%d张优惠劵,%d张贺卡",totalMoney,couponCount,greetingCardCount];
    }else{
        noGetMoneyView.hidden = YES;
        return @"";
    }
}
- (void)getMoneybtnClicked:(UIButton *)button{
    
    if([self.delegate respondsToSelector:@selector(getMoney)]){
        [self.delegate performSelector:@selector(getMoney)];
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
