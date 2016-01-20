//
//  CJPayJudgeView.m
//  Wallet
//
//  Created by zhaochunjing on 15-11-11.
//  Copyright (c) 2015年 Sinoglobal. All rights reserved.
//

#import "CJPayJudgeView.h"
#import "GDHInputPassWordView.h"
#import "GDHTitleView.h"
#import "Wallet_BaseViewController.h"
#import "GDHSetPassWordViewController.h"
#import "CJNotSufficientFundsView.h"
#import "GDHMyWalletModel.h"
#import "SecurityUtil.h"

#import "WXApi.h"
#import "WXUtil.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Umpay.h"
#import "UmpayElements.h"
#import "SecurityUtil.h"
#define X  (ScreenWidth - 270)/2


static CJPayJudgeView *payJudgeView = nil;
static Wallet_BaseViewController *selfController = nil;
/** 密码提示的次数  */
static int number = 5;


@interface CJPayJudgeView ()<CJNotSufficientFundsViewDelegate,WXApiDelegate,UmpayDelegate>
{
    /** 记录支付方式的之前按钮 */
    UIButton *_oldBtn;
    /** 选中状态时的位置 */
    NSIndexPath *_selecteIndexPath;
    /** 记录上一次的出现.的字符串 */
    NSString *_oldTextFieldText;
    
    
    UIButton *btn;
}

/** 请输入密码视图 */
@property(nonatomic,strong)GDHInputPassWordView *InputPassWordView;
/**  请输入密码 蒙版按钮 */
@property(nonatomic,strong)UIButton *inputButton;

/** 是否取消支付 */
@property(nonatomic,strong)GDHTitleView *CancelTitleView;
/** 是否取消支付 */
@property(nonatomic,strong)UIButton  *ifCancelPayButton;
/** 请输入支付密码 */
@property(nonatomic,strong)UILabel  *payPassWordLabel;

/** 请求 验证支付密码后的次数 */
@property (nonatomic, copy) NSString *num;
/** 用来接收 moneyText 或者 moneyTextField 的值 */
@property (nonatomic, copy) NSString *tempStr;
/** 余额 首页传入  本业提现完成请求 的数据 */
@property (nonatomic, copy) NSString *balance;

/** 支付方式的View */
@property (nonatomic, strong) CJNotSufficientFundsView *notView;



/** 全局的支付加密串 请求模型 */
@property (nonatomic, strong) CJTopUpPayModel *payModel;
/** 支付宝的对调结果 */
@property (nonatomic, strong) NSDictionary *resultDic;
/** 返回的结果 */
@property (nonatomic, assign) ResultPay resultPayType;
/** 验证成功后的  支付密码 */
@property (nonatomic, copy) NSString *putInPassWordStr;
/** 加密串的Key */
@property (nonatomic, copy) NSString *tradeId;

/** 记录支付方式 */
@property (nonatomic, assign) PayType payTypeResult;

/** 输入密码的相关页面的Y值坐标 */
@property (nonatomic, assign) CGFloat passWordY;



/** 弹出页（蒙板） */
@property (weak, nonatomic) IBOutlet UIView *jumpView;
/** 提示框 超出额度的提示框 */
@property (weak, nonatomic) IBOutlet UIView *reminderView;
/** 提示框的文字提示 */
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
/** 提示框确定按钮的文字 */
@property (weak, nonatomic) IBOutlet UIButton *reminderBtn;

/** 提示框的确定按钮的点击事件 */
- (IBAction)reminderBtnClick:(UIButton *)sender;

@end

@implementation CJPayJudgeView

+ (CJPayJudgeView *)shareCJPayJudgeViewWithController:(Wallet_BaseViewController *)controller withRequestStr:(NSString *)requestStr
{
    selfController = controller;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        payJudgeView = [[[NSBundle mainBundle] loadNibNamed:@"CJPayJudgeView" owner:payJudgeView options:nil] lastObject];
        CGRect frame = payJudgeView.frame;
        frame.size.height = ScreenHeight ;
        frame.size.width = ScreenWidth;
//        frame.origin.y = 64;
        payJudgeView.frame = frame;
        
        if (ScreenHeight < 568) {
            payJudgeView.passWordY = 20;
        } else {
            payJudgeView.passWordY = 110 * WalletSP_height;
        }
        
        [payJudgeView addSubview:payJudgeView.ifCancelPayButton];
        [payJudgeView addSubview:payJudgeView.inputButton];
        
        [payJudgeView makeTitle];
        // 初始化界面
        [payJudgeView makeInitView];
    });
//    //微信、支付宝、U付 通知
//    [[NSNotificationCenter defaultCenter] addObserver:selfController selector:@selector(weixinGoBack:) name:WeiXinWalletNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:selfController selector:@selector(judgePayStatu:) name:@"judgePayStatu" object:nil];
    return payJudgeView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

/** 初始化界面 */
- (void)makeInitView
{
    
    payJudgeView.jumpView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    //设置提示框的圆角
    payJudgeView.reminderView.layer.masksToBounds = YES;
    payJudgeView.reminderView.layer.cornerRadius = 3;
    
    //余额不足弹出框
    payJudgeView.notView = [[CJNotSufficientFundsView alloc] initWithFrame:payJudgeView.frame withController:selfController andRequestStr:@""];
    payJudgeView.notView.delegate = payJudgeView;
    
    __weak CJPayJudgeView *weakSelf = payJudgeView;
    payJudgeView.notView.blookBtnClick = ^(UIButton *balanceTypeBtn){
        DHLog(@" %ld",(long)balanceTypeBtn.tag);
        NSLog(@"%@",balanceTypeBtn.titleLabel.text);
        [weakSelf goToPayWithBalanceType:balanceTypeBtn.titleLabel.text];
        
    };
    [payJudgeView addSubview:payJudgeView.notView];
//    [payJudgeView request1001AccountBalance];
}

/** 跳转各支付方式 */
- (void)goToPayWithBalanceType:(NSString *)balanceType
{
    if ([balanceType isEqualToString:@"账户余额"]) {
        payJudgeView.payTypeResult = PayTypeWallet;
        [payJudgeView requestPassWordResultErrorNum110];
        NSLog(@"11111 账户余额");
        return;
    } else if ([balanceType isEqualToString:@"支付宝"]){
        payJudgeView.payTypeResult = PayTypeZhiFuBao;
        [payJudgeView downloadn:@"2"];
        NSLog(@"22222 支付宝");
        
    } else if ([balanceType isEqualToString:@"微信支付"]){
        payJudgeView.payTypeResult = PayTypeWeiXin;
        [payJudgeView downloadn:@"4"];
        NSLog(@"3333 微信支付");
    } else if ([balanceType isEqualToString:@"借记卡"]){
        payJudgeView.payTypeResult = PayTypeUFu;
        [payJudgeView downloadn:@"3"];
        NSLog(@"4444 借记卡");
    }

}

/** 密钥网络请求 */
- (void)passWorldKeyWithFinish:(void(^)(NSString *encryptKey,NSString * ID))passWorldKey
{
    
    NSLog(@"%@",WalletHttp_getPassWordKey120);
    [selfController chrysanthemumOpen];
    [SINOAFNetWorking postWithBaseURL:[NSString stringWithFormat:@"%@",WalletHttp_getPassWordKey120] controller:selfController success:^(id json) {
        passWorldKey(json[@"encryptKey"],json[@"id"]);
    } failure:^(NSError *error) {
        [selfController chrysanthemumClosed];
        [selfController showMsg:ShowMessage];
    } noNet:^{
        [selfController chrysanthemumClosed];
    }];
}

// 支付类型* 1.余额、2支付宝、3U付、4微信
- (void)downloadn:(NSString*)index {
    [selfController chrysanthemumOpen];
  
    __block NSString *URL;
    if([index isEqualToString:@"1"]){
      
//
      [LYLAFNetWorking postWithBaseURL:WalletHttp_getPassWordKey120 success:^(id json) {
            
            if (json) {
                NSLog(@"json-----%@",json);
                
                NSDictionary *dict = [LYLHttpTool payForChuodseWeesMeney:payJudgeView.requestStr andWithPaychnel:index andWithPassword:payJudgeView.putInPassWordStr];
                NSString *jsonStr = [NSString stringWithFormat:@"%@",[dict JSONFragment]];
                
                NSString *enconding = [SecurityUtil URLencryptAESData:jsonStr andPublicPassWord:json[@"encryptKey"]];
                
                
                
                URL = [NSString stringWithFormat:@"%@%@?json=%@&tradeId=%@",URL_LYL_PayChas,LYL_PayForWake,enconding,json[@"id"]];
                [self getUrlMkele:URL andWishIndex:index];
                
                
            }
        } failure:^(NSError *error) {
              [selfController chrysanthemumClosed];
            [selfController showMsg:@"挤爆了,请稍等"];
        }];
    }else
    {
        [LYLAFNetWorking postWithBaseURL:WalletHttp_getPassWordKey120 success:^(id json) {
            
            if (json) {
                NSLog(@"json-----%@",json);
                
                NSDictionary *dict = [LYLHttpTool payFeiForwweMeney:payJudgeView.requestStr andWithPaychnel:index];
                NSString *jsonStr = [NSString stringWithFormat:@"%@",[dict JSONFragment]];
                
                NSString *enconding = [SecurityUtil URLencryptAESData:jsonStr andPublicPassWord:json[@"encryptKey"]];
                
                
                URL = [NSString stringWithFormat:@"%@%@?json=%@&tradeId=%@",URL_LYL_PayChas,LYL_PayForWake,enconding,json[@"id"]];
                [self getUrlMkele:URL andWishIndex:index];
     
                
            }
        } failure:^(NSError *error) {
              [selfController chrysanthemumClosed];
            [selfController showMsg:@"挤爆了,请稍等"];
        }];
        
        
        
    }
    
    
    NSLog(@"URL++++++%@",URL);
    
}
/**
 * 支付请求
 */
- (void)getUrlMkele:(NSString*)url andWishIndex:(NSString*)index {

    [LYLAFNetWorking getWithBaseURL:url success:^(id json) {
        ZHLog(@"%@",json);
        NSLog(@"-----%@",json[@"message"]);
        [self maekelsdsdZhiStyle:json andWithIndex:index];
        [selfController chrysanthemumClosed];
    }
    failure:^(NSError *error) {
         [selfController showMsg:@"挤爆了,请稍等"];                       
        ZHLog(@"%@",error);
        [selfController chrysanthemumClosed];
                                
    }];

}



//处理4种网络请求,网络回调,
-(void)maekelsdsdZhiStyle:(id)json andWithIndex:(NSString*)index{

    
    if ([index integerValue] == 1){//余额支付
        
        if ([json[@"code"] intValue] == 101) {
            payJudgeView.resultPayType = ResultPayFailure;
        } else if ([json[@"code"] intValue] == 100) {
            payJudgeView.resultPayType = ResultPaySucceed;
        }
        [payJudgeView succeedJumpToVC];
    
    }else {
        if ([json[@"code"] intValue] == 101) {
            //            [self showMsg:ShowNoMessage];
            //            self.topUpBtn.enabled = YES;
            return ;
        } else if ([json[@"code"] intValue] == 100) {
            _payModel = [[CJTopUpPayModel alloc] initWithDict:json[@"resultList"]];
            //代理回调
            if ([payJudgeView.delegate respondsToSelector:@selector(topUpJudgeViewSucceedFinishWithTopUpType:payTypeModel:)]) {
                [payJudgeView.delegate topUpJudgeViewSucceedFinishWithTopUpType:payJudgeView.payTypeResult payTypeModel:_payModel];
            }
            return;
        }
    }
    
}


#if 0

#pragma mark - 支付
/** 回调成功后再次请求支付是否成功 */
- (void)requestSucceedJudge
{
    NSDictionary *dict = [WalletRequsetHttp WalletPersonSucceedJudgeRequest10010WithOrderSn:_payModel.trade_sn];
    NSString *url = [NSString stringWithFormat:@"%@%@",WalletHttp_succeedJudgeRequest10010,[dict JSONFragment]];
    [selfController chrysanthemumOpen];
    [SINOAFNetWorking postWithBaseURL:url controller:selfController success:^(id json) {
        [selfController chrysanthemumClosed];
        if ([json[@"code"] intValue] == 100) {
            if ([json[@"rs"] intValue] == 3) {
                payJudgeView.resultPayType = ResultPaySucceed;
            } else {
                payJudgeView.resultPayType = ResultPayInHand;
            }
            [self succeedJumpToVC];
            //            self.topUpBtn.enabled = YES;
        }
        NSLog(@"%@",json);
    } failure:^(NSError *error) {
        [selfController chrysanthemumClosed];
        //        self.topUpBtn.enabled = YES;
    } noNet:^{
        [selfController chrysanthemumClosed];
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
                payJudgeView.resultDic = [NSDictionary dictionaryWithDictionary:resultDic];
                [self judgePayStatu];
            }];
        }
            break;
        case PayTypeWeiXin:
            //跳转微信
        {
            if (![WXApi isWXAppInstalled]) {
                [selfController showMsg:@"请先安装微信客户端"];
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
            
            [Umpay pay:[NSString stringWithFormat:@"%@",_payModel.trade_no] merCustId:@"GoodStudy" shortBankName:@"" cardType:@"0" payDic:inPayInfo rootViewController:selfController delegate:self];
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
                payJudgeView.resultPayType = ResultPaySucceed;
                [payJudgeView requestSucceedJudge];
            }
                break;
            case WXErrCodeCommon:
            { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                
                NSLog(@"支付结果: 失败!");
                payJudgeView.resultPayType = ResultPayFailure;
            }
                break;
            case WXErrCodeUserCancel:
            { //用户点击取消并返回
                payJudgeView.resultPayType = ResultPayPending;
            }
                break;
            case WXErrCodeSentFail:
            { //发送失败
                NSLog(@"发送失败");
                payJudgeView.resultPayType = ResultPayFailure;
            }
                break;
            case WXErrCodeUnsupport:
            { //微信不支持
                NSLog(@"微信不支持");
                payJudgeView.resultPayType = ResultPayPending;
            }
                break;
            case WXErrCodeAuthDeny:
            { //授权失败
                NSLog(@"授权失败");
                payJudgeView.resultPayType = ResultPayPending;
            }
                break;
            default:
                break;
        }
        if (payJudgeView.resultPayType != ResultPaySucceed) {
            [payJudgeView succeedJumpToVC];
            //            self.topUpBtn.enabled = YES;
        }
        //------------------------
    }
}

//支付宝
- (void)judgePayStatu:(NSNotification *)info
{
    payJudgeView.resultDic = [info userInfo][@"resultDic"];
    [payJudgeView judgePayStatu];
}
//支付宝回调
-(void)judgePayStatu
{
    
    if ([payJudgeView.resultDic[@"resultStatus"] integerValue] == 9000) {
        payJudgeView.resultPayType = ResultPaySucceed;
        [payJudgeView requestSucceedJudge];
    }else if ([payJudgeView.resultDic[@"resultStatus"] integerValue] == 6001) {
        payJudgeView.resultPayType = ResultPayPending;
        [selfController showMsg:@"取消支付"];
    }else if ([payJudgeView.resultDic[@"resultStatus"] integerValue] == 4000) {
        payJudgeView.resultPayType = ResultPayFailure;
        [selfController showMsg:@"支付失败"];
    }else if ([payJudgeView.resultDic[@"resultStatus"] integerValue] == 6002) {
        payJudgeView.resultPayType = ResultPayPending;
        [selfController showMsg:@"取消支付"];
    }else if ([payJudgeView.resultDic[@"resultStatus"] integerValue] == 8000) {
        payJudgeView.resultPayType = ResultPayInHand;
        [selfController showMsg:@"正在处理中"];
    }else{
        [selfController showMsg:@"支付失败，请重试"];
        payJudgeView.resultPayType = ResultPayFailure;
    }
    if (payJudgeView.resultPayType != ResultPaySucceed) {
        [payJudgeView succeedJumpToVC];
        //        payJudgeView.topUpBtn.enabled = YES;
    }
}
//U付 回调
- (void)onPayResult:(NSString *)orderId resultCode:(NSString *)resultCode resultMessage:(NSString *)resultMessage
{
    
    if ([resultCode isEqualToString:@"0000"]) {
        payJudgeView.resultPayType = ResultPaySucceed;
        [payJudgeView requestSucceedJudge];
    }else{
        payJudgeView.resultPayType = ResultPayPending;
    }
    if (payJudgeView.resultPayType != ResultPaySucceed) {
        [payJudgeView succeedJumpToVC];
        //        self.topUpBtn.enabled = YES;
    }
}

/** 成功后跳转 */
- (void)succeedJumpToVC
{
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:WeiXinWalletNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"judgePayStatu" object:nil];
    
#warning 需要写回调方法
    NSString *payType;
    switch (payJudgeView.resultPayType) {
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
    if ([payJudgeView.delegate respondsToSelector:@selector(payJudgeViewSucceedFinishPayWithPayType:)]) {
        [payJudgeView.delegate payJudgeViewSucceedFinishPayWithPayType:payType];
    }
    
//    payJudgeView.resultPayType;
    
    //    self.succeedLabel.hidden = YES;
    //    CJTopUpDetailsViewController *VC = [[CJTopUpDetailsViewController alloc] init];
    //    VC.paytypeTopUp = self.resultPayType;
    //    CJTopUpModel *topUpModel = [[CJTopUpModel alloc] init];
    //    topUpModel.amount = self.moneyTextField.text;
    //    topUpModel.payType = [NSString stringWithFormat:@"%zd",_oldBtn.tag];
    //    topUpModel.tradeSn = _payModel.trade_sn;
    //    VC.topUpModel = topUpModel;
    //    VC.payModel = _payModel;
    //    [self.navigationController pushViewController:VC animated:YES];
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


/** 成功后跳转 */
- (void)succeedJumpToVC
{
    
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:WeiXinWalletNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"judgePayStatu" object:nil];
    
#warning 需要写回调方法
    NSString *payType;
    switch (payJudgeView.resultPayType) {
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
    if ([payJudgeView.delegate respondsToSelector:@selector(payJudgeViewSucceedFinishPayWithPayType:)]) {
        [payJudgeView.delegate payJudgeViewSucceedFinishPayWithPayType:payType];
    }
    
    //    payJudgeView.resultPayType;
    
    //    self.succeedLabel.hidden = YES;
    //    CJTopUpDetailsViewController *VC = [[CJTopUpDetailsViewController alloc] init];
    //    VC.paytypeTopUp = self.resultPayType;
    //    CJTopUpModel *topUpModel = [[CJTopUpModel alloc] init];
    //    topUpModel.amount = self.moneyTextField.text;
    //    topUpModel.payType = [NSString stringWithFormat:@"%zd",_oldBtn.tag];
    //    topUpModel.tradeSn = _payModel.trade_sn;
    //    VC.topUpModel = topUpModel;
    //    VC.payModel = _payModel;
    //    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark -支付类型页面的代理方法实现
- (void)notSufficientFundsViewHiddenEvent
{
//    [payJudgeView hiddenReminderView];
}

#pragma mark - 弹出界面
/** 隐藏提示框 */
- (void)hiddenReminderView
{
    [UIView animateWithDuration:0.5 animations:^{
        payJudgeView.reminderView.hidden = YES;
        payJudgeView.jumpView.hidden = YES;
        payJudgeView.hidden = YES;
        [payJudgeView endEditing:YES];
        [selfController chrysanthemumClosed];
    }];
}
/** 显示提示框 0表示超出最高提现金额 1表示超出余额 2表示不允许输入密码的提示 */
- (void)showReminderViewType:(int)type
{
    payJudgeView.reminderBtn.titleLabel.text = @"确定";
    if (!type) {
        payJudgeView.reminderLabel.text = [NSString stringWithFormat:@"单笔提现金额限%d，请重新输入金额",MaxMoney];
    } else if (type == 1) {
        payJudgeView.reminderLabel.text = @"输入的金额已超出余额数";
    } else if (type == 2) {
        payJudgeView.reminderLabel.text = @"您今日密码输入次数超限，密码被锁定，请于2小时后再尝试。";
        payJudgeView.reminderBtn.titleLabel.text = @"返回";
        payJudgeView.inputButton.hidden = YES;
        if (_moneyTextField) {
            payJudgeView.moneyTextField.text = @"";
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        payJudgeView.reminderView.hidden = NO;
        payJudgeView.jumpView.hidden = NO;
    }];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [payJudgeView endEditing:YES];
}

#pragma mark - TextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    payJudgeView.tempStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
    [payJudgeView infoAction];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (payJudgeView.moneyTextField.text.length) {
        NSMutableString *str = [NSMutableString stringWithString:payJudgeView.moneyTextField.text];
        payJudgeView.tempStr = [str stringByReplacingOccurrencesOfString:@"元" withString:@""];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([payJudgeView.moneyTextField.text isEqualToString:@""]) {
        return;
    }
    if ([payJudgeView.moneyTextField.text floatValue] <= 0) {
        payJudgeView.moneyTextField.text = @"";
        [selfController showMsg:@"提现最低为0.01元"];
        return;
    }
    
    //判断是否超出最高限额
    if ([payJudgeView.moneyTextField.text floatValue] > MaxMoney) {
        [payJudgeView showReminderViewType:0];
        return;
    } else if ([payJudgeView.moneyTextField.text floatValue] > [payJudgeView.balance floatValue]) {//判断是否超出余额
        [payJudgeView showReminderViewType:1];
    }
    if (payJudgeView.moneyTextField.text.length) {//后面添加 元
    }
}

- (void)setMoneyText:(NSString *)moneyText
{
    _moneyText = moneyText;
    payJudgeView.notView.cashStr = moneyText;
}
- (void)setRequestStr:(NSString *)requestStr
{
    _requestStr = requestStr;
}

/** textField的监听事件 */
- (void)infoAction
{
    if (payJudgeView.tempStr.length == 2 && ![[payJudgeView.tempStr substringFromIndex:1] isEqualToString:@"."] && [payJudgeView.tempStr intValue] < 10) {
        payJudgeView.moneyTextField.text = @"";
        [selfController showMsg:@"请输入正确的金额"];
        [payJudgeView hiddenReminderView];
        return;
    }
    NSArray *array = [payJudgeView.tempStr componentsSeparatedByString:@"."];
    if (array.count == 2) {
        NSString *textStr = array[1];
        if (textStr.length > 2) {
            payJudgeView.tempStr = _oldTextFieldText;
            //            [self showMsg:@"最小金额为分"];
        }
        _oldTextFieldText = payJudgeView.tempStr;
    } else if (array.count == 3) {
        payJudgeView.moneyTextField.text = _oldTextFieldText;
        [selfController showMsg:@"请输入正确的金额"];
        
        [payJudgeView hiddenReminderView];
        return;
    }
    if ([payJudgeView.tempStr floatValue] > [payJudgeView.balance floatValue]) {
        payJudgeView.moneyTextField.text = @"";
        [selfController showMsg:@"输入的金额已超出余额数"];
        [payJudgeView hiddenReminderView];
        return;
    }
}

- (void)setMoneyTextField:(UITextField *)moneyTextField
{
    _moneyTextField = moneyTextField;
}

/** 金额末尾是否需要添加0 */
- (NSString *)addMoneyZeroWithMoneyText:(NSString *)moneyText
{
    NSArray *array = [moneyText componentsSeparatedByString:@"."];
    NSMutableString *text = [NSMutableString stringWithString:payJudgeView.tempStr];
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
/** 按钮的点击事件 逻辑判断入口 */
- (void)toCashBtnClick {
    
    //    self.yuanLabel.hidden = YES;
    if (!_moneyTextField) {
        payJudgeView.tempStr = payJudgeView.moneyText;
    }
    NSString *moneyStr = [payJudgeView.tempStr stringByReplacingOccurrencesOfString:@"元" withString:@""];
    
    if ([moneyStr floatValue] <= 0) {
        [selfController showMsg:@"请输入金额"];
        [payJudgeView hiddenReminderView];
        return;
    }
    moneyStr = [payJudgeView addMoneyZeroWithMoneyText:moneyStr];

    //判断支付 跳转支付宝 钱包等
    if (!_moneyTextField) {
//        //判断钱包状态
//        if ([payJudgeView.tempStr floatValue] > [payJudgeView.balance floatValue]) {
//            [_notView notSufficientFundsViewType:BalanceViewTypeNoBalance];
//            [selfController showMsg:@"输入的金额已超出余额数"];
//        } else {
//            [_notView notSufficientFundsViewType:BalanceViewTypeHaveBalance];
////            [payJudgeView hiddenReminderView];
        //        }
        [payJudgeView request1001AccountBalance];
        [_notView showNotSufficientFundsView];
    } else { //提现的判断
        [payJudgeView requestPassWordResultErrorNum110];
    }
    
}

#pragma mark - 网络请求
/** 判断密码是否正确 */
- (void)requestPassWordResultErrorNum110
{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    id hasPass = [userD objectForKey:HasPassWord];

    if (![hasPass isEqual:@"Y"]) {
        btn.hidden = NO;
        return;
    } else {//密码次数判断
        NSDictionary *dict = [WalletRequsetHttp WalletPersonPassWordErrorNum110];
        NSString *url = [NSString stringWithFormat:@"%@%@",WalletHttp_getPassWordErrorNum110,[dict JSONFragment]];
        [selfController chrysanthemumOpen];
        [SINOAFNetWorking postWithBaseURL:url controller:selfController success:^(id json) {
            [selfController chrysanthemumClosed];
            if ([json[@"errCount"] intValue] >= 5) {
                [payJudgeView showReminderViewType:2];
                return ;
            }else {
//                [self addSubview:payJudgeView.inputButton];
                payJudgeView.inputButton.hidden = NO;
                [_InputPassWordView theKeyboardShow];
                _InputPassWordView.payMoney = [NSString stringWithFormat:@"¥%@",payJudgeView.tempStr];
            }
            
        } failure:^(NSError *error) {
            [payJudgeView hiddenReminderView];
            [selfController showMsg:ShowMessage];
        } noNet:^{
            [payJudgeView hiddenReminderView];
        }];
        
    }
}

/** 密码验证 的网络请求 */
- (void)passWordVerifyWithPutInPassWord:(NSString *)putInPassWord encryptKey:(NSString *)encryptKey ID:(NSString *)ID
{
        NSDictionary *dict = [WalletRequsetHttp WalletPersonVerificationPayPassWord1004VerifyPassword:putInPassWord];
        //加密
        NSData *data = [SecurityUtil encryptAESData:[dict JSONFragment] andPublicPassWord:encryptKey];
        NSString *base64 = [SecurityUtil encodeBase64Data:data];
        
        NSString *url = [NSString stringWithFormat:@"%@%@&&tradeId=%@",WalletHttp_checkPassword1004,[WalletRequsetHttp encodeString:base64],ID];
    
    payJudgeView.putInPassWordStr = putInPassWord;
        
        [selfController chrysanthemumOpen];
        [SINOAFNetWorking postWithBaseURL:url controller:selfController success:^(id json) {
            NSLog(@"----- json %@",json);
            if ([json[@"code"] isEqualToString:@"100"]) {
                payJudgeView.payPassWordLabel.hidden = YES;
                payJudgeView.num = [NSString stringWithFormat:@"%@",json[@"num"]];
                //密钥的请求
//                [WalletRequsetHttp getKeyVC:selfController andKey:^(NSString *key, NSString *theID) {
                    [payJudgeView requestDataWithPutInPassWord:putInPassWord encryptKey:@"" ID:@""];
//                }];     
                payJudgeView.inputButton.hidden = YES;
                [payJudgeView.InputPassWordView clearTextPassWordWithOneTextFiledEnabled:YES];
                [payJudgeView hiddenReminderView];
//                return ;
            } else if ([json[@"code"] isEqualToString:@"102"]) {
                payJudgeView.num = [NSString stringWithFormat:@"%@",json[@"num"]];
                [payJudgeView showNumberPassWord];
                if (number - [payJudgeView.num intValue]) {
                    [selfController showMsg:json[@"msg"]];
                }
            } else if ([json[@"code"] isEqualToString:@"101"]) {
                [selfController showMsg:json[@"msg"]];
            }
            [selfController chrysanthemumClosed];
            [_InputPassWordView clearTextPassWordWithOneTextFiledEnabled:YES];
        } failure:^(NSError *error) {
            [payJudgeView hiddenReminderView];
            [selfController showMsg:ShowMessage];
            [_InputPassWordView clearTextPassWordWithOneTextFiledEnabled:YES];
        } noNet:^{
            [payJudgeView hiddenReminderView];
            [_InputPassWordView clearTextPassWordWithOneTextFiledEnabled:YES];
        }];

}


/** 钱包个人中心账户余额1001 接口 */
-(void)request1001AccountBalance{
    [selfController chrysanthemumOpen];
    
    NSDictionary *dict  = [WalletRequsetHttp WalletPersonAccountBalance1001];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",WalletHttp_Balance,[dict JSONFragment]];
    [SINOAFNetWorking postWithBaseURL:url controller:selfController success:^(id json) {
        [selfController chrysanthemumClosed];
        NSDictionary *dict = json;
        if ([dict[@"code"] isEqualToString:@"100"]) {
            GDHMyWalletModel *walletModel = [[GDHMyWalletModel alloc] initWithDic:dict[@"rs"]];
            NSUserDefaults *userD =[NSUserDefaults standardUserDefaults];
            [userD setObject:walletModel.isHasPass forKey:HasPassWord];
            [userD synchronize];
            payJudgeView.balance = walletModel.balance;
            payJudgeView.notView.balanceStr = walletModel.balance;
        }else{
            NSLog(@"%@",dict[@"msg"]);
        }
//        [payJudgeView hiddenReminderView];
        
    } failure:^(NSError *error) {
        [payJudgeView hiddenReminderView];
        [selfController showMsg:ShowMessage];
    } noNet:^{
        [payJudgeView hiddenReminderView];
    }];
}

#pragma mark - 网络完成的回调 钱包余额支付
/** 网络请求数据 putInPassWord 输入的密码  */
- (void)requestDataWithPutInPassWord:(NSString *)putInPassWord encryptKey:(NSString *)encryptKey ID:(NSString *)ID
{
    payJudgeView.putInPassWordStr = putInPassWord;
    [payJudgeView downloadn:@"1"];
    
    if ([payJudgeView.delegate respondsToSelector:@selector(payJudgeViewSucceedFinishWithPassWord:encryptKey:ID:)]) {
        [payJudgeView.delegate payJudgeViewSucceedFinishWithPassWord:putInPassWord encryptKey:encryptKey ID:ID];
    }
}



/** 密码输入不正确的显示 */
- (void)showNumberPassWord
{
    payJudgeView.payPassWordLabel.hidden = NO;
    int num = number - [payJudgeView.num intValue];
    payJudgeView.payPassWordLabel.text = [NSString stringWithFormat:@"支付密码输入不正确，您还有%d次机会",num];
    if (num) {
        [payJudgeView.InputPassWordView clearTextPassWordWithOneTextFiledEnabled:YES];
        [_InputPassWordView theKeyboardShow];
    } else {
        [payJudgeView.InputPassWordView clearTextPassWordWithOneTextFiledEnabled:NO];
    }
    if (num == 0) {
        [payJudgeView showReminderViewType:2];
    }
}



/** 提示框的确定按钮的点击事件 */
- (IBAction)reminderBtnClick:(UIButton *)sender {
    
    if (_moneyTextField) {
        _moneyTextField.text = @"";
    }
    [payJudgeView hiddenReminderView];
}



#pragma  mark - 设置您的支付密码
-(void)makeTitle{
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
    btn.backgroundColor = RGBACOLOR(83, 83, 83, .7);
    btn.hidden = YES;
    GDHTitleView *titleView = [[GDHTitleView alloc] initWithFrame:CGRectMake(X, payJudgeView.passWordY, 270, 147) andMessage:@"您还没有设置支付密码，为了保障您的财产安全，请设置支付密码" andleftButtonTitle:@"等一下" andRightButtonTitle:@"去设置"];
    titleView.layer.masksToBounds= YES;
    titleView.layer.cornerRadius = 3;
    titleView.CancelButtonBlock = ^(UIButton *CancelButton){
        btn.hidden = YES;
        [payJudgeView hiddenReminderView];
        /** 等一下 */
    };
    titleView.ReleaseBoundBlock = ^(UIButton *ReleaseBound){
        /** 去设置*/
        GDHSetPassWordViewController *setPassWord = [[GDHSetPassWordViewController alloc] init];
        setPassWord.LYLPushtoSetpassWord = @"捞一捞页面push过来";
        
        [selfController.navigationController pushViewController:setPassWord animated:YES];
        btn.hidden = YES;
        [payJudgeView hiddenReminderView];
    };
    [btn addSubview:titleView];
    [btn addTarget:payJudgeView action:@selector(btnDownHidden:) forControlEvents:UIControlEventTouchUpInside];
    [payJudgeView addSubview:btn];
    
}
/**  隐藏 密码设置的蒙版 */
-(void)btnDownHidden:(UIButton *)sender{
    btn.hidden = YES;
    payJudgeView.hidden = YES;
    [self hiddenReminderView];
    NSLog(@"取消隐藏");
}

#pragma   mark - 请输入按钮视图
-(GDHInputPassWordView *)InputPassWordView{
    if (!_InputPassWordView) {
        _InputPassWordView = [[GDHInputPassWordView alloc] initWithFrame:CGRectMake((ScreenWidth - 270)*0.5, payJudgeView.passWordY, 270, 170) andPayMoney:payJudgeView.tempStr];
        _InputPassWordView.layer.masksToBounds = YES;
        _InputPassWordView.layer.cornerRadius = 2;
        _InputPassWordView.backgroundColor =[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f];
        __weak CJPayJudgeView *weekSelf = payJudgeView;
        _InputPassWordView.closeBlock =^(UIButton *close){
            weekSelf.ifCancelPayButton.hidden = NO;
            weekSelf.inputButton .hidden=  YES;
            /** 关闭 */
        };
        _InputPassWordView.findBlock = ^(UIButton *findPassWord){
            GDHSetPassWordViewController *setPassWord = [[GDHSetPassWordViewController alloc] init];
            setPassWord.findPassWord = @"找回密码";
            [selfController.navigationController pushViewController:setPassWord animated:YES];
            
            
            /** 找回密码 */
        };
        _InputPassWordView.payPassWordBlock = ^(NSString *payPassWordSting){
            [weekSelf endEditing:YES];
            NSLog(@"payPassWordSting:  %@",payPassWordSting);
            //                [weekSelf requestDataWithPutInPassWord:payPassWordSting];
            //密钥的请求
            [WalletRequsetHttp getKeyVC:selfController andKey:^(NSString *key, NSString *theID) {
                [weekSelf passWordVerifyWithPutInPassWord:payPassWordSting encryptKey:key ID:theID];
            }];
            
            
        };
    }
    return _InputPassWordView;
}

/** 蒙版 */
-(UIButton *)inputButton{
    
    if (!_inputButton) {
        _inputButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _inputButton.frame = CGRectMake(0, 65, ScreenWidth, ScreenHeight -65);
        _inputButton.hidden = YES;
        [_inputButton addTarget:payJudgeView action:@selector(inputButtonDown) forControlEvents:UIControlEventTouchUpInside];
        _inputButton.backgroundColor = payMask;
        [_inputButton addSubview:payJudgeView.payPassWordLabel];
        [_inputButton addSubview:payJudgeView.InputPassWordView];
    }
    return _inputButton;
}
-(UILabel *)payPassWordLabel{
    if (!_payPassWordLabel) {
        _payPassWordLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 75, ScreenWidth - 80, 20)];
        _payPassWordLabel.font = [UIFont systemFontOfSize:14];
        _payPassWordLabel.textAlignment = NSTextAlignmentCenter;
        _payPassWordLabel.hidden = YES;
        _payPassWordLabel.textColor = [UIColor colorWithRed:1.00f green:0.51f blue:0.04f alpha:1.00f];
    }
    return _payPassWordLabel;
}

#pragma mark - 是否取消支付提示
-(UIButton *)ifCancelPayButton{
    
    if (!_ifCancelPayButton) {
        _ifCancelPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ifCancelPayButton.frame = CGRectMake(0, 65, ScreenWidth, ScreenHeight - 64);
        _ifCancelPayButton.backgroundColor = payMask;
        _ifCancelPayButton.hidden = YES;
        [_ifCancelPayButton addTarget:payJudgeView action:@selector(ifCancelPayButtonDown:) forControlEvents:UIControlEventTouchUpInside];
        [_ifCancelPayButton addSubview:payJudgeView.CancelTitleView];
    }
    return _ifCancelPayButton;
}



/** 是否取消支付 */
-(GDHTitleView *)CancelTitleView{
    if (!_CancelTitleView) {
        
        _CancelTitleView = [[GDHTitleView alloc] initWithFrame:CGRectMake(X, payJudgeView.passWordY, 270, 124) andMessage:@"是否取消支付？ " andleftButtonTitle:@"是" andRightButtonTitle:@"否"];
        __weak CJPayJudgeView *weekSelf = payJudgeView;
        _CancelTitleView.CancelButtonBlock = ^(UIButton *CancelButton){
            [weekSelf endEditing:YES];
            weekSelf.ifCancelPayButton.hidden = YES;
            [weekSelf hiddenReminderView];
            [weekSelf.InputPassWordView clearTextPassWordWithOneTextFiledEnabled:YES];
            // 是
            /**  不删除  */
            //            [weekSelf.navigationController popViewControllerAnimated:YES];
            NSLog(@"  取消-------------  支付，");
        };
        _CancelTitleView.ReleaseBoundBlock = ^(UIButton *ReleaseBound){
            // 否
            weekSelf.ifCancelPayButton.hidden = YES;
            weekSelf.inputButton.hidden = NO;
        };
    }
    return _CancelTitleView;
}
/**  取消支付的  蒙版 */
-(void)ifCancelPayButtonDown:(UIButton *)ifCancelPayButtonDown{
    
    //    _ifCancelPayButton.hidden = YES;
}

/**  隐藏 支付（请输入）的蒙版 */
-(void)inputButtonDown{
    
    //    _inputButton.hidden = YES;
}






@end
