//
//  SSDumplingView.m
//  LaoYiLao
//
//  Created by sunsu on 15/10/30.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "SSDumplingView.h"

#import "SSNoDumpView.h"
#import "SSBaoJiaoZiBtnView.h"
#import "SSInfoDumpView.h"


#define BaoJiaoziView_H 50

@interface SSDumplingView ()
{
    SSNoDumpView  * _noDumplingView;//没捞到饺子的页面
}

@end

@implementation SSDumplingView

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        self.backgroundColor = RGBACOLOR(242, 242, 242, 1);
    }
    return self;
}


-(void)initUI{
    _baoJzView = [[SSBaoJiaoZiBtnView alloc]init];
    [self addSubview:_baoJzView];
    
    
    //无饺子界面
    _noDumplingView = [[SSNoDumpView alloc]init];
    [self addSubview:_noDumplingView];
    
    
    
    //有饺子界面
    _infoDumplingView = [[SSInfoDumpView alloc]init];
    [self addSubview:_infoDumplingView];
}




- (void)layoutSubviews{
    [super layoutSubviews];
    
}


- (void) createInfoDumplingView{
    CGRect infoFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-BaoJiaoziView_H);
    _infoDumplingView.frame = infoFrame;
    _infoDumplingView.userInteractionEnabled = YES;
}




//没有饺子的界面
- (void) createNoDumplingView{
    CGRect infoFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-BaoJiaoziView_H);
    _noDumplingView.frame = infoFrame;
}




- (void)setMyDumModel:(SSMyDumplingModel *)myDumModel{
    _myDumModel = myDumModel;

    _baoJzView.frame =CGRectMake(0, self.frame.size.height-BaoJiaoziView_H, kkViewWidth, BaoJiaoziView_H);
    
    if ( [_myDumModel.resultListModel.count isEqualToString:@"0"]) {
        [self createNoDumplingView];
        _infoDumplingView.hidden = YES;
        _noDumplingView.hidden = NO;
    }else{
        [self createInfoDumplingView];
        _noDumplingView.hidden = YES;
        _infoDumplingView.hidden = NO;
    }
    
    
    _infoDumplingView.myDumModel = _myDumModel;
    
}







@end
