//
//  ZHDumplingWithTypeView.m
//  LaoYiLao
//
//  Created by wzh on 15/12/17.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "ZHDumplingWithTypeView.h"
#import "ZHDumplingTypeMoneyView.h"
#import "ZHDumplingTypeBlessingView.h"
#import "ZHDumplingTypeCouponView.h"
#import "ZHDumplingTypeGreetingCardView.h"
@implementation ZHDumplingWithTypeView{
    ZHDumplingTypeMoneyView *_moneyView;
    ZHDumplingTypeBlessingView *_blessingView;
    ZHDumplingTypeCouponView *_couponView;
    ZHDumplingTypeGreetingCardView *_greetingCardView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _moneyView = [[ZHDumplingTypeMoneyView alloc]init];
        [self addSubview:_moneyView];
        _blessingView = [[ZHDumplingTypeBlessingView alloc]init];
        [self addSubview:_blessingView];
        _couponView = [[ZHDumplingTypeCouponView alloc]init];
        [self addSubview:_couponView];
        _greetingCardView = [[ZHDumplingTypeGreetingCardView alloc]init];
        [self addSubview:_greetingCardView];
    }
    return self;
}


- (void)setModel:(DumplingInforModel *)model{
    _model = model;
    _moneyView.hidden = YES;
    _blessingView.hidden = YES;
    _couponView.hidden = YES;
    _greetingCardView.hidden = YES;
    self.userInteractionEnabled = NO;
    UIView *pointview;
    NSString *dumplingType = model.resultListModel.dumplingModel.dumplingType;
    if([dumplingType isEqualToString:DumplingTypeMoney]){ //  钱
        _moneyView.hidden = NO;
        pointview = _moneyView;
        _moneyView.model = model;
        
    }else if ([dumplingType isEqualToString:DumplingTypeBlessing]){//祝福
        _blessingView.hidden = NO;
        pointview = _blessingView;
        _blessingView.model = model;

    }else if ([dumplingType isEqualToString:DumplingTypePlatformCoupon] || [dumplingType isEqualToString:DumplingTypeGoodsCoupon] || [dumplingType isEqualToString:DumplingTypeThirdCoupon] || [dumplingType isEqualToString:DumplingTypeMerchantsCoupon]){//优惠劵
        _couponView.hidden = NO;
        pointview = _couponView;
        _couponView.model = model;

    }else if ([dumplingType isEqualToString:DumlingTypeGreetingCard]){//贺卡
        _greetingCardView.hidden = NO;
        pointview = _greetingCardView;
        _greetingCardView.model = model;
        self.userInteractionEnabled = YES;

    }else{//容错处理
        _blessingView.hidden = NO;
        pointview = _blessingView;
        _blessingView.model = model;
    }
    
    pointview.center = CGPointMake(self.frame.size.width / 2, pointview.center.y);
    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y, self.frame.size.width, pointview.frame.size.height);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
