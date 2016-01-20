//
//  BaoJiaoSuccectController.m
//  LaoYiLao
//
//  Created by liujinhe on 15/12/16.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "BaoJiaoSuccectController.h"
#import "FaJiaoziView.h"
#import "ZaiBaoYigeView.h"
#import "LJHTanChuTiView.h"
#import "LJHTanChuViewAnimation.h"
#import "LaoYiLaoViewController.h"
#import "ShareInfoManage.h"
@interface BaoJiaoSuccectController ()<FaJiaoziViewDelegate,ZaiBaoYigeViewDelegate>
@property (nonatomic,strong)FaJiaoziView *fajiaozi;//发饺子
@property (nonatomic,strong)ZaiBaoYigeView *zaibaoyige;//
@end

@implementation BaoJiaoSuccectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customNavigation.shareButton.hidden = YES;
    self.customNavigation.rightButton.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.7961 green:0.0 blue:0.0667 alpha:1.0];
    self.customNavigation.backgroundColor = [UIColor colorWithRed:0.8353 green:0.0 blue:0.0235 alpha:1.0];
    _isSuccedShared = NO;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shaareCodubaceked) name:@"shareCallBack" object:nil];
    [self makeUIBaoJiao];
}
- (void)makeUIBaoJiao{
    [self changeBarTitleWithString:@"包饺子"];
    if(_tempDe==1||_tempDe==3){
        _fajiaozi = [[FaJiaoziView alloc]initWithFrame:CGRectMake(0, NavgationBarHeight, kkViewWidth,CustomViewHeight)];
        _fajiaozi.delegate = self;
        [self.view addSubview:_fajiaozi];
    
    }else{
        _zaibaoyige = [[ZaiBaoYigeView alloc]initWithFrame:CGRectMake(0, NavgationBarHeight, kkViewWidth, CustomViewHeight)];
        _zaibaoyige.delegate = self;
        [self.view addSubview:_zaibaoyige];
    
    }
 

}
//包饺子成功代理方法

-(void)faJiaozi{
    
   // [LYLHttpTool shareEndandPayforEndPayId:@"11111"]//小锅订单
    if (_tempDe==1) {
        ZHLog(@"包饺子成功");
        [self showHudInView:self.view hint:nil];
        _isSuccedShared = NO;
        [LYLAFNetWorking getWithBaseURL:[LYLHttpTool shareEndandPayforEndPayId:_dumplinguserputmoneyid] success:^(id json) {
            ZHLog(@"%@",json);
            if ([[json valueForKey:@"code"] isEqualToString:@"100"]) {
//                MySetObjectForKey(ShareTypeWithMakeMoney, ShareTypeKey);
                [ShareInfoManage shareWithType:ShareTypeWithSendCashDumpling andContentStr:_dumplinguserputmoneyid andViewController:self];
                [self hideHud];
            }else{
                [self showHint:@"太拥挤了,请稍等" yOffset:-100];
                [self hideHud];
                
            }
            
            
            
        } failure:^(NSError *error) {
            ZHLog(@"%@",error);
            [self hideHud];
            
        }];
    }else if (_tempDe ==3){
    ZHLog(@"朋友包贺卡分享");
    
        
    }
    
    


}
-(void)backBtnClicked{
    if(_tempDe==1){
    LJHTanChuTiView* lookeVc = [LJHTanChuTiView sharedManager];
    [LJHTanChuViewAnimation showView:lookeVc.teeVV overlayView:lookeVc.teeVV];
    [lookeVc turnDefoutViewWithTyp:1];
    lookeVc.teeVV.delegate = self;
    [self.view addSubview:lookeVc];
    }
    else if(_tempDe==2){
    //有缘人
       [self buFaSong];
    }else{
    //朋友
        [self buFaSong];
    
    }
    

}
- (void)buFaSong{
    ZHLog(@"不发送");
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[LaoYiLaoViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
   
}

//分享成功回调
- (void)shaareCodubaceked{
    if (_tempDe==1) {
        if (_isSuccedShared) {
            [LYLAFNetWorking postWithBaseURL:[LYLHttpTool changeDumplingStateWithPannikinId:_dumplinguserputmoneyid] success:^(id json) {
                ZHLog(@"改变状态%@",json);
                
            } failure:^(NSError *error) {
                ZHLog(@"改变状态%@",error);
            }];
            
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[LaoYiLaoViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
    }else{
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[LaoYiLaoViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
    
    
}

- (void)faSongEwss{
     ZHLog(@"发送");
    [self faJiaozi];
}

/**
 *  有缘人包贺卡分享方法
 */
-(void)ZaiBaoYige{
    ZHLog(@"再包贺卡");
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)ShareBaoJiaozi{
    ZHLog(@"分享一个");
    
}


@end
