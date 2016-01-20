//
//  CJNotSufficientFundsView.m
//  Wallet
//
//  Created by zhaochunjing on 15-10-28.
//  Copyright (c) 2015年 Sinoglobal. All rights reserved.
//

#import "CJNotSufficientFundsView.h"
#import "GDHMyWalletModel.h"
//#import <AlipaySDK/AlipaySDK.h>

static Wallet_BaseViewController *selfController = nil;


@interface CJNotSufficientFundsView ()
{
    /** 记录支付方式的之前按钮 */
    UIButton *_oldBtn;
    
}

/** 支付宝选中图片 */
@property (weak, nonatomic) IBOutlet UIImageView *zhiFuImage;
/** 微信支付选中图片 */
@property (weak, nonatomic) IBOutlet UIImageView *weiXinImage;
/** 借记卡选中图片 */
@property (weak, nonatomic) IBOutlet UIImageView *jieJiImage;
/** 余额选中图片 */
@property (weak, nonatomic) IBOutlet UIImageView *balanceImage;

/** 弹出页的子页（支付方式页） */
@property (weak, nonatomic) IBOutlet UIView *jumpSubView;
/** 余额不足 */
@property (weak, nonatomic) IBOutlet UILabel *balanceDeficiencyLabel;
/** 余额name */
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
/** 余额的按钮 */
@property (weak, nonatomic) IBOutlet UIButton *balanceBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *balanceViewH;

@property (nonatomic, copy) NSString *requestStr;
@property (nonatomic,assign) BalanceViewType balanceViewTypeTemp;//
/** 判断是否请求过密码错误次数 */
@property (nonatomic,assign) BOOL requestPasswordNum;

/** 支付方式的点击状态事件 */
- (IBAction)zhiFuTypeClick:(UIButton *)sender;
- (IBAction)zhiFuBtnClick;

@end

@implementation CJNotSufficientFundsView

static CJNotSufficientFundsView *sharedView = nil;

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"judgePayStatu" object:nil];
}

/** 单例对象 */
+ (CJNotSufficientFundsView *)sharedViewWithController:(Wallet_BaseViewController *)controller andRequestStr:(NSString *)request
{
    
    selfController = controller;
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        sharedView = [[[NSBundle mainBundle] loadNibNamed:@"CJNotSufficientFundsView" owner:self options:nil] lastObject];
        CGRect frame = sharedView.jumpSubView.frame;
        frame.origin.y = ScreenHeight;
        sharedView.jumpSubView.frame = frame;
        sharedView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        CGRect frameSelf = sharedView.frame;
        frameSelf.size.width = ScreenWidth;
        frameSelf.size.height = ScreenHeight;
        sharedView.frame = frameSelf;
        sharedView.hidden = YES;
        sharedView.balanceBtn.enabled = NO;
        sharedView.balanceDeficiencyLabel.hidden = NO;
        sharedView.requestStr = request;
        sharedView.balanceViewTypeTemp = BalanceViewTypeNoRecord;
    });
//    [sharedView request110PassWordErrNum];
    return sharedView;
}
- (instancetype)initWithFrame:(CGRect)frame withController:(Wallet_BaseViewController *)controller andRequestStr:(NSString *)request
{
    selfController = controller;
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CJNotSufficientFundsView" owner:self options:nil] lastObject];
        
        CGRect frame1 = self.jumpSubView.frame;
        frame1.origin.y = frame.size.height;
        self.jumpSubView.frame = frame1;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        CGRect frameSelf = self.frame;
        frameSelf.size.width = ScreenWidth;
        frameSelf.size.height = frame.size.height;
        self.frame = frameSelf;
        
        self.hidden = YES;
        self.balanceBtn.enabled = NO;
        self.balanceDeficiencyLabel.hidden = NO;
        self.requestStr = request;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgePayStatu) name:@"judgePayStatu" object:nil];
        
        self.balanceViewTypeTemp = BalanceViewTypeNoRecord;
//        [self request110PassWordErrNum];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.frame = CGRectMake(0, 0, ScreenWidth, self.frame.size.height);
}

- (void)setBalanceHidden:(BOOL)balanceHidden
{
    _balanceHidden = balanceHidden;
    if (balanceHidden) {
        self.balanceViewH.constant = 0;
    }
}
- (void)setBalanceStr:(NSString *)balanceStr
{
    _balanceStr = balanceStr;
    self.balanceLabel.text = [NSString stringWithFormat:@"账户余额（剩余%@元）",balanceStr];
    [self setCashStr:self.cashStr];
}
- (void)setCashStr:(NSString *)cashStr
{
    _cashStr = cashStr;
    if ([cashStr floatValue] > [self.balanceStr floatValue]) {
        if (self.balanceViewTypeTemp != BalanceViewTypeNoBalance) {
            [self notSufficientFundsViewType:BalanceViewTypeNoBalance];
            self.balanceViewTypeTemp = BalanceViewTypeNoBalance;
        }
    } else {
        if (self.balanceViewTypeTemp != BalanceViewTypeHaveBalance) {
            [self notSufficientFundsViewType:BalanceViewTypeHaveBalance];
            self.balanceViewTypeTemp = BalanceViewTypeHaveBalance;
        }
//        else if (self.balanceViewTypeTemp != BalanceViewTypeClosebalance) {
            if (self.requestPasswordNum) {
                self.requestPasswordNum = NO;
            } else {
                [self request110PassWordErrNum];
            }
//        }
    }
}

/** 展示没有余额的弹出界面 */
- (void)showNotSufficientFundsView
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.jumpSubView.frame;
        if (self.balanceHidden) {
            frame.origin.y = self.frame.size.height - 207;
        } else {
            frame.origin.y = self.frame.size.height - 249;
        }
        self.jumpSubView.frame = frame;
        self.hidden = NO;
    }];
}

/** 隐藏弹出界面 */
- (void)hiddenNotSufficientFundsView
{
    [selfController chrysanthemumClosed];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.jumpSubView.frame;
        frame.origin.y = self.frame.size.height ;
        self.jumpSubView.frame = frame;

    } completion:^(BOOL finished) {
        self.hidden = YES;
        if ([self.delegate respondsToSelector:@selector(notSufficientFundsViewHiddenEvent)]) {
            [self.delegate notSufficientFundsViewHiddenEvent];
        }
    }] ;
}
/** 选择充值支付类型的状态 balanceViewType余额是否充足 */
- (void)notSufficientFundsViewType:(BalanceViewType)balanceViewType
{
    
//    self.balanceBtn.enabled = YES;
//    self.balanceDeficiencyLabel.hidden = YES;
//    self.balanceLabel.textColor = [UIColor colorWithRed:34.0 / 255.0 green:34.0 / 255.0 blue:34.0 / 255.0 alpha:1.00f];
    
    switch (balanceViewType) {
        case BalanceViewTypeNoBalance:
            self.balanceBtn.enabled = NO;
            self.balanceDeficiencyLabel.hidden = NO;
            self.balanceDeficiencyLabel.text = @"不足";
//            self.balanceImage.hidden = YES;
//            self.zhiFuImage.hidden = NO;
            _oldBtn = (UIButton *)[self viewWithTag:100];
//            _oldBtn.titleLabel.text = @"支付宝";
            self.balanceLabel.textColor = [UIColor colorWithRed:158.0 / 255.0 green:158.0 / 255.0 blue:158.0 / 255.0 alpha:1];
            break;
        case BalanceViewTypeHaveBalance:
            self.balanceBtn.enabled = YES;
            self.balanceDeficiencyLabel.hidden = YES;
//            self.balanceImage.hidden = NO;
            _oldBtn = (UIButton *)[self viewWithTag:3];
//            _oldBtn.titleLabel.text = @"账户余额";
            self.balanceLabel.textColor = [UIColor colorWithRed:34.0 / 255.0 green:34.0 / 255.0 blue:34.0 / 255.0 alpha:1.00f];
            break;
        case BalanceViewTypeClosebalance:
            self.balanceBtn.enabled = NO;
            self.balanceDeficiencyLabel.hidden = NO;
            self.balanceDeficiencyLabel.text = @"锁定";
//            self.balanceImage.hidden = YES;
//            self.zhiFuImage.hidden = NO;
            _oldBtn = (UIButton *)[self viewWithTag:100];
//            _oldBtn.titleLabel.text = @"支付宝";
            self.balanceLabel.textColor = [UIColor colorWithRed:158.0 / 255.0 green:158.0 / 255.0 blue:158.0 / 255.0 alpha:1];
            break;
            
        default:
            break;
    }
    [self zhiFuTypeClick:_oldBtn];
}


- (IBAction)zhiFuTypeClick:(UIButton *)sender {
    self.zhiFuImage.hidden = YES;
    self.weiXinImage.hidden = YES;
    self.jieJiImage.hidden = YES;
    self.balanceImage.hidden = YES;
    switch (sender.tag) {
        case 100:
        {
            self.zhiFuImage.hidden = NO;
            sender.titleLabel.text = @"支付宝";
        }
            break;
        case 1:
        {
            self.weiXinImage.hidden = NO;
            sender.titleLabel.text = @"微信支付";
        }
            break;
        case 2:
        {
            self.jieJiImage.hidden = NO;
            sender.titleLabel.text = @"借记卡";
        }
            break;
        case 3:
        {
            self.balanceImage.hidden = NO;
            sender.titleLabel.text = @"账户余额";
        }
            break;
            
        default:
            break;
    }
        _oldBtn = sender;
    
}

/** 去支付 */
- (IBAction)zhiFuBtnClick {
    
    //隐藏弹出页
    [self hiddenNotSufficientFundsView];
    if (_oldBtn.tag != 3) {
        self.superview.hidden = YES;
    }
    self.blookBtnClick(_oldBtn);
    
    switch (_oldBtn.tag) {
        case 100:
        {
            //支付宝
            
            //需要在请求里面写
//            [[AlipaySDK defaultService] payOrder:self.requestStr fromScheme:ZHIFUBAOAPPSCHEME callback:^(NSDictionary *resultDic) {
            
                //                commitModel.payStatu = resultDic[@"resultStatus"];
                [self judgePayStatu];
//            }];
            
        }
            
            break;
        case 1:
            //微信
            break;
        case 2:
            //U支
            break;
        case 3:
            //余额
            break;

            
        default:
            break;
    }
}

-(void)judgePayStatu
{
//    ZXYPaySuccessViewController *paySuccessVC = [[ZXYPaySuccessViewController alloc] init];
//    
//    if ([commitModel.payStatu integerValue] == 9000) {
//        paySuccessVC.goodsInfo = self.goodsInfo;
//        [self.navigationController pushViewController:paySuccessVC animated:YES];
//    }else if ([commitModel.payStatu integerValue] == 6001) {
//        [self showMsg:@"取消支付"];
//    }else if ([commitModel.payStatu integerValue] == 4000) {
//        [self showMsg:@"支付失败"];
//    }else if ([commitModel.payStatu integerValue] == 6002) {
//        [self showMsg:@"取消支付"];
//    }else{
//        [self showMsg:@"支付失败，请重试"];
//    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hiddenNotSufficientFundsView];
    self.superview.hidden = YES;
}


/** 请求密码输入错误次数 */
- (void)request110PassWordErrNum {
    NSDictionary *dict = [WalletRequsetHttp WalletPersonPassWordErrorNum110];
    NSString *url = [NSString stringWithFormat:@"%@%@",WalletHttp_getPassWordErrorNum110,[dict JSONFragment]];
    [SINOAFNetWorking postWithBaseURL:url controller:selfController success:^(id json) {
//        [self hiddenNotSufficientFundsView];
        [selfController chrysanthemumClosed];
        self.requestPasswordNum = YES;
        if ([json[@"errCount"] intValue] >= 5) {
            if (self.balanceViewTypeTemp != BalanceViewTypeClosebalance) {
                [self notSufficientFundsViewType:BalanceViewTypeClosebalance];
                self.balanceViewTypeTemp = BalanceViewTypeClosebalance;
            }
            return ;
        }else {
        }
        
    } failure:^(NSError *error) {
        //        [self hiddenNotSufficientFundsView];
        [selfController chrysanthemumClosed];
        [selfController showMsg:ShowMessage];
    } noNet:^{
        //        [self hiddenNotSufficientFundsView];
        [selfController chrysanthemumClosed];
    }];
}


@end
