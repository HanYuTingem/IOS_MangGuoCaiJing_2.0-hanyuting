//
//  LYLQuickLoginViewController.m
//  LaoYiLao
//
//  Created by sunsu on 15/11/7.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "LYLQuickLoginViewController.h"
#import "GetSuccessViewController.h"
#import "LYLLoginModel.h"
#import "DumplingInforModel.h"
#import "ServerAgreementViewController.h"
#import "NoGetMoneyView.h"
#import "mineWalletViewController.h"
#import "MyDumplingViewController.h"
#import "ZHPHPLogingManager.h"
#define TimerNum 59
#define PADDING 10

@interface LYLQuickLoginViewController ()
{
    NSTimer* timer; //  计时
    int  timecoutn ;
    //    UITextField* phonetextfield;    //  输入电话
    //    UITextField* yzmtextfileld ;    //  验证码
    NSString * numstr;              //  校验
    QuickLoginView *_quickLoginView; // 快速登录view
}
@property (nonatomic, strong) UILabel * titleLabel;
@end

@implementation LYLQuickLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.backgroundColor = RGBACOLOR(242, 242, 242, 1);
    [self createCustomNavigation];
    
    timecoutn = TimerNum;
    [self createLoginView];
}

- (void)createCustomNavigation
{
    CGRect barViewFrame = CGRectMake(0, 0, kkViewWidth, NavgationBarHeight);
    UIView * barView = [[UIView alloc]initWithFrame:barViewFrame];
    barView.backgroundColor = BackRedColor ;
    
    CGFloat buttonY = 20;
    //返回按钮
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setExclusiveTouch:YES];
    leftButton.frame = CGRectMake(0, buttonY, 44, 44);
    [leftButton addTarget:self action:@selector(leftBarButtonOnclick) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat imageViewW = 44;
    CGFloat imageViewH = 44;
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (leftButton.frame.size.height-imageViewH)/2, imageViewW, imageViewH)];
    imageView.image = [UIImage imageNamed:@"LYL_nav_btn_back_left"];
    [leftButton addSubview:imageView];
    [barView addSubview:leftButton];
    
    CGFloat titleLabelW = kkViewWidth - 44 - 70;
    _titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(60,  buttonY, titleLabelW, 44)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    //    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.text = @"快速登录";
    [barView addSubview:_titleLabel];
    
    [self.view addSubview:barView];
}

#pragma mark --  婆婆界面
-(void)leftBarButtonOnclick{
    _backBlock();
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [timer invalidate];
}

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidAppear:(BOOL)animated{
    
}
- (void) createLoginView{
    CGRect quickLoginViewFrame = CGRectMake(0, 64, kkViewWidth, kkViewHeight-64);
    _quickLoginView = [[QuickLoginView alloc]initWithFrame:quickLoginViewFrame];
    _quickLoginView.delegate = self;
    [self.view addSubview:_quickLoginView];
}



#pragma -mark 方法待实现
- (void) serverAgreementClicked{
    //服务协议
    ServerAgreementViewController * serverAgreementVC = [[ServerAgreementViewController alloc]init];
    [self.navigationController pushViewController:serverAgreementVC animated:YES];
}

//登录按钮
-(void)tijiaobtnclick{
    if (_quickLoginView.phonetextfield.text==nil||_quickLoginView.phonetextfield.text.length==0) {
        [LYLTools showInfoAlert:@"请输入手机号码"];
        return;
    }else if (![LYLTools isMobileNumber:_quickLoginView.phonetextfield.text]){
        [LYLTools showInfoAlert:@"请输入正确的手机号码"];
    }else if (_quickLoginView.yzmtextfileld.text==nil||_quickLoginView.yzmtextfileld.text.length==0) {
        [LYLTools showInfoAlert:@"请输入验证码"];
    }else{
        [self requestData];
    }
    
}


//获取验证码
-(void)getnumbtnclick:(UIButton*)sender{
    
    [_quickLoginView.phonetextfield resignFirstResponder];
    [_quickLoginView.yzmtextfileld resignFirstResponder];
    
    if (_quickLoginView.phonetextfield.text==nil||_quickLoginView.phonetextfield.text.length==0) {
        [LYLTools showInfoAlert:@"请输入手机号码"];
        return;
    }else if (![LYLTools isMobileNumber:_quickLoginView.phonetextfield.text]){
        [LYLTools showInfoAlert:@"请输入正确的手机号码"];
    }
    //    else if(_quickLoginView.yzmtextfileld.text.length != 0 ||_quickLoginView.yzmtextfileld.text != nil){
    //        [Tools showInfoAlert:@"请获取到验证码后再输入"];
    //    }
    else{
        //请求验证码接口
        [self showHudInView:self.view hint:@"正在加载"];
        NSString * url = [LYLHttpTool sendIdentifyCodeWithUserName:_quickLoginView.phonetextfield.text andType:SysType];
        [LYLAFNetWorking postWithBaseURL:url success:^(id json) {
            ZHLog(@"验证码=%@",json);
            [self hideHud];
            NSDictionary * yzmJson = (NSDictionary *)json;
            int returnCode = [[yzmJson objectForKey:@"code"]intValue];
            if (returnCode != 1) {
                [LYLTools showHint:@"验证码发送失败"];
                
                switch (returnCode) {
                        //                case 1:
                        //                {
                        ////                    [LYLTools showInfoAlert:@"验证码发送成功"];
                        //
                        //                }
                        //                    break;
                    case 99:
                    {
                        [LYLTools showInfoAlert:@"超过最大发送次数"];
                    }
                        break;
                    case 203:
                    {
                        [LYLTools showInfoAlert:@"系统异常"];
                    }
                        break;
                    case 101:
                    {
                        [LYLTools showInfoAlert:@"用户名已存在"];
                    }
                        break;
                    case 100:
                    {
                        [LYLTools showInfoAlert:@"用户名不存在"];
                    }
                        break;
                    case 98:
                    {
                        [LYLTools showInfoAlert:@"同一手机号码一分钟之内发送频率不能超过1条"];
                    }
                        break;
                        
                    default:
                        break;
                }
                [timer invalidate];
                sender.userInteractionEnabled = YES;
                [sender setTitle:@"获取验证码" forState:UIControlStateSelected];
                [sender setBackgroundColor:BackRedColor];
                
            }else{
                [LYLTools showHint:@"验证码发送成功"];
            }
            
            
            
            
        } failure:^(NSError *error) {
            ZHLog(@"%@",error);
            [self hideHud];
        }];
        
        
        //        [sender setTitle:[NSString stringWithFormat:@"获取验证码(%2ds)",timecoutn--] forState:UIControlStateNormal];
        //        sender.backgroundColor = [UIColor lightGrayColor];
        //        sender.enabled = NO;
        //        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timechange) userInfo:nil repeats:YES];
        
        sender.selected = YES;
        sender.userInteractionEnabled = NO;
        [sender setTitle:@"获取验证码" forState:UIControlStateSelected];
        sender.backgroundColor = [UIColor lightGrayColor];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timechange) userInfo:nil repeats:YES];
        
        
    }
}


//验证码倒计时
-(void)timechange{
    
    
    UIButton* label =(UIButton*)[self.view viewWithTag:4011];
    [label setTitle:[NSString stringWithFormat:@"获取验证码(%2ds)",timecoutn--] forState:UIControlStateSelected];
    
    if (timecoutn == -1) {
        timecoutn = TimerNum;
        [timer invalidate];
        
        label.userInteractionEnabled = YES;
        [label setTitle:@"获取验证码" forState:UIControlStateSelected];
        [label setBackgroundColor:BackRedColor];
    }
}
//-(void)timechange{
//
//    UIButton* label =(UIButton*)[self.view viewWithTag:4011];
////    label.hidden = YES;
//    [label setTitle:[NSString stringWithFormat:@"获取验证码(%2ds)",timecoutn--] forState:UIControlStateNormal];
//    if(timecoutn == -1){
//        timecoutn = TimerNum;
//        [timer invalidate];
//        [label setTitle:@"重新获取" forState:UIControlStateNormal];
//        [label setBackgroundColor:[UIColor colorWithPatternImage:[LYLTools scaleImage:[UIImage imageNamed:@"lao_bg"] ToSize:CGSizeMake(label.frame.size.width, label.frame.size.height)]]];
//        label.enabled = YES;
//
//    }
//}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


//java登录请求
-(void)requestData{
    NSString * url = [LYLHttpTool quickLoginWithUserName:_quickLoginView.phonetextfield.text Vcode:_quickLoginView.yzmtextfileld.text Type:SysType andpProIden:ProductCode];
    
    [self showHudInView:self.view hint:@"正在登陆。。。"];
    [LYLAFNetWorking postWithBaseURL:url success:^(id json) {
        ZHLog(@"登录 = %@",json);
        LYLLoginModel * loginModel = [LYLLoginModel getLYLLoginModelWithDic:json];
        if ([[json objectForKey:@"code"] intValue] == 1) {//登陆成功
            NSString *userIdStr =[NSString stringWithFormat:@"%@",loginModel.resultModel.id];
            MySetObjectForKey(userIdStr,UserIDKey);//保存登陆用户的id
            MySetObjectForKey(_quickLoginView.phonetextfield.text, LoginPhoneKey);//保存手机号
            ZHLog(@"LYLuserID == %@,LYLPhone == %@",LYLUserId,LYLPhone);
            [ZHLoginInfoManager addSaveJavaCacheInLoginWithJson:json];
            //登录成功
            if(LOGINGTYPE == 1){//只掉java
                [self hideHud];
                [self showHint:@"登陆成功"];
                [self loadDataWithNoLoginGetMoney];
                
            }else if (LOGINGTYPE == 2){//掉完java调php
                [self loadPHP:json];
            }
            
        }else{
            [self hideHud];
            MySetObjectForKey(@"", UserIDKey);
            switch ([[json objectForKey:@"code"] intValue]) {
                case 103:
                {
                    [LYLTools showInfoAlert:@"没有登录平台权限"];
                }
                    break;
                case 203:
                {
                    [LYLTools showInfoAlert:@"系统异常"];
                }
                    break;
                case 2:
                {
                    [LYLTools showInfoAlert:@"用户锁定"];
                }
                    break;
                    
                default:
                    [LYLTools showInfoAlert:@"验证失败,请重新验证"];
                    break;
            }
            
        }
        
    } failure:^(NSError *error) {
        ZHLog(@"java---login%@",error);
        [self hideHud];
    }];
    
}
#pragma mark -- php 登陆请求
- (void)loadPHP:(id)json {
    
    NSDictionary *resultDic = json[@"result"];
    //    NSDictionary *urldic = [LYLHttpTool accessToLoginInformationUserId:[resultDic objectForKey:@"id"] userName:[resultDic objectForKey:@"userName"] sex:[resultDic objectForKey:@"sex"] nickName:[resultDic objectForKey:@"nickname"] src:[resultDic objectForKey:@"src"] jifen:@"0"status:[resultDic objectForKey:@"status"] lat:@"" ing:@"" token:@""];
    
    NSDictionary *urldic = [ZHPHPLogingManager phpLogingWithJavaDic:resultDic];
    [LYLAFNetWorking postWithBaseURL:WZHLogingPHPWithUrl params:urldic success:^(id json) {
        [self hideHud];
        NSDictionary *dict = (NSDictionary *)json;
        if ([dict[@"code"] intValue] == 1) {
            
            [ZHLoginInfoManager addSavePHPCacheInLoginWithJson:json];
            [self showHint:@"登陆成功"];
            [self loadDataWithNoLoginGetMoney];
        }
    } failure:^(NSError *error) {
        ZHLog(@"php---loging%@",error);
        
        [self hideHud];
        
    }];
}

/**
 {“code”:  101 系统错误
 “message”:”There’s an error.” //错误说明
 }
 展示捞奖次数不足，领取失败，提示可以换个手机号领取
 {“code”:  102 //展示捞奖次数不足
 “message”:” 领取失败，提示可以换个手机号领取.” //失败说明
 }
 
 {“code”:  103 登陆失败
 “message”:”” // 验证码错误 注册失败
 }
 {“code”:  104 //饺子已过期
 “message”:” 饺子已过期” //失败说明
 }
 {““code”:  105 //饺子已被领取
 “message”:” 饺子已被领取.” //失败说明
 }
 {“code”:  106//参数不正确
 “message”:” 参数不正确” //失败说明
 }
 {“code”:  107//饺子配置规则缓存无数据
 “message”:” 饺子配置规则缓存无数据” //失败说明
 }
 {“code”:  108 //用户饺子配置规则缓存无数据
 “message”:” 用户饺子配置规则缓存无数据” //失败说明
 }
 {“code”:  109 //饺子缓存为空
 “message”:” 饺子缓存为空” //失败说明
 }
 */
#pragma mark -- 领取接口
-(void)loadDataWithNoLoginGetMoney{
    
    //未登录饺子存储的饺子
    NSMutableArray *dumplingIdArray = [LYLTools noGetMeoneyWithReturnDumplingId];//未登录没有领取的饺子钱
    if(dumplingIdArray.count == 0){//没有饺子可领取 不需要调用领取接口
        if(_enterType == EnterTypeMakeDumpilng){//包饺子
            [self leftBarButtonOnclick];
        }else if (_enterType == EnterTypeMyDumpling){//我得饺子
            MyDumplingViewController *myDumplingVc = [[MyDumplingViewController alloc]init];
            myDumplingVc.type = @"1";
            [self.navigationController pushViewController: myDumplingVc animated:YES];
        }else if (_enterType == EnterTypeMyWallect){//我得钱包
            mineWalletViewController *myWalletVC = [[mineWalletViewController alloc]init];
            myWalletVC.type = @"1";
            [self.navigationController pushViewController: myWalletVC animated:YES];
        }else if (_enterType == EnterTypeMainWithVote){//首页投票
            [self leftBarButtonOnclick];
        }else{//首页弹框 和首页领取 不可能进入当前判断里
            [self leftBarButtonOnclick];
        }
        //        if([_type isEqualToString:@"2"]){//我得钱包
        //            mineWalletViewController *myWalletVC = [[mineWalletViewController alloc]init];
        //            myWalletVC.type = @"1";
        //            [self.navigationController pushViewController: myWalletVC animated:YES];
        //        }else if ([_type isEqualToString:@"1"]){//我得饺子
        //            MyDumplingViewController *myDumplingVc = [[MyDumplingViewController alloc]init];
        //            myDumplingVc.type = @"1";
        //            [self.navigationController pushViewController: myDumplingVc animated:YES];
        //
        //        }else{
        //            [self leftBarButtonOnclick];
        //        }
    }else{
        NSString *dumplingStr =  [dumplingIdArray componentsJoinedByString:@","];
        
        [self showHudInView:self.view hint:@"正在领取。。。"];
        
        CGFloat  totalMoney = [[ZHDataBase sharedDataBase]selectLogingstateWithReturnTodayTotalMoney:@"0" andUserId:@""];
        int  couponCount = [[ZHDataBase sharedDataBase]selectLogingstateWithReturnTodayCouponCount:@"0" andUserId:@""];
        int  greetingCardCount = [[ZHDataBase sharedDataBase]selectLogingstateWithReturnTodayGreetingCardCount:@"0" andUserId:@""];
        
        
        [LYLAFNetWorking getWithBaseURL:[LYLHttpTool noLogingGetMoneyWithProductCode:ProductCode sysType:SysType sessionValue:SessionValue phone:_quickLoginView.phonetextfield.text  prizeidList:dumplingStr andUserId:MyObjectForKey(UserIDKey)] success:^(id json) {
            ZHLog(@"%@",json);
            [self hideHud];
            
            switch ([[json objectForKey:@"code"] intValue]) {
                case 100://领取成功
                {
                    
                    [[ZHDataBase sharedDataBase]upDataWithNoLogingFromlogingState:@"0" toLogingState:@"1" andUserId:LYLUserId];
                    
                    if(totalMoney == 0 && couponCount == 0 && greetingCardCount == 0){
                        [self jumpVcWithGetSucccessOk:NO];
                    }else{
                        [self jumpVcWithGetSucccessOk:YES];
                    }
                }
                    break;
                case 101:
                {
                    if(totalMoney == 0 && couponCount == 0 && greetingCardCount == 0){
                        
                    }else{
                        [LYLTools showInfoAlert:@"系统错误"];
                    }
                }
                    break;
                case 102:
                {
                    [self jumpVcWithGetSucccessOk:NO];
                    if(totalMoney == 0 && couponCount == 0 && greetingCardCount == 0){
                        
                    }else{
                        [self showHint:@"领取失败，可以换个手机号领取" yOffset:40];
                    }
                    
                }
                    break;
                case 103:
                {
                    [self jumpVcWithGetSucccessOk:NO];
                    if(totalMoney == 0 && couponCount == 0 && greetingCardCount == 0){
                        
                    }else{
                        [LYLTools showInfoAlert:@"登陆失败"];
                    }
                    
                }
                    break;
                case 104:
                {
                    [[ZHDataBase sharedDataBase]deleWithLogingState:@"0"];
                    [self jumpVcWithGetSucccessOk:NO];
                    if(totalMoney == 0 && couponCount == 0 && greetingCardCount == 0){
                        
                    }else{
                        [self showHint:@"饺子已过期" yOffset:40];
                    }
                    
                }
                    break;
                case 105:{
                    [[ZHDataBase sharedDataBase]deleWithLogingState:@"0"];
                    
                    [self jumpVcWithGetSucccessOk:NO];
                    if(totalMoney == 0 && couponCount == 0 && greetingCardCount == 0){
                        
                    }else{
                        [self showHint:@"饺子已被领取" yOffset:40];
                    }
                    
                    
                }
                    break;
                    
                case 106:
                {
                    //                [Tools showInfoAlert:@"参数不正确"];
                }
                    break;
                case 107:
                case 108:
                case 109:{
                    [[ZHDataBase sharedDataBase]deleWithLogingState:@"0"];
                    [self jumpVcWithGetSucccessOk:NO];
                    if(totalMoney == 0 && couponCount == 0 && greetingCardCount == 0){
                        
                    }else{
                        [self showHint:@"饺子信息无效" yOffset:40];
                    }
                    
                }
                    break;
                    
                default:{
                    [[ZHDataBase sharedDataBase]deleWithLogingState:@"0"];
                    [self jumpVcWithGetSucccessOk:NO];
                    [self showHint:@"操作失败" yOffset:40];
                    
                }
                    break;
            }
            [[NoGetMoneyView shareGetMoneyView] refreshShareGetMoneyView];//刷新捞一捞界面未领取金额的数据
            
        } failure:^(NSError *error) {
            ZHLog(@"%@",error);
            [self hideHud];
            [self jumpVcWithGetSucccessOk:NO];
            
            [self showHint:@"网络状态不好" yOffset:40];
            
        }];
    }
}


#pragma mark -- 增加捞饺子机会接口 (在前段和APP页面第一次请求捞一捞页面 登陆状态)暂时没用

/**
 *  增加捞饺子机会接口 (在前段和APP页面第一次请求捞一捞页面 登陆状态)
 */
- (void)loadDataAddLYLDumplingWithNumber{
    [self showHudInView:self.view hint:@"正在加载"];
    
    [LYLAFNetWorking getWithBaseURL:[LYLHttpTool addDumplingNuumberWithUserId:MyObjectForKey(UserIDKey) productCode:ProductCode sysType:SysType andSessionValue:SessionValue ] success:^(id json) {
        ZHLog(@"增加捞饺子机会接口=%@",json);
        [self hideHud];
        
        [self loadDataWithNoLoginGetMoney];
        
    } failure:^(NSError *error) {
        ZHLog(@"增加捞饺子机会接口=%@",error);
        [self hideHud];
        [LYLTools showInfoAlert:@"操作失败"];
        
    }];
}


#pragma mark -- 有饺子可领并调完领取接口后的界面的操作
- (void)jumpVcWithGetSucccessOk:(BOOL)isSuccess{
    
    
    if(isSuccess){
        [self showHint:@"领取成功" yOffset:40];
    }
    
    if(_enterType == EnterTypeMakeDumpilng){//包饺子
        [self leftBarButtonOnclick];
    }else if (_enterType == EnterTypeMyDumpling){//我得饺子
        MyDumplingViewController *myDumplingVc = [[MyDumplingViewController alloc]init];
        myDumplingVc.type = @"1";
        [self.navigationController pushViewController: myDumplingVc animated:YES];
    }else if (_enterType == EnterTypeMyWallect){//我得钱包
        mineWalletViewController *myWalletVC = [[mineWalletViewController alloc]init];
        myWalletVC.type = @"1";
        [self.navigationController pushViewController: myWalletVC animated:YES];
    }else if (_enterType == EnterTypeMainWithBounce){//首页弹框
        if(isSuccess){
            //未登录领取钱的
            GetSuccessViewController * getSuccessVC = [[GetSuccessViewController alloc]init];
            [self.navigationController pushViewController:getSuccessVC animated:YES];
        }else{
            [self leftBarButtonOnclick];
        }
    }
    else if (_enterType == EnterTypeMainWithGetMoney){//首页领钱
        [self leftBarButtonOnclick];
    }
    else if (_enterType == EnterTypeMainWithVote){//首页投票
        [self leftBarButtonOnclick];
    }else{//其他可能
        [self leftBarButtonOnclick];
    }
    
    //
    //    if([_type isEqualToString:@"0"]){//包饺子
    //
    //        [self leftBarButtonOnclick];
    //    }else if([_type isEqualToString:@"1"]){//我得饺子
    //
    //        MyDumplingViewController *myDumplingVc = [[MyDumplingViewController alloc]init];
    //        myDumplingVc.type = @"1";
    //        [self.navigationController pushViewController: myDumplingVc animated:YES];
    //    }else if([_type isEqualToString:@"2"]){//我得钱包
    //
    //        mineWalletViewController *myWalletVC = [[mineWalletViewController alloc]init];
    //        myWalletVC.type = @"1";
    //        [self.navigationController pushViewController: myWalletVC animated:YES];
    //    }else{
    //        if(isSuccess){
    //        //未登录领取钱的
    //            GetSuccessViewController * getSuccessVC = [[GetSuccessViewController alloc]init];
    //            [self.navigationController pushViewController:getSuccessVC animated:YES];
    //        }else{
    //            [self leftBarButtonOnclick];
    //        }
    //    }
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
