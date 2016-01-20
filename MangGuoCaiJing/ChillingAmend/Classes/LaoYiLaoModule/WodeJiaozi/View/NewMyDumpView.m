//
//  NewMyDumpView.m
//  LaoYiLao
//
//  Created by sunsu on 15/12/9.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "NewMyDumpView.h"
#import "NewNoDumpView.h"
@interface NewMyDumpView ()
{
    NewNoDumpView * _noDumplingView;
}
@end

@implementation NewMyDumpView

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initUI];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}


-(void)initUI{
    //有饺子界面
    _infoDumpView = [[NewInfoDumpView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _infoDumpView.hidden = YES;
    _infoDumpView.backgroundColor = RGBACOLOR(242, 242, 242, 1);
    [self addSubview:_infoDumpView];
    
    //无饺子界面
    _noDumplingView = [[NewNoDumpView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _noDumplingView.hidden = YES;
    [self addSubview:_noDumplingView];
    
}


//-(void)createNewInfoDumpView{
//    _infoDumpView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);//kkViewWidth, CustomViewHeight
//    
//}
//
////没有饺子的界面
//- (void)createNoDumplingView{
//    CGRect noDumpFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    _noDumplingView.frame = noDumpFrame;
//    
//}


-(void)setMyDumpModel:(SSMyDumplingModel *)myDumpModel{
    _myDumpModel = myDumpModel;
    
    BOOL isNumber = ![_myDumpModel.resultListModel.moneyNumber isEqualToString:@"0"]||![_myDumpModel.resultListModel.couponNumber isEqualToString:@"0"]||![_myDumpModel.resultListModel.cardNumber isEqualToString:@"0"]||![_myDumpModel.resultListModel.putDumpNumber isEqualToString:@"0"]||![_myDumpModel.resultListModel.putMoneyNumber isEqualToString:@"0"]||![_myDumpModel.resultListModel.putCardNumber isEqualToString:@"0"];
    
    if (isNumber) {
        _noDumplingView.hidden = YES;
        _infoDumpView.hidden = NO;
    }else{
        _infoDumpView.hidden = YES;
        _noDumplingView.hidden = NO;
        [_noDumplingView showViewWithType:NoTypeJiaozi];   
    }
//    _noDumplingView.hidden = YES;
//    _infoDumpView.hidden = NO;
    _infoDumpView.myDumpModel = _myDumpModel;
}


//-(void)layoutSubviews{

//}

@end
