//
//  CJTopUpViewController.m
//  Wallet
//
//  Created by zhaochunjing on 15-10-21.
//  Copyright (c) 2015年 Sinoglobal. All rights reserved.
//  充值页面

#import "CJTopUpViewController.h"
#import "CJTopUpRecordViewController.h"
#import "WalletHome.h"
#import "mineWalletViewController.h"
#import "CJWithdrawDepositInfoViewController.h"
#import "CJTopUpDetailsViewController.h"
#import "CJTopUpModel.h"
#import "CJTopUpPayModel.h"
#import "WXApi.h"
#import "WXUtil.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Umpay.h"
#import "UmpayElements.h"


///** 支付类型 */
//typedef NS_ENUM(int, PayType1) {
//    PayTypeZhiFuBao = 0,
//    PayTypeWeiXin,
//    PayTypeUFu,
//    PayTypeWallet
//};

@interface CJTopUpViewController () <UITextFieldDelegate,WXApiDelegate,UmpayDelegate>

{
    /** 记录支付方式的之前按钮 */
    UIButton *_oldBtn;
    /** 记录上一次的出现.的字符串 */
    NSString *_oldTextFieldText;
}

/** 输入金额的文本框 */
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
/** 支付类型的label */
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
/** 充值成功的提示框 充值成功后显示 */
@property (weak, nonatomic) IBOutlet UILabel *succeedLabel;
/** 确认充值按钮 */
@property (weak, nonatomic) IBOutlet UIButton *topUpBtn;
/** 支付宝选中图片 */
@property (weak, nonatomic) IBOutlet UIImageView *zhiFuImage;
/** 微信支付选中图片 */
@property (weak, nonatomic) IBOutlet UIImageView *weiXinImage;
/** 借记卡选中图片 */
@property (weak, nonatomic) IBOutlet UIImageView *jieJiImage;
/** 弹出页（蒙板） */
@property (weak, nonatomic) IBOutlet UIView *jumpView;
/** 弹出页的子页（支付方式页） */
@property (weak, nonatomic) IBOutlet UIView *jumpSubView;

/** 全局的支付加密串 请求模型 */
@property (nonatomic, strong) CJTopUpPayModel *payModel;
/** 支付宝的对调结果 */
@property (nonatomic, strong) NSDictionary *resultDic;
/** 返回的结果 */
@property (nonatomic, assign) ResultPay resultPayType;


/** 选择支付类型的点击事件 */
- (IBAction)paytypeClick:(UIButton *)sender;
/** 确认充值按钮的点击事件 */
- (IBAction)topUpBtnClick:(UIButton *)sender;
/** 支付方式的点击状态事件 */
- (IBAction)zhiFuTypeClick:(UIButton *)sender;

@end

@implementation CJTopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化界面
    [self makeInitView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //微信、支付宝、U付 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinGoBack:) name:WeiXinWalletNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePayStatu:) name:@"judgePayStatu" object:nil];
    
    NSUserDefaults *userPay = [NSUserDefaults standardUserDefaults];
    NSString *payTypeSave = [userPay objectForKey:PayTypeSave];
    if ([payTypeSave intValue] != 0) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:[payTypeSave intValue]];
        [self zhiFuTypeClick:btn];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.topUpBtn.enabled = YES;
    [self chrysanthemumClosed];
}

/** 初始化界面 */
- (void)makeInitView
{
    //    self.backView.backgroundColor = WalletHomeNAVGRD;
    self.mallTitleLabel.text = @"充值";
    //    self.mallTitleLabel.textColor = WalletHomeNAVTitleColor;
    //    self.mallTitleLabel.font = WalletHomeNAVTitleFont;
    //    [self.leftBackButton setImage:[UIImage imageNamed:@"title_btn_back"] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"记录" forState:UIControlStateNormal];
//    [self.rightButton setTitleColor:WalletHomeNAVTitleColor forState:UIControlStateNormal];
//    self.rightButton.titleLabel.font = WalletHomeNAVRigthFont;
    CGRect frame = self.rightButton.frame;
    frame.size.width += 20;
    frame.origin.x -= 20;
    self.rightButton.frame = frame;
    
    self.topUpBtn.layer.cornerRadius = 5;
    self.topUpBtn.layer.masksToBounds = YES;
    self.succeedLabel.hidden = YES;
    self.jumpView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    mainView.backgroundColor =[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    self.view.backgroundColor = WalletHomeBackGRD;
    self.moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoAction)name:UITextFieldTextDidChangeNotification object:nil];
    
    // 隐藏弹出界面
    [self hiddenJumpView];
}

/** textField的监听事件 */
- (void)infoAction
{
    if (self.moneyTextField.text.length == 2 && ![[self.moneyTextField.text substringFromIndex:1] isEqualToString:@"."] && [self.moneyTextField.text intValue] < 10) {
        self.moneyTextField.text = @"";
        [self showMsg:@"请输入正确的金额"];
        return;
    }
    NSArray *array = [self.moneyTextField.text componentsSeparatedByString:@"."];
    if (array.count == 2) {
        NSString *textStr = array[1];
        if (textStr.length > 2) {
            self.moneyTextField.text = _oldTextFieldText;
            //            [self showMsg:@"最小金额为分"];
        }
        _oldTextFieldText = self.moneyTextField.text;
    } else if (array.count == 3) {
        self.moneyTextField.text = _oldTextFieldText;
        [self showMsg:@"请输入正确的金额"];
    }
}

/** 右侧按钮的点击事件 */
- (void)rightBackCliked
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WeiXinWalletNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"judgePayStatu" object:nil];
    
    //充值记录界面
    CJTopUpRecordViewController *recordVC = [[CJTopUpRecordViewController alloc] init];
    recordVC.recordType = @"0";
    [self.navigationController pushViewController:recordVC animated:YES];
}
/** 隐藏弹出界面 */
- (void)hiddenJumpView
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.jumpSubView.frame;
        frame.origin.y = ScreenHeight ;
        self.jumpSubView.frame = frame;
    } completion:^(BOOL finished) {
        self.jumpView.hidden = YES;
    }] ;
}

/** 显示弹出界面 */
- (void)showJumpView
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.jumpSubView.frame;
        frame.origin.y = ScreenHeight - 164;
        self.jumpSubView.frame = frame;
        self.jumpView.hidden = NO;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    if (self.jumpSubView.frame.origin.y < ScreenHeight) {
        [self hiddenJumpView];
    }
}

#pragma mark - TextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.moneyTextField.text.length) {
        NSMutableString *str = [NSMutableString stringWithString:self.moneyTextField.text];
        self.moneyTextField.text = [str stringByReplacingOccurrencesOfString:@"元" withString:@""];
        //        self.yuanLabel.hidden = YES;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if ([self.moneyTextField.text isEqualToString:@""]) {
        return;
    }
    if ([self.moneyTextField.text floatValue] <= 0) {
        self.moneyTextField.text = @"";
        [self showMsg:@"充值最低为0.01元"];
        return;
    }
    if (![self isPureFloat:self.moneyTextField.text]) {
        [self showMsg:@"请输入正确的金额"];
        self.moneyTextField.text = @"";
        return;
    }
}

/** 金额末尾是否需要添加0 */
- (NSString *)addMoneyZeroWithMoneyText:(NSString *)moneyText
{
    NSArray *array = [moneyText componentsSeparatedByString:@"."];
    NSMutableString *text = [NSMutableString stringWithString:self.moneyTextField.text];
    if (array.count == 1) {
        [text appendFormat:@".00"];
    } else if (array.count == 2) {
        NSString *textStr = array[1];
        if (textStr.length == 0) {
            [text appendFormat:@"00"];
        } else if (textStr.length == 1) {
            [text appendFormat:@"0"];
        }
    }
    return text;
}



#pragma mark - 按钮的点击事件
/** 选择支付类型的点击事件 */
- (IBAction)paytypeClick:(UIButton *)sender {
    [self.view endEditing:YES];
    //展示弹出页
    [self showJumpView];
    //判断类型
    self.zhiFuImage.hidden = YES;
    self.weiXinImage.hidden = YES;
    self.jieJiImage.hidden = YES;
    if ([self.payLabel.text isEqualToString:@"支付宝"]) {
        self.zhiFuImage.hidden = NO;
    } else if ([self.payLabel.text isEqualToString:@"微信支付"]) {
        self.weiXinImage.hidden = NO;
    } else if ([self.payLabel.text isEqualToString:@"借记卡"]) {
        self.jieJiImage.hidden = NO;
    }
    //    else {//默认选中支付宝
    //        self.zhiFuImage.hidden = NO;
    //        self.payLabel.text = @"支付宝";
    //    }
    
}
/** 判断是否是金额数 */
- (BOOL)isPureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

/** 确认充值按钮的点击事件 */
- (IBAction)topUpBtnClick:(UIButton *)sender {
    
    NSString *moneyStr = [self.moneyTextField.text stringByReplacingOccurrencesOfString:@"元" withString:@""];
    if (![self isPureFloat:moneyStr]) {
        [self showMsg:@"请输入正确的金额"];
        self.moneyTextField.text = @"";
        return;
    }
    moneyStr = [self addMoneyZeroWithMoneyText:moneyStr];
    if ([moneyStr floatValue] <= 0) {
        [self showMsg:@"请输入金额"];
        return;
    } else if ([self.payLabel.text isEqualToString:@"请选择支付方式"]) {
        [self showMsg:@"请选择支付方式"];
        return;
    }
    
#pragma mark - 充值的网络请求
    
    if (!_payModel.trade_sn.length) {
        _payModel.trade_sn = @"";
    }
    
    NSString *urlStr = _oldBtn.tag == PayTypeZhiFuBao ? WalletHttp_alipayRequest10001 : _oldBtn.tag == PayTypeWeiXin ? WalletHttp_wechatpayRequest10002 : WalletHttp_ufpayRequest10003;
    NSDictionary *dict = [WalletRequsetHttp WalletPersonPayRequest10000WithAmount:self.moneyTextField.text paySource:@"wallet" goodName:@"钱包" goodDepice:@"钱包充值" modelId:@"1" orderSn:_payModel.trade_sn];
    NSString *url = [NSString stringWithFormat:@"%@%@",urlStr,[dict JSONFragment]];
    
    [self chrysanthemumOpen];
    self.topUpBtn.enabled = NO;
    [SINOAFNetWorking postWithBaseURL:url controller:self success:^(id json){
        [self chrysanthemumClosed];
        NSLog(@"充值 --- %@",json);
        NSLog(@"-- %@ --",json[@"msg"]);
        //        NSDictionary *dict  = [json[@"rs"] JSONValue];
        //        NSLog(@"%@",dict);
        
        
        if ([json[@"code"] intValue] == 101) {
            [self showMsg:@"网络状态不佳，请重试！"];
            self.topUpBtn.enabled = YES;
            return ;
        } else if ([json[@"code"] intValue] == 100) {
            _payModel = [[CJTopUpPayModel alloc] initWithDict:json[@"rs"]];
            [self jumpPayTypeWithPayType:(int)_oldBtn.tag];
            
            return;
        }
        
        
    } failure:^(NSError *error) {
        [self chrysanthemumClosed];
        self.topUpBtn.enabled = YES;
    } noNet:^{
        [self chrysanthemumClosed];
        self.topUpBtn.enabled = YES;
    }];
}

/** 回调成功后再次请求支付是否成功 */
- (void)requestSucceedJudge
{
    NSDictionary *dict = [WalletRequsetHttp WalletPersonSucceedJudgeRequest10010WithOrderSn:_payModel.trade_sn];
    NSString *url = [NSString stringWithFormat:@"%@%@",WalletHttp_succeedJudgeRequest10010,[dict JSONFragment]];
    [self chrysanthemumOpen];
    [SINOAFNetWorking postWithBaseURL:url controller:self success:^(id json) {
        [self chrysanthemumClosed];
        if ([json[@"code"] intValue] == 100) {
            if ([json[@"rs"] intValue] == 3) {
                self.resultPayType = ResultPaySucceed;
            } else {
                self.resultPayType = ResultPayInHand;
            }
            [self succeedJumpToVC];
            self.topUpBtn.enabled = YES;
        }
        NSLog(@"%@",json);
    } failure:^(NSError *error) {
        [self chrysanthemumClosed];
        self.topUpBtn.enabled = YES;
    } noNet:^{
        [self chrysanthemumClosed];
        self.topUpBtn.enabled = YES;
    }];
    
}


/** 跳转不同的支付方式 */
- (void)jumpPayTypeWithPayType:(PayType)payType
{
    self.topUpBtn.enabled = YES;
    switch (payType) {
        case PayTypeZhiFuBao:
            //跳转支付宝
        {
            //需要在请求里面写
            [[AlipaySDK defaultService] payOrder:_payModel.sign fromScheme:ZHIFUBAOAPPSCHEME callback:^(NSDictionary *resultDic) {
                self.resultDic = [NSDictionary dictionaryWithDictionary:resultDic];
                [self judgePayStatu];
            }];
        }
            break;
        case PayTypeWeiXin:
            //跳转微信
        {
            if (![WXApi isWXAppInstalled]) {
                [self showMsg:@"您暂未安装相关应用"];
                self.topUpBtn.enabled = YES;
                return;
            } ;
            //发起微信支付，设置参数
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = _payModel.partnerid;
            request.prepayId= _payModel.prepayid;
            request.package = @"Sign=WXPay";
            request.nonceStr= _payModel.noncestr;
            //将当前事件转化成时间戳
            request.timeStamp = [NSString stringWithFormat:@"%@",_payModel.timestamp].intValue;
            request.sign = _payModel.sign;
            //            调用微信
            [WXApi sendReq:request];
        }
            break;
        case PayTypeUFu:
            //跳转U付
        {
            UmpayElements* inPayInfo = [[UmpayElements alloc]init];
            [inPayInfo setIdentityCode:@""];
            [inPayInfo setEditFlag:@"1"];
            [inPayInfo setCardHolder:@""];
            [inPayInfo setMobileId:@""];
            
            [Umpay pay:[NSString stringWithFormat:@"%@",_payModel.trade_no] merCustId:@"GoodStudy" shortBankName:@"" cardType:@"0" payDic:inPayInfo rootViewController:self delegate:self];
        }
            break;
            
        default:
            break;
    }
    NSUserDefaults *userPay = [NSUserDefaults standardUserDefaults];
    [userPay setObject:[NSString stringWithFormat:@"%d",payType] forKey:PayTypeSave];
    [userPay synchronize];
}
#pragma mark- 支付回调
//微信回调
- (void)weixinGoBack:(NSNotification *)info
{
    NSDictionary *dict = [info userInfo];
    NSURL *url = dict[@"weixinUrl"];
    [WXApi handleOpenURL:url delegate:self];
}
//微信代理回调
- (void)onReq:(BaseReq *)req
{
    
}
- (void)onResp:(BaseResp *)resp
{
    NSString *strTitle;
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if ([resp isKindOfClass:[PayResp class]]) {
        strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
            {
                NSLog(@"支付结果: 成功!");
                self.resultPayType = ResultPaySucceed;
                [self requestSucceedJudge];
            }
                break;
            case WXErrCodeCommon:
            { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                
                NSLog(@"支付结果: 失败!");
                self.resultPayType = ResultPayFailure;
            }
                break;
            case WXErrCodeUserCancel:
            { //用户点击取消并返回
                self.resultPayType = ResultPayPending;
            }
                break;
            case WXErrCodeSentFail:
            { //发送失败
                NSLog(@"发送失败");
                self.resultPayType = ResultPayFailure;
            }
                break;
            case WXErrCodeUnsupport:
            { //微信不支持
                NSLog(@"微信不支持");
                self.resultPayType = ResultPayPending;
            }
                break;
            case WXErrCodeAuthDeny:
            { //授权失败
                NSLog(@"授权失败");
                self.resultPayType = ResultPayPending;
            }
                break;
            default:
                break;
        }
        if (self.resultPayType != ResultPaySucceed) {
            [self succeedJumpToVC];
            self.topUpBtn.enabled = YES;
        }
        //------------------------
    }
}

//支付宝
- (void)judgePayStatu:(NSNotification *)info
{
    self.resultDic = [info userInfo][@"resultDic"];
    [self judgePayStatu];
}
//支付宝回调
-(void)judgePayStatu
{
    
    if ([self.resultDic[@"resultStatus"] integerValue] == 9000) {
        self.resultPayType = ResultPaySucceed;
        [self requestSucceedJudge];
    }else if ([self.resultDic[@"resultStatus"] integerValue] == 6001) {
        self.resultPayType = ResultPayPending;
//        [self showMsg:@"取消支付"];
    }else if ([self.resultDic[@"resultStatus"] integerValue] == 4000) {
        self.resultPayType = ResultPayFailure;
//        [self showMsg:@"支付失败"];
    }else if ([self.resultDic[@"resultStatus"] integerValue] == 6002) {
        self.resultPayType = ResultPayPending;
//        [self showMsg:@"取消支付"];
    }else if ([self.resultDic[@"resultStatus"] integerValue] == 8000) {
        self.resultPayType = ResultPayInHand;
//        [self showMsg:@"正在处理中"];
    }else{
//        [self showMsg:@"支付失败，请重试"];
        self.resultPayType = ResultPayFailure;
    }
    if (self.resultPayType != ResultPaySucceed) {
        [self succeedJumpToVC];
        self.topUpBtn.enabled = YES;
    }
}
//U付 回调
- (void)onPayResult:(NSString *)orderId resultCode:(NSString *)resultCode resultMessage:(NSString *)resultMessage
{
    
    if ([resultCode isEqualToString:@"0000"]) {
        self.resultPayType = ResultPaySucceed;
        [self requestSucceedJudge];
    }else{
        self.resultPayType = ResultPayPending;
    }
    if (self.resultPayType != ResultPaySucceed) {
        [self succeedJumpToVC];
        self.topUpBtn.enabled = YES;
    }
}

/** 成功后跳转 */
- (void)succeedJumpToVC
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WeiXinWalletNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"judgePayStatu" object:nil];
    self.succeedLabel.hidden = YES;
    CJTopUpDetailsViewController *VC = [[CJTopUpDetailsViewController alloc] init];
    VC.paytypeTopUp = self.resultPayType;
    CJTopUpModel *topUpModel = [[CJTopUpModel alloc] init];
    topUpModel.amount = self.moneyTextField.text;
    topUpModel.payType = [NSString stringWithFormat:@"%zd",_oldBtn.tag];
    topUpModel.tradeSn = _payModel.trade_sn;
    VC.topUpModel = topUpModel;
    VC.payModel = _payModel;
    VC.comeHereStr = @"充值";
    [self.navigationController pushViewController:VC animated:YES];
}

//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", _payModel.appsecret];
    //得到MD5 sign签名
    NSString *md5Sign =[WXUtil md5:contentString];
    return md5Sign;
}

- (IBAction)zhiFuTypeClick:(UIButton *)sender {
    //    if (_oldBtn == sender) return;
    
    self.zhiFuImage.hidden = YES;
    self.weiXinImage.hidden = YES;
    self.jieJiImage.hidden = YES;
    switch (sender.tag) {
        case PayTypeZhiFuBao:
        {
            self.zhiFuImage.hidden = NO;
            self.payLabel.text = @"支付宝";
        }
            break;
        case PayTypeWeiXin:
        {
            self.weiXinImage.hidden = NO;
            self.payLabel.text = @"微信支付";
        }
            break;
        case PayTypeUFu:
        {
            self.jieJiImage.hidden = NO;
            self.payLabel.text = @"借记卡";
        }
            break;
            
        default:
            break;
    }
    _oldBtn = sender;
    //隐藏弹出页
    [self hiddenJumpView];
}

- (void)dealloc
{
    [self chrysanthemumClosed];
}


@end




