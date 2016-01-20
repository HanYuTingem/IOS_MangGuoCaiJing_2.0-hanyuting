//
//  MyDumplingViewController.m
//  LaoYiLao
//
//  Created by sunsu on 15/12/9.
//  Copyright © 2015年 sunsu. All rights reserved.
//
#import "NewMyDumpView.h"
#import "MyDumplingViewController.h"


#import "GDHAccountBalanceViewController.h"
#import "LaoMyCounponListViewController.h"
#import "WoBaoViewController.h"
#import "WobaoGreetCardViewController.h"
#import "WolaoGreetCardViewController.h"
#import "GDHCouponViewController.h"

#import "ShareInfoManage.h"
#import "NoServerView.h"
#import "SSNoNetView.h"

@interface MyDumplingViewController ()<NewInfoDumpViewDelegate>
{
    NewMyDumpView * _newMyDumpView;
    NSString      * _xianjinStr;
    NoServerView  * _noServerView;
    SSNoNetView   * _noNetView;
    
    
    NSDictionary  * _receiveJson;
    NSString      * _wobaoTotalMoney;
    NSString      * _wobaoTotalNumber;
    NSString      * _wobaoHekaNumber;
}
@end

@implementation MyDumplingViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"netStateChange" object:nil];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(netWorkStateChange:) name:@"netStateChange" object:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.customNavigation.backgroundColor = RGBACOLOR(192, 21, 31, 1);
    [self changeBarTitleWithString:@"我的饺子"];
    
    _receiveJson = [NSDictionary dictionary];//我的饺子接口数据

    //饺子view
    [self addNoServerUI];
    [self addNoNetView];
    [self addMyDumpUI];

    if([LYLTools netWorkIsOk]){
        [self loadDataMyDumpling];
    }else{
        _noNetView.hidden = YES;
        _newMyDumpView.hidden = YES;
        _noNetView.hidden = NO;
    }
}


-(void)addMyDumpUI{
    CGRect myDumpViewFrame = CGRectMake(0, NavgationBarHeight, kkViewWidth, CustomViewHeight);
    _newMyDumpView = [[NewMyDumpView alloc]initWithFrame:myDumpViewFrame];
    _newMyDumpView.infoDumpView.delegate = self;
    _newMyDumpView.hidden = YES;
    [self.view addSubview:_newMyDumpView];
    
}

-(void)addNoServerUI{
    CGRect myDumpViewFrame = CGRectMake(0, NavgationBarHeight, kkViewWidth, CustomViewHeight);
    _noServerView = [[NoServerView alloc]initWithFrame:myDumpViewFrame];
    _noServerView.hidden = YES;
    [self.view addSubview:_noServerView];
}

-(void)addNoNetView{
    CGRect myDumpViewFrame = CGRectMake(0, NavgationBarHeight, kkViewWidth, CustomViewHeight);
    _noNetView = [[SSNoNetView alloc]initWithFrame:myDumpViewFrame];
    _noNetView.backgroundColor = BackRedColor;
    _noNetView.hidden = YES;
    [self.view addSubview:_noNetView];
}


- (void)loadDataMyDumpling{
    [self showHudInView:self.view hint:@"正在加载"];
    
    NSString * urlStr = [LYLHttpTool myDumplingWithProductCode:ProductCode sysType:SysType andSessionValue:SessionValue andUserId:MyObjectForKey(UserIDKey)];
    [LYLAFNetWorking postWithBaseURL:urlStr success:^(id json) {
        ZHLog(@"我的饺子==%@",json);
        [self hideHud];
        if([json[@"code"] isEqualToString:@"100"]){
            _receiveJson =  json[@"resultList"];
            
            _xianjinStr = json[@"resultList"][@"price"];
            SSMyDumplingModel *myDumpModel = [SSMyDumplingModel getMyDumplingModelWithDic:(NSDictionary *)json];
            _newMyDumpView.myDumpModel = myDumpModel;
            
//            _wobaoTotalMoney = json[@"resultList"][@"putMoney"];
//            _wobaoTotalNumber = json[@"resultList"][@"putDumpNumber"];
//            _wobaoHekaNumber = json[@"resultList"][@"putCardNumber"];
            
            _noNetView.hidden = YES;
            _newMyDumpView.hidden = NO;
            _noServerView.hidden = YES;
        }else{
            _noNetView.hidden = YES;
            _newMyDumpView.hidden = YES;
            _noServerView.hidden = NO;
        }
    } failure:^(NSError *error) {
        ZHLog(@"%@",error);
        [self hideHud];
        _noNetView.hidden = YES;
        _newMyDumpView.hidden = YES;
        _noServerView.hidden = NO;
    }];
}

-(void)backBtnClicked{
    if([_type isEqualToString:@"1"]){
        
        for (UIViewController *subVc  in self.navigationController.viewControllers) {
            if([subVc isKindOfClass:[LaoYiLaoViewController class]]){
                [self.navigationController popToViewController:subVc animated:YES];
            }
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

#pragma mark -- NewInfoDumpViewDelegate
-(void)wolaoBtnClicked:(DumpBtn *)sender{
    switch (sender.tag) {
        case 2000://余额明细
        {
            GDHAccountBalanceViewController * accVC = [[GDHAccountBalanceViewController alloc]init];
            [self.navigationController pushViewController:accVC animated:YES];
        }
            break;
        case 2001://优惠券
        {
//            [self showHint:@"功能在路上，敬请期待！"];
            GDHCouponViewController * vc = [[GDHCouponViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
//            LaoMyCounponListViewController * counponVC = [[LaoMyCounponListViewController alloc]init];
//            [self.navigationController pushViewController:counponVC animated:YES];
        }
            break;
        case 2002://我捞贺卡
        {
            [self showHint:@"功能在路上，敬请期待！"];
//            WolaoGreetCardViewController * vc = [[WolaoGreetCardViewController alloc]init];
//            vc.cardNumber = _receiveJson[@"cardNumber"];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2003://门票
        {
            
        }
            break;
            
        default:
            break;
    }
}

-(void)wobaoBtnClicked:(DumpBtn *)sender{
    switch (sender.tag) {
        case 3000:
        {
            WoBaoViewController  * wobaoVC = [[WoBaoViewController alloc]init];
//            wobaoVC.wobaoType = @"我包现金";
            wobaoVC.totalMoney  =  _receiveJson[@"putMoney"];//_wobaoTotalMoney;
            wobaoVC.totalNumber = _receiveJson[@"putDumpNumber"];//_wobaoTotalNumber;
//            wobaoVC.baoJiaoziNum = ;
            [self.navigationController pushViewController:wobaoVC animated:YES];
        }
            break;
        case 3001:
        {
           [self showHint:@"功能在路上，敬请期待！"];
//            WobaoGreetCardViewController * greetVC = [[WobaoGreetCardViewController alloc]init];
//            greetVC.putCardNumber = _receiveJson[@"putCardNumber"];
//            [self.navigationController pushViewController:greetVC animated:YES];
        }
            break;
            
        default:
            break;
    }

}


-(void)Xuanyaoyixia{
//    MySetObjectForKey(ShareTypeWithMyDumpling, ShareTypeKey);
    [ShareInfoManage shareWithType:ShareTypeWithShowOff andContentStr:_xianjinStr andViewController:self];
}

#pragma mark --  监听网络状态的通知
- (void)netWorkStateChange:(NSNotification *)notInfor{
    NSString *str = (NSString *)notInfor.object;
    if([str isEqualToString:@"1"]){
        ZHLog(@"LaoYiLaoViewController = 有网");
        [self showNetOKView];
        [self loadDataMyDumpling];
    }else if([str isEqualToString:@"0"]){
        ZHLog(@"LaoYiLaoViewController = 没网");
            [self showNoNetView];
    }
}

//显示有网view
-(void)showNetOKView{
    _newMyDumpView.hidden = NO;
    _noNetView.hidden = YES;
}

//显示没网的界面
-(void)showNoNetView{
    _noNetView.hidden = NO;
    _newMyDumpView.hidden = YES;
}



@end
