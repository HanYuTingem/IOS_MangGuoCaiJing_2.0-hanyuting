//
//  BaoJiaoZiViewController.m
//  LaoYiLao
//
//  Created by liujinhe on 15/12/10.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "BaoJiaoZiViewController.h"
#import "ClickDelDiBuView.h"
#import "LJHShuRuBaseView.h"
#import "BaoJiaoSuccectController.h"
#import "CJPayJudgeView.h"


#import "CJTopUpPayModel.h"
#import "WXApi.h"
#import "WXUtil.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Umpay.h"
#import "UmpayElements.h"

#define DIBUHIGHT 50


@interface BaoJiaoZiViewController ()<CJPayJudgeViewDelegate,WXApiDelegate,UmpayDelegate>

@property (nonatomic,strong)LJHShuRuBaseView * baseShuChuView;
@property (nonatomic,strong) NSString* perGeShu;//个数
@property (nonatomic,strong) NSString* priceDesFle;//价格
@property (nonatomic,strong) NSString *textWenBen;//留言
@property (nonatomic,strong) NSString *dumplinguserputmoneyid;//
@property (nonatomic,strong)CJPayJudgeView *payJudgeView;//


/** 记录支付方式 */
@property (nonatomic, assign) PayType payTypeResult;
/** 全局的支付加密串 请求模型 */
@property (nonatomic, strong) CJTopUpPayModel *payModel;
/** 支付宝的对调结果 */
@property (nonatomic, strong) NSDictionary *resultDic;
/** 返回的结果 */
@property (nonatomic, assign) ResultPay resultPayType;

@end

@implementation BaoJiaoZiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mallTitleLabel.text = @"包饺子";
    self.mallTitleLabel.font = UIFont40;
    self.mallTitleLabel.textColor = [UIColor whiteColor];
    self.backView.backgroundColor = [UIColor colorWithRed:0.7961 green:0.0 blue:0.0667 alpha:1.0];
    [self.leftBackButton setImage:[UIImage imageNamed:@"1_return.png"] forState:UIControlStateHighlighted];
    [self.leftBackButton setImage:[UIImage imageNamed:@"1_return.png"] forState:UIControlStateNormal];
    mainView.backgroundColor = [UIColor colorWithRed:0.7961 green:0.0 blue:0.0667 alpha:1.0];
     _textWenBen = @"新年快乐,恭喜发财!";
    [self makeUIBao];
    [self makeViewWithPayId:@""];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setPassWordTitle) name:@"BaojiaoziVc" object:nil];

}

//  捞一捞设置密码后跳  提示
-(void)setPassWordTitle{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showMsg:@"密码设置成功!"];
    });
}

#pragma mark --创建UI
- (void)makeUIBao{
    //输出base
    _baseShuChuView = [[LJHShuRuBaseView alloc] initWithFrame:CGRectMake(0, NavgationBarHeight, kkViewWidth,CustomViewHeight)];
    __block BaoJiaoZiViewController *sekVC = self;
    _baseShuChuView.TextFileDblock = ^void(UITextField* textFiled){
        [sekVC panDuanTag:textFiled];
    };
    _baseShuChuView.TextViewDblock = ^void (UITextView*textView){
        [sekVC textViewGie:textView];
    
    };
    _baseShuChuView.zhiFuView.goPayForBtnBlock = ^void(UIButton*button){
        [sekVC buttonClickedZhiFu];
    };
    [self.view addSubview:_baseShuChuView];
    //底部广告
//    ClickDelDiBuView * onbutton = [[ClickDelDiBuView alloc] initWithFrame:CGRectMake(0, kkViewHeight-50, kkViewWidth, DIBUHIGHT)];
//    [self.view addSubview:onbutton];
//    onbutton.bummBtnBlock = ^void(UIButton *button){
//        [self buttonClicked];
//        };
}
#pragma mark --pop回去
-(void)backBtnClicked{
    [self chrysanthemumClosed];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --点击底部方法
- (void)buttonClicked{
    
}
#pragma mark --点击支付
- (void)buttonClickedZhiFu{
    NSLog(@"___%@===++",_perGeShu);
    
    if ([_perGeShu isEqual:[NSNull null]]|| _perGeShu==nil||[_perGeShu isEqualToString:@""]) {
        [self showHint:@"饺子个数不能为空" yOffset:-100];
        return;
    }else if ([_priceDesFle isEqual:[NSNull null]]|| _priceDesFle==nil||[_perGeShu isEqualToString:@""]){
        [self showHint:@"总金额不能为空" yOffset:-100];
        return;
    }else{
        if ([_perGeShu integerValue]==0) {
            [self showHint:@"请输入正确饺子个数" yOffset:-100];
        }else if([_priceDesFle floatValue]==0 ){
            [self showHint:@"请输入正确金额" yOffset:-100];
        
        }else if([_priceDesFle doubleValue]/[_perGeShu integerValue]>200){
            [self showHint:@"单个饺子金额不可超过200元" yOffset:-100];
        
        }else if([_priceDesFle doubleValue]/[_perGeShu integerValue]<0.01){
            [self showHint:@"单个饺子金额不得低于0.01元" yOffset:-100];
            
        }else{
            
            [self pushSjsView];
        
        }
        
        
    }
    
    
}
/**
 *  跳转支付页面
 */
- (void)pushSjsView{
    /**
    perGeShu;//个数
    priceDesFle;//价格
    textWenBen;//留言
     */
    _baseShuChuView.zhiFuView.zhiFuButton.userInteractionEnabled = NO;
    [self chrysanthemumOpen];
    [LYLAFNetWorking getWithBaseURL:[LYLHttpTool makeZhiFuDingDanPrefrs:_priceDesFle dumplingNum:_perGeShu andContent:_textWenBen] success:^(id json) {
        NSString *strTreCode = [json objectForKey:@"code"];
        if([strTreCode isEqualToString:@"100"]){
            NSString *dumplinguserputmoneyid = [[json objectForKey:@"resultList"] objectForKey:@"dumplingUserPutmoneytid"];
            NSLog(@"%@",dumplinguserputmoneyid);
            [self tanChudedWersew:dumplinguserputmoneyid];
            [self chrysanthemumClosed];
            
        }else{
        [self showHint:@"太拥挤了,请稍等" yOffset:-100];
            [self chrysanthemumClosed];
              _baseShuChuView.zhiFuView.zhiFuButton.userInteractionEnabled = YES;
        }
        
        
    } failure:^(NSError *error) {
        [self showHint:@"太拥挤了,请稍等" yOffset:-100];
        [self chrysanthemumClosed];
        _baseShuChuView.zhiFuView.zhiFuButton.userInteractionEnabled = YES;
    }];

}
#pragma mark --调用钱包支付
- (void)tanChudedWersew:(NSString*)payId{
    _dumplinguserputmoneyid = payId;
    [self showPayJudgeView];
    
}
/** 调出支付类型页 */
- (void)showPayJudgeView
{
    [self.view endEditing:YES];
    self.payJudgeView.requestStr = self.dumplinguserputmoneyid;
    self.payJudgeView.moneyText = self.priceDesFle;
    self.payJudgeView.hidden = NO;
    [self.payJudgeView toCashBtnClick];
      _baseShuChuView.zhiFuView.zhiFuButton.userInteractionEnabled = YES;
    
}
/** 添加支付类型页面 */
- (void)makeViewWithPayId:(NSString *)payId
{
    
    //微信、支付宝、U付 通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinGoBack:) name:WeiXinWalletNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePayStatu:) name:@"judgePayStatu" object:nil];
    
    CJPayJudgeView *payJudgeView = [CJPayJudgeView shareCJPayJudgeViewWithController:self withRequestStr:payId];
    payJudgeView.delegate = self;
    payJudgeView.hidden = YES;
    
    payJudgeView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:payJudgeView];
    self.payJudgeView = payJudgeView;
}
/**
 *  case ResultPayFailure:
 payType = @"失败";
 break;
 case ResultPaySucceed:
 payType = @"成功";
 break;
 case ResultPayClose:
 payType = @"关闭";
 break;
 case ResultPayInHand:
 payType = @"处理中";
 break;
 case ResultPayPending:
 payType = @"待支付";
 */
#pragma mark ---支付回调
- (void)payJudgeViewSucceedFinishPayWithPayType:(NSString *)payType
{
    
    if (![_dumplinguserputmoneyid isEqualToString:@""]) {
        if ([payType isEqualToString:@"成功"] || [payType isEqualToString:@"处理中"]) {
        //包饺子成功页面回调
                    BaoJiaoSuccectController *baoVC = [[BaoJiaoSuccectController alloc]init];
                    baoVC.tempDe = 1;
                    baoVC.dumplinguserputmoneyid = _dumplinguserputmoneyid;
                    [self.navigationController pushViewController:baoVC animated:YES];
    }
    else if ([payType isEqualToString:@"待支付"]){
    
    [self showHint:@"待支付了,请稍等" yOffset:-100];
    
    }else if ([payType isEqualToString:@"失败"]){
        
    [self showHint:@"挤爆了,请稍等" yOffset:-100];
        
    }else if ([payType isEqualToString:@"关闭"]){
        
    [self showHint:@"关闭了,请稍等" yOffset:-100];
        
    }else{
        
    [self showHint:@"错误了,请稍等" yOffset:-100];
    
    }
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.payJudgeView.hidden = YES;
}

#pragma mark - 代理方法实现
- (void)payJudgeViewSucceedFinishWithPassWord:(NSString *)passWord
{
    NSLog(@"VC  ---  passWord  %@",passWord);
}
- (void)topUpJudgeViewSucceedFinishWithTopUpType:(PayType)topUpType payTypeModel:(CJTopUpPayModel *)payTypeModel
{
    self.payModel = payTypeModel;
    [self goToPayWithBalanceType:topUpType];
}

#pragma mark --点击textfiled回调
- (void)panDuanTag:(UITextField*)textField{
    //个数
    if (textField.tag==100) {
        
        ZHLog(@"111---%@",textField.text);
        
     
            _perGeShu = textField.text;
        
    }else if (textField.tag==101){
    //价钱
        _priceDesFle = textField.text;
        ZHLog(@"222---%@",textField.text);
        if (textField.text.length<1) {
         _baseShuChuView.zhiFuView.pricelabel.text = @"￥0.00";
        }else{
           _baseShuChuView.zhiFuView.pricelabel.text = [NSString stringWithFormat:@"￥%@",textField.text];}
}
    
}
#pragma mark --点击textView
- (void)textViewGie:(UITextView*)textVIew{
     //留言
    ZHLog(@"%@",textVIew.text);
    if ([textVIew.text isEqualToString:@""]||[textVIew.text isEqual:[NSNull null]]|| textVIew.text==nil) {
    _textWenBen = @"新年快乐,恭喜发财!";
    }else{
    _textWenBen = textVIew.text;
    }
}

/**
 *  判断是否遮挡键盘
 */
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self registerForKeyboardNotifications];
}
- (void)registerForKeyboardNotifications

{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}
// Called when the UIKeyboardDidShowNotification is sent.

- (void)keyboardWasShown:(NSNotification*)aNotification

{
   
   // if ([_baseShuChuView.bumView.textTlike isFirstResponder] ) {
        
 
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
       NSLog(@"%f-",kbSize.height);
    _baseShuChuView.contentInset = contentInsets;
    
    _baseShuChuView.scrollIndicatorInsets = contentInsets;
    
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    
    // Your application might not need or want this behavior.
    
    CGRect aRect =  _baseShuChuView.frame;
    aRect.size.height -= kbSize.height;
    NSInteger trGao = (kkViewHeight -kbSize.height) - (_baseShuChuView.bumView.frame.origin.y+64 +_baseShuChuView.bumView.frame.size.height+36);
   NSLog(@"%f-----+%d",kbSize.height,trGao);
   if (trGao<0 &&[_baseShuChuView.bumView.textTlike isFirstResponder]) {
    
        CGPoint scrollPoint = CGPointMake(0.0, -trGao);//
     //   NSLog(@"%f",_baseShuChuView.bumView.frame.size.height-kbSize.height);
        [_baseShuChuView setContentOffset:scrollPoint animated:YES];
        
    }
  // }
}
// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    _baseShuChuView.contentInset = contentInsets;
    
    _baseShuChuView.scrollIndicatorInsets = contentInsets;
    
    
}

/**
 *
 * 以下为钱包添加的方法
 *   
 */
#if 1


/** 跳转各支付方式 */
- (void)goToPayWithBalanceType:(PayType)balanceType
{
    [self jumpPayTypeWithPayType:balanceType];
}

#pragma mark - 支付
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
            //            self.topUpBtn.enabled = YES;
        }
        NSLog(@"%@",json);
    } failure:^(NSError *error) {
        [self chrysanthemumClosed];
        //        self.topUpBtn.enabled = YES;
    } noNet:^{
        [self chrysanthemumClosed];
        //        self.topUpBtn.enabled = YES;
    }];
    
}


/** 跳转不同的支付方式 */
- (void)jumpPayTypeWithPayType:(PayType)payType
{
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
                [self showMsg:@"请先安装微信客户端"];
                //                self.topUpBtn.enabled = YES;
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
//                [self requestSucceedJudge];
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
//        if (self.resultPayType != ResultPaySucceed) {
            [self succeedJumpToVC];
            //            self.topUpBtn.enabled = YES;
//        }
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
//        [self requestSucceedJudge];
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
//    if (self.resultPayType != ResultPaySucceed) {
        [self succeedJumpToVC];
        //        payJudgeView.topUpBtn.enabled = YES;
//    }
}
//U付 回调
- (void)onPayResult:(NSString *)orderId resultCode:(NSString *)resultCode resultMessage:(NSString *)resultMessage
{
    
    if ([resultCode isEqualToString:@"0000"]) {
        self.resultPayType = ResultPaySucceed;
//        [self requestSucceedJudge];
    }else{
        self.resultPayType = ResultPayPending;
    }
//    if (self.resultPayType != ResultPaySucceed) {
        [self succeedJumpToVC];
        //        self.topUpBtn.enabled = YES;
//    }
}

/** 成功后跳转 */
- (void)succeedJumpToVC
{
    
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:WeiXinWalletNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"judgePayStatu" object:nil];
    
#warning 需要写回调方法
    NSString *payType;
    switch (self.resultPayType) {
        case ResultPayFailure:
            payType = @"失败";
            break;
        case ResultPaySucceed:
            payType = @"成功";
            break;
        case ResultPayClose:
            payType = @"关闭";
            break;
        case ResultPayInHand:
            payType = @"处理中";
            break;
        case ResultPayPending:
            payType = @"待支付";
            break;
            
        default:
            break;
    }
    [self payJudgeViewSucceedFinishPayWithPayType:payType];
    
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

#endif

- (void)dealloc
{
    [self chrysanthemumClosed];
}


@end
