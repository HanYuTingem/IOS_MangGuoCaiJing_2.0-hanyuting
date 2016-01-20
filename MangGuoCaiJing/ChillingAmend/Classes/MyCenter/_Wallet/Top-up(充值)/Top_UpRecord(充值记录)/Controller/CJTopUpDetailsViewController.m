//
//  CJTopUpDetailsViewController.m
//  GongYong
//
//  Created by zhaochunjing on 15-12-15.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "CJTopUpDetailsViewController.h"
#import "mineWalletViewController.h"
#import "CJTopUpdetailCell.h"
#import "WXApi.h"
#import "WXUtil.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Umpay.h"
#import "UmpayElements.h"
#import "CJTopUpRecordViewController.h"
#import "CJTopUpViewController.h"

#define CELLH 42
#define CELLID @"detailCell"



@interface CJTopUpDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,WXApiDelegate,UmpayDelegate>

@property (weak, nonatomic) IBOutlet UITableView *topUpDetailsTableview;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@property (nonatomic, strong) NSMutableArray *cellModelArray;
/** 支付宝的对调结果 */
@property (nonatomic, strong) NSDictionary *resultDic;
/** 返回的结果 */
@property (nonatomic, assign) ResultPay resultPayType;

@property (nonatomic, strong) UIImageView *IV;
@property (nonatomic, strong) UILabel *headLabel;
/** 待充值的标题语（微信的） */
@property (nonatomic, copy) NSString *strTitle;

- (IBAction)finishBtnClick:(UIButton *)sender;

@end

@implementation CJTopUpDetailsViewController

- (NSMutableArray *)cellModelArray
{
    if (!_cellModelArray) {
        _cellModelArray = [NSMutableArray array];
    }
    return _cellModelArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //微信、支付宝、U付 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinGoBack:) name:WeiXinWalletNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePayStatu:) name:@"judgePayStatu" object:nil];
    
    if (_topUpDetailsModel.orderSn.length) {
        self.payModel = _topUpDetailsModel.backJson;
    }
    
    [self makeInitView];
    [self makeFinishData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.finishBtn.enabled = YES;
    [self chrysanthemumClosed];
}

- (void)makeFinishData
{
    if (_topUpDetailsModel.orderSn.length) {
        switch ([_topUpDetailsModel.payStatus intValue]) {
            case 1:
                [self.finishBtn setTitle:@"返回" forState:UIControlStateNormal];
                break;
            case 2:
                [self.finishBtn setTitle:@"返回" forState:UIControlStateNormal];
                break;
            case 4:
                [self.finishBtn setTitle:@"返回" forState:UIControlStateNormal];
                self.topUpDetailsTableview.tableFooterView = [self makeFootViewWithTitle:@"充值申请成功，将于2小时内到账"];
                break;
            case 3:
                [self.finishBtn setTitle:@"去支付" forState:UIControlStateNormal];
                if (self.strTitle.length) {
                    self.topUpDetailsTableview.tableFooterView = [self makeFootViewWithTitle:self.strTitle];
                } else {
                    self.topUpDetailsTableview.tableFooterView = [self makeFootViewWithTitle:@"24小时未付款，将关闭此订单"];
                }
                break;
            case 5:
                [self.finishBtn setTitle:@"返回" forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
    } else if (_topUpModel.tradeSn.length) {
        switch (self.paytypeTopUp) {
            case ResultPayFailure:
                [self.finishBtn setTitle:@"重试" forState:UIControlStateNormal];
                self.topUpDetailsTableview.tableHeaderView = [self makeHeadViewWithResultPayType:ResultPayFailure];
                break;
            case ResultPaySucceed:
                [self.finishBtn setTitle:@"完成" forState:UIControlStateNormal];
                self.topUpDetailsTableview.tableHeaderView = [self makeHeadViewWithResultPayType:ResultPaySucceed];
                break;
            case ResultPayInHand:
                [self.finishBtn setTitle:@"返回" forState:UIControlStateNormal];
                self.topUpDetailsTableview.tableHeaderView = [self makeHeadViewWithResultPayType:ResultPayInHand];
                break;
            case ResultPayPending:
                [self.finishBtn setTitle:@"去支付" forState:UIControlStateNormal];
                self.topUpDetailsTableview.tableHeaderView = [self makeHeadViewWithResultPayType:ResultPayPending];
                break;
                
            default:
                break;
        }
    }
    
}
/** 添加脚标题 */
- (UIView *)makeFootViewWithTitle:(NSString *)title
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    footView.backgroundColor = [UIColor clearColor];
    
    UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 200, 30)];
    footLabel.font = [UIFont systemFontOfSize:12];
    footLabel.backgroundColor = [UIColor clearColor];
    footLabel.textAlignment = NSTextAlignmentLeft;
    footLabel.textColor = [UIColor colorWithRed:0.33f green:0.33f blue:0.33f alpha:1.00f];
    footLabel.text = title;
    
    [footView addSubview:footLabel];
    return footView;
}
/** 添加头标题 */
- (UIView *)makeHeadViewWithResultPayType:(ResultPay)resultPayType
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIImageView *IV = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 62) * 0.5, 44, 62, 62)];
    IV.backgroundColor = [UIColor clearColor];
    [headView addSubview:IV];
    self.IV = IV;
    
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(IV.frame) + 14, ScreenWidth, 30)];
    headLabel.font = [UIFont systemFontOfSize:15];
    headLabel.backgroundColor = [UIColor clearColor];
    headLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:headLabel];
    self.headLabel = headLabel;
    
    [self judgeHeadViewTypeResultPayType:resultPayType];
    
    return headView;
}
- (void)judgeHeadViewTypeResultPayType:(ResultPay)resultPayType
{
    switch (resultPayType) {
        case ResultPayFailure:
            _IV.image = [UIImage imageNamed:@"CJ-iconfont-shibai"];
            _headLabel.text = @"充值失败，请重试！";
            _headLabel.textColor = [UIColor colorWithRed:0.84f green:0.18f blue:0.13f alpha:1.00f];
            break;
        case ResultPaySucceed:
            _IV.image = [UIImage imageNamed:@"CJ-iconfont-weibiaoti5"];
            _headLabel.text = @"充值成功！";
            _headLabel.textColor = [UIColor colorWithRed:0.09f green:0.56f blue:0.22f alpha:1.00f];
            break;
        case ResultPayInHand:
            _IV.image = [UIImage imageNamed:@"CJ-iconfont-dingDanYiTiJiao"];
            _headLabel.text = @"提交成功！";
            _headLabel.textColor = [UIColor colorWithRed:0.09f green:0.56f blue:0.22f alpha:1.00f];
            break;
        case ResultPayPending:
            _IV.image = [UIImage imageNamed:@"CJ-iconfont-jinggao"];
            _headLabel.text = @"待充值！";
            _headLabel.textColor = [UIColor colorWithRed:0.95f green:0.60f blue:0.00f alpha:1.00f];
            break;
            
        default:
            break;
    }
}

/** 初始化界面 */
- (void)makeInitView
{
    self.view.backgroundColor = WalletHomeBackGRD;
    self.mallTitleLabel.text = @"充值";
    
    self.finishBtn.layer.masksToBounds = YES;
    self.finishBtn.layer.cornerRadius = 5;
    
    self.topUpDetailsTableview.allowsSelection = NO;
    self.topUpDetailsTableview.scrollEnabled = NO;
    self.topUpDetailsTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.topUpDetailsTableview registerNib:[UINib nibWithNibName:@"CJTopUpdetailCell" bundle:nil] forCellReuseIdentifier:CELLID];
}

/** 充值记录来的模型 */
- (void)setTopUpDetailsModel:(CJTopUpModel *)topUpDetailsModel
{
    _topUpDetailsModel = topUpDetailsModel;
    CJTopUpCellModel *cashModel = [[CJTopUpCellModel alloc] init];
    cashModel.name = @"充值金额：";
    cashModel.content = [NSString stringWithFormat:@"%@元",[self addMoneyZeroWithMoneyText:[NSString stringWithFormat:@"%@",topUpDetailsModel.amount]]];
    [self.cellModelArray addObject:cashModel];
    
    CJTopUpCellModel *timeModel = [[CJTopUpCellModel alloc] init];
    timeModel.name = @"时间：";
    timeModel.content = [WalletRequsetHttp WalletTimeDateFormatterWithStr:topUpDetailsModel.createDate];
    [self.cellModelArray addObject:timeModel];
    
    CJTopUpCellModel *businessModel = [[CJTopUpCellModel alloc] init];
    businessModel.name = @"交易单号：";
    businessModel.content = topUpDetailsModel.orderSn;
    [self.cellModelArray addObject:businessModel];
    
    CJTopUpCellModel *payTypeModel = [[CJTopUpCellModel alloc] init];
    payTypeModel.name = @"支付方式：";
    switch ([topUpDetailsModel.payType intValue]) {
        case 1:
            payTypeModel.content = @"钱包";
            break;
        case 2:
            payTypeModel.content = @"支付宝";
            break;
        case 3:
            payTypeModel.content = @"借记卡";
            break;
        case 4:
            payTypeModel.content = @"微信";
            self.strTitle = @"2小时未付款，将关闭此订单";
            break;
        default:
            break;
        }
    
    [self.cellModelArray addObject:payTypeModel];
    
    CJTopUpCellModel *statusModel = [[CJTopUpCellModel alloc] init];
    statusModel.name = @"状态：";
    switch ([topUpDetailsModel.payStatus intValue]) {
        case 1:
            statusModel.content = @"成功";
            [self.finishBtn setTitle:@"返回" forState:UIControlStateNormal];
            break;
        case 2:
            statusModel.content = @"失败";
            [self.finishBtn setTitle:@"返回" forState:UIControlStateNormal];
            break;
        case 3:
            statusModel.content = @"待充值";
            [self.finishBtn setTitle:@"去充值" forState:UIControlStateNormal];
            break;
        case 4:
            statusModel.content = @"充值中";
            [self.finishBtn setTitle:@"返回" forState:UIControlStateNormal];
            break;
        case 5:
            statusModel.content = @"已关闭";
            [self.finishBtn setTitle:@"返回" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    [self.cellModelArray addObject:statusModel];
    
}
/** 充值后传来的数据 */
- (void)setTopUpModel:(CJTopUpModel *)topUpModel
{
    if (topUpModel.orderSn.length) {
        switch ([topUpModel.payType intValue]) {
            case 1:
                topUpModel.payType = [NSString stringWithFormat:@"%d",PayTypeWallet];
                break;
            case 2:
                topUpModel.payType = [NSString stringWithFormat:@"%d",PayTypeZhiFuBao];
                break;
            case 3:
                topUpModel.payType = [NSString stringWithFormat:@"%d",PayTypeUFu];
                break;
            case 4:
                topUpModel.payType = [NSString stringWithFormat:@"%d",PayTypeWeiXin];
                break;
                
            default:
                break;
        }
    }
    _topUpModel = topUpModel;
    CJTopUpCellModel *cashModel = [[CJTopUpCellModel alloc] init];
    cashModel.name = @"充值金额：";
    cashModel.content = [NSString stringWithFormat:@"%@元",[self addMoneyZeroWithMoneyText:[NSString stringWithFormat:@"%@",topUpModel.amount]]];
    [self.cellModelArray addObject:cashModel];
    
    CJTopUpCellModel *payTypeModel = [[CJTopUpCellModel alloc] init];
    payTypeModel.name = @"支付方式：";
    switch ([topUpModel.payType intValue]) {
        case PayTypeZhiFuBao:
            payTypeModel.content = @"支付宝";
            break;
        case PayTypeWeiXin:
            payTypeModel.content = @"微信";
            break;
        case PayTypeUFu:
            payTypeModel.content = @"借记卡";
            break;
        default:
            break;
    }
    
    [self.cellModelArray addObject:payTypeModel];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELLH;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellModelArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CJTopUpdetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    cell.cellModel = self.cellModelArray[indexPath.row];
    if (self.cellModelArray.count == 2) {
        cell.contentLocation = ContentLocationRight;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

/** 金额末尾是否需要添加0 */
- (NSString *)addMoneyZeroWithMoneyText:(NSString *)moneyText
{
    NSArray *array = [moneyText componentsSeparatedByString:@"."];
    NSMutableString *text = [NSMutableString stringWithString:moneyText];
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

/** 按钮的点击事件 */
- (IBAction)finishBtnClick:(UIButton *)sender {
    NSLog(@"--- %@ ----  %@",self.finishBtn.titleLabel.text,sender.titleLabel.text);
    if ([self.finishBtn.titleLabel.text isEqualToString:@"返回"]) {
//        [self.navigationController popViewControllerAnimated:YES];
        [self backButtonClick];
    }else if ([sender.titleLabel.text isEqualToString:@"完成"]) {
//        [self poptoWalletHomeControllet];
        [self backButtonClick];
    } else if ([sender.titleLabel.text isEqualToString:@"去支付"] || [sender.titleLabel.text isEqualToString:@"重试"]) {
    
        int payTypeInt;
        if (self.topUpDetailsModel.orderSn.length) {//充值记录
            payTypeInt = [self.topUpDetailsModel.payType intValue];
        } else {//充值页面
            payTypeInt = [self.topUpModel.payType intValue];
        }
        [self requsetDataWithPayType:payTypeInt];
//        [self jumpPayTypeWithPayType:payTypeInt];
    }
}

//返回按钮
-(void)backButtonClick{
//    if ([self.finishBtn.titleLabel.text isEqualToString:@"完成"]) {
        if ([self.comeHereStr isEqualToString:@"充值记录"]) {//充值记录
            [self poptoWalletRecordViewControllet];
        } else {//充值页面
            [self poptoWalletHomeControllet];
        }
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

/** 返回记录页面 */
-(void)poptoWalletRecordViewControllet{
    NSArray  * viewControls= self.navigationController.viewControllers;
    for (UIViewController * viewControl  in viewControls){
        if([viewControl isKindOfClass:[CJTopUpRecordViewController class]]){
            [self.navigationController popToViewController:viewControl animated:YES];
            return;
        }
    }
}

/** 返回充值页面 */
-(void)poptoWalletCJTopUpViewController{
    NSArray  * viewControls= self.navigationController.viewControllers;
    for (UIViewController * viewControl  in viewControls){
        if([viewControl isKindOfClass:[CJTopUpViewController class]]){
            [self.navigationController popToViewController:viewControl animated:YES];
            return;
        }
    }
}

/** 返回首页 */
-(void)poptoWalletHomeControllet{
    NSArray  * viewControls= self.navigationController.viewControllers;
    for (UIViewController * viewControl  in viewControls){
        if([viewControl isKindOfClass:[mineWalletViewController class]]){
            [self.navigationController popToViewController:viewControl animated:YES];
            return;
        }
    }
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
        }
        NSLog(@"%@",json);
    } failure:^(NSError *error) {
        [self chrysanthemumClosed];
    } noNet:^{
        [self chrysanthemumClosed];
    }];
    
}

- (void)requsetDataWithPayType:(PayType)payType
{
    
    int payTypeInt = payType;
NSString *urlStr = payTypeInt == PayTypeZhiFuBao ? WalletHttp_alipayRequest10001 : payTypeInt == PayTypeWeiXin ? WalletHttp_wechatpayRequest10002 : WalletHttp_ufpayRequest10003;
    NSString *amount = self.topUpDetailsModel.amount.length != 0 ? self.topUpDetailsModel.amount : self.topUpModel.amount;
NSDictionary *dict = [WalletRequsetHttp WalletPersonPayRequest10000WithAmount:amount paySource:@"wallet" goodName:@"钱包" goodDepice:@"钱包充值" modelId:@"1" orderSn:_payModel.trade_sn];
NSString *url = [NSString stringWithFormat:@"%@%@",urlStr,[dict JSONFragment]];

[self chrysanthemumOpen];
[SINOAFNetWorking postWithBaseURL:url controller:self success:^(id json){
    [self chrysanthemumClosed];
    NSLog(@"充值 --- %@",json);
    NSLog(@"-- %@ --",json[@"msg"]);
    //        NSDictionary *dict  = [json[@"rs"] JSONValue];
    //        NSLog(@"%@",dict);
    
    
    if ([json[@"code"] intValue] == 101) {
        [self showMsg:@"网络状态不佳，请重试！"];
        return ;
    } else if ([json[@"code"] intValue] == 100) {
        _payModel = [[CJTopUpPayModel alloc] initWithDict:json[@"rs"]];
        [self jumpPayTypeWithPayType:payType];
        return;
    }
    
    
} failure:^(NSError *error) {
    [self chrysanthemumClosed];
} noNet:^{
    [self chrysanthemumClosed];
}];
}


/** 跳转不同的支付方式 */
- (void)jumpPayTypeWithPayType:(PayType)payType
{
    self.finishBtn.enabled = YES;
    int payTypeInt = payType;
    
//    if (_topUpDetailsModel.orderSn.length) {
//        self.payModel = _topUpDetailsModel.backJson;
//        if (!self.payModel.trade_sn.length) {
////            [self showMsg:@"此订单数据错误"];
//            [self requsetDataWithPayType:payType];
//            return;
//        }
//    }
    
    
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
        [self showMsg:@"正在处理中"];
    }else{
//        [self showMsg:@"支付失败，请重试"];
        self.resultPayType = ResultPayFailure;
    }
    if (self.resultPayType != ResultPaySucceed) {
        [self succeedJumpToVC];
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
        self.finishBtn.enabled = YES;
    }
}

/** 成功后跳转 */
- (void)succeedJumpToVC
{
    if (self.topUpDetailsModel.orderSn.length) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:WeiXinWalletNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"judgePayStatu" object:nil];
        
        CJTopUpDetailsViewController *VC = [[CJTopUpDetailsViewController alloc] init];
        VC.paytypeTopUp = self.resultPayType;
        VC.comeHereStr = self.comeHereStr;
        CJTopUpModel *topUpModel = [[CJTopUpModel alloc] init];
        topUpModel.amount = self.topUpDetailsModel.amount;
        topUpModel.payType = self.topUpDetailsModel.payType;
        topUpModel.tradeSn = self.topUpDetailsModel.orderSn;
        topUpModel.orderSn = self.topUpDetailsModel.orderSn;
        VC.topUpModel = topUpModel;
        VC.payModel = self.topUpDetailsModel.backJson;
        [self.navigationController pushViewController:VC animated:YES];
        
    } else {
        self.paytypeTopUp = self.resultPayType;
        [self makeFinishData];
        [self judgeHeadViewTypeResultPayType:self.paytypeTopUp];
    }
    
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

- (void)dealloc
{
    [self chrysanthemumClosed];
}

@end
