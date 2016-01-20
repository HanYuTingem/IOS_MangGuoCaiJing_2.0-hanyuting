//
//  GDHChangePassController.m
//  Wallet
//
//  Created by GDH on 15/10/22.
//  Copyright (c) 2015年 Sinoglobal. All rights reserved.
//

#import "GDHChangePassController.h"
#import "GDHOriginalChangeController.h"
@interface GDHChangePassController ()

@end

@implementation GDHChangePassController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mallTitleLabel.text = @"支付密码";
    [self makeNav];
    // Do any additional setup after loading the view from its nib.
}
/** 设置导航 */
-(void)makeNav{
//    self.backView.backgroundColor = WalletHomeNAVGRD
//    self.mallTitleLabel.textColor = [UIColor whiteColor];
//    self.mallTitleLabel.font = WalletHomeNAVTitleFont
//    [self.leftBackButton setImage:[UIImage imageNamed:@"title_btn_back"] forState:UIControlStateNormal];
    mainView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    
}

/** 修改密码 */
- (IBAction)changePassWordBtnDown:(id)sender {
    
    GDHOriginalChangeController *originalChange = [[GDHOriginalChangeController alloc] init];
    originalChange.changeTheTitle = @"请输入原支付密码";
    [self.navigationController pushViewController:originalChange animated:YES];
    
    NSLog(@"修改密码");
}
@end
