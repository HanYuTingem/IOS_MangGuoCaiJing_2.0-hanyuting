//
//  CJWithdrawDepositInfoViewController.m
//  Wallet
//
//  Created by zhaochunjing on 15-10-23.
//  Copyright (c) 2015年 Sinoglobal. All rights reserved.
//

#import "CJWithdrawDepositInfoViewController.h"
#import "mineWalletViewController.h"

@interface CJWithdrawDepositInfoViewController ()
/** 银行卡的名字label */
@property (weak, nonatomic) IBOutlet UILabel *bankCardNameLabel;
/** 价格label */
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
/** 完成按钮 */
@property (weak, nonatomic) IBOutlet UIButton *finshBtn;
/** 完成按钮的点击事件 */
- (IBAction)finshBtnClick:(UIButton *)sender;

/** 银行卡View的Y值 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardViewY;
@property (weak, nonatomic) IBOutlet UILabel *moneyName;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeName;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;

/** 实际到账View */
@property (weak, nonatomic) IBOutlet UIView *actualAccountView;
/** 实际到账的金额label */
@property (weak, nonatomic) IBOutlet UILabel *actualAccountLabel;
/** 到账时间展示Label距离提现金额的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showLabelYH;

/*****************************************   二期增加后改   ****************************************/

/** 到账日期的显示 */
@property (weak, nonatomic) IBOutlet UILabel *showDateLabel;

@end

@implementation CJWithdrawDepositInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化界面
    [self makeInitView];
}

/** 初始化界面 */
- (void)makeInitView
{
    //    self.backView.backgroundColor = WalletHomeNAVGRD;
    //    self.mallTitleLabel.textColor = WalletHomeNAVTitleColor;
    //    self.mallTitleLabel.font = WalletHomeNAVTitleFont;
    //    [self.leftBackButton setImage:[UIImage imageNamed:@"title_btn_back"] forState:UIControlStateNormal];
    
    self.showDateLabel.text = [NSString stringWithFormat:@"提现申请成功！将在%@",self.txTemplate3];
    
    if (self.cardType.length) {
        self.mallTitleLabel.text = @"充值详情";
        self.cardViewY.constant += 80;
        self.showLabel.hidden = YES;
        self.cardTypeName.text = @"支付方式";
        self.moneyName.text = @"充值金额";
        self.bankCardNameLabel.text = self.cardType;
        self.moneyLabel.text = self.moneyCash;
        
        UILabel *typeLabel = [[UILabel alloc] init];
        typeLabel.bounds = CGRectMake(0, 0, 150, 30);
        typeLabel.center = CGPointMake(ScreenWidth * 0.5, 100);
        //        typeLabel.font = [UIFont systemFontOfSize:15];
        typeLabel.font = [UIFont boldSystemFontOfSize:15];
        typeLabel.text = @"支付成功！";
        [self.view addSubview:typeLabel];
        
    } else {
        self.mallTitleLabel.text = @"提现详情";
        self.bankCardNameLabel.text = self.bankCardName;
        NSString *moneyStr = [self.moneyCash stringByReplacingOccurrencesOfString:@"元" withString:@""];
        if ([self.fees floatValue] > 0) {
            self.moneyLabel.text = [NSString stringWithFormat:@"%.2f元 (扣除手续费%.2f元)",[self.moneyCash floatValue],[self.fees floatValue]];
            self.actualAccountLabel.text = [NSString stringWithFormat:@"%.2f元",[moneyStr floatValue] - [self.fees floatValue]];
        } else {
            self.moneyLabel.textColor = [UIColor colorWithRed:0.84f green:0.18f blue:0.13f alpha:1.00f];
            self.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[self.moneyCash floatValue]];
            self.showLabelYH.constant = 10;
            [self.actualAccountView removeFromSuperview];
        }
    }
    
    self.finshBtn.layer.cornerRadius = 5;
    self.finshBtn.layer.masksToBounds = YES;
    
}

- (void)backButtonClick
{
    [self poptoWalletHomeControllet];
}

- (IBAction)finshBtnClick:(UIButton *)sender {
    [self poptoWalletHomeControllet];
}

@end
