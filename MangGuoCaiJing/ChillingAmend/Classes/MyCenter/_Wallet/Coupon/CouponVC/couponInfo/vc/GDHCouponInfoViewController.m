//
//  GDHCouponInfoViewController.m
//  GongYong
//
//  Created by GDH on 16/1/4.
//  Copyright (c) 2016年 DengLu. All rights reserved.
//

#import "GDHCouponInfoViewController.h"


#import "GDHCouponInfoWebViewController.h"


#import "CouponInfoModel.h"
@interface GDHCouponInfoViewController (){
    CouponInfoModel *infoModel;
//    NSString *textString;
}

/** 下面的按钮 */
@property(nonatomic,strong) UIButton *couponTypeButton;

/**  详情SC */
@property(nonatomic,strong)  UIScrollView *couponInfoScrollView;
/** 详情文字 */
@property(nonatomic,strong) UILabel *couponInfoLabel;
/**  核销码 */
@property(nonatomic,strong)  UILabel *VerificationCodeLabel;


@end

@implementation GDHCouponInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [mainView removeFromSuperview];
    self.view.backgroundColor = walletCouponInfoColor;
    [self.rightButton setImage:[UIImage imageNamed:@"Wallet_youhuijuan_fenxiang"] forState:UIControlStateNormal];
    [mainView removeFromSuperview];
    self.mallTitleLabel.text = self.Model.COUPON_NAME;
    [self.view addSubview:self.couponInfoScrollView];
    

    [self requestInfo];
    
//    textString = @"互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈大视频互动哈";
    
  

}

- (UILabel *)VerificationCodeLabel{
    if (_VerificationCodeLabel == nil) {
        _VerificationCodeLabel = [[UILabel alloc] init];
        _VerificationCodeLabel.font = [UIFont systemFontOfSize:14];
        _VerificationCodeLabel.textAlignment = NSTextAlignmentCenter;
        _VerificationCodeLabel.numberOfLines = 0;
        _VerificationCodeLabel.textColor = [UIColor colorWithRed:0.22f green:0.22f blue:0.22f alpha:1.00f];

    }
    return _VerificationCodeLabel;
}

-(UILabel *)couponInfoLabel{
    if (_couponInfoLabel == nil) {
        _couponInfoLabel = [[UILabel alloc] init];
//        _couponInfoLabel.textAlignment = NSTextAlignmentCenter;
        _couponInfoLabel.font = [UIFont systemFontOfSize:14];
        _couponInfoLabel.numberOfLines = 0;
//        _couponInfoLabel.backgroundColor = [UIColor yellowColor];
        _couponInfoLabel.textColor = [UIColor colorWithRed:0.22f green:0.22f blue:0.22f alpha:1.00f];
    }
    return _couponInfoLabel;
}

-(UIButton *)couponTypeButton{
    if (_couponTypeButton == nil) {
        _couponTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _couponTypeButton.backgroundColor = walletCouponInfoButtonTypeColor;
        [_couponTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_couponTypeButton  addTarget:self action:@selector(couponTypeButtonDown:) forControlEvents:UIControlEventTouchUpInside];
        _couponTypeButton.layer.masksToBounds = YES;
        _couponTypeButton.layer.cornerRadius = 8;
        
    }
    return _couponTypeButton;
}
-(UIScrollView *)couponInfoScrollView{
    if (_couponInfoScrollView== nil) {
        _couponInfoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 85, kkViewWidth, kkViewHeight - 85)];
//        _couponInfoScrollView.backgroundColor = [UIColor redColor];
        _couponInfoScrollView.userInteractionEnabled = YES;
    }
    return _couponInfoScrollView;
}

- (void)requestInfo{// 详情
    
    NSDictionary *dict = [WalletRequsetHttp WalletCouponInfoclaimId:self.Model.COUPON_CLAIM_ID];
    [SINOAFNetWorking postCouponWithBaseURL:WalletHttp_Coupon_info controller:self params:dict success:^(id json) {
        NSLog(@"%@  json  ",json);
        if (json) {
            if ([json[@"code"] isEqualToString:@"0000"]) {
                infoModel = [[CouponInfoModel alloc] initWithDict:json[@"pd"]];
                [self judgeTheCouponButton];
            }else{
                [self showMsg:json[@"desc"]];
            }
        }
    } failure:^(NSError *error) {
        
        
    } noNet:^{
        
    }];
}
#pragma mark - 判断是那种情况 （控件的显示）
-(void)judgeTheCouponButton
{
    NSLog(@"COUPON_TYPE ===================  %@",self.Model.COUPON_TYPE);
    
    if ([self.Model.COUPON_TYPE isEqualToString:couponTypePlatform]) {//A
        NSLog(@"通用券  平台券");
        [self.couponInfoScrollView addSubview:self.couponInfoLabel];
        self.couponInfoLabel.text = infoModel.USED_DERECTION;
        [self.couponTypeButton removeFromSuperview];
        
    }else if ([self.Model.COUPON_TYPE isEqualToString:couponTypeVoucher]){//B
        NSLog(@"代金券  商户");
        [self.couponInfoScrollView addSubview:self.VerificationCodeLabel];
        [self.couponInfoScrollView addSubview:self.couponInfoLabel];
        self.couponInfoLabel.text = infoModel.USED_DERECTION;
//        [self.couponInfoScrollView addSubview:self.VerificationCodeLabel];
        self.VerificationCodeLabel.text = [NSString stringWithFormat:@"核销码\n%@",infoModel.COUPON_CODE];
//        self.VerificationCodeLabel.text = infoModel.COUPON_CODE;
        
    }else if ([self.Model.COUPON_TYPE isEqualToString:couponTypeThird]){//C
        NSLog(@"优惠券（第三方）");
        [self.couponInfoScrollView addSubview:self.couponInfoLabel];
        self.couponInfoLabel.text = infoModel.USED_DERECTION;
        if (infoModel.COUPON_CODE.length) {
            [self.couponInfoScrollView addSubview:self.VerificationCodeLabel];
            self.VerificationCodeLabel.text = [NSString stringWithFormat:@"核销码\n%@",infoModel.COUPON_CODE];
        }
        [self.couponInfoScrollView addSubview:self.couponTypeButton];
        [self.couponTypeButton setTitle:@"去使用" forState:UIControlStateNormal];
    }
    else if ([self.Model.COUPON_TYPE isEqualToString:couponTypeGoods]){//D
        [self.couponInfoScrollView addSubview:self.couponInfoLabel];
        self.couponInfoLabel.text = infoModel.USED_DERECTION;
        [self.couponInfoScrollView addSubview:self.couponTypeButton];
        
        [self.couponTypeButton setTitle:@"拨打客服电话" forState:UIControlStateNormal];

        NSLog(@"实物券 （商品）");
    }
    [self refreshUI];
}
- (void)refreshUI{
    CGFloat couponInfoHeight = [self widthOfString:infoModel.USED_DERECTION withFont:14 andCGFloat:(kkViewWidth - 40)] .height;
    
    if (couponInfoHeight >= kkViewHeight - 204) {
        self.couponInfoLabel.frame = CGRectMake(20, 0, kkViewWidth - 40,[self widthOfString:infoModel.USED_DERECTION withFont:14 andCGFloat:(kkViewWidth - 40)] .height);
        if ([self.Model.COUPON_TYPE isEqualToString:couponTypePlatform]) {
            self.couponInfoScrollView.contentSize = CGSizeMake(self.couponInfoLabel.frame.size.width, self.couponInfoLabel.size.height+ 10);
            
        }else if ([self.Model.COUPON_TYPE isEqualToString:couponTypeVoucher]){
            self.couponInfoScrollView.contentSize = CGSizeMake(self.couponInfoLabel.frame.size.width, self.couponInfoLabel.size.height+ 40);
            self.VerificationCodeLabel.frame = CGRectMake(0, CGRectGetHeight(self.couponInfoLabel.frame)+10, kkViewWidth, 40);
        }
        else{
            self.couponInfoScrollView.contentSize = CGSizeMake(self.couponInfoLabel.frame.size.width, self.couponInfoLabel.size.height+ 100);
            self.VerificationCodeLabel.frame = CGRectMake(0, CGRectGetHeight(self.couponInfoLabel.frame)+10, kkViewWidth, 40);
            self.couponTypeButton.frame = CGRectMake(25, self.couponInfoScrollView.contentSize.height - 60, kkViewWidth - 50, 44);
        }
        
    }else{
        
        self.couponInfoLabel.frame = CGRectMake(20, 0, kkViewWidth - 40, couponInfoHeight);
        self.couponInfoScrollView.contentSize = CGSizeMake(self.couponInfoLabel.frame.size.width, self.couponInfoLabel.size.height);
        self.VerificationCodeLabel.frame = CGRectMake(0, kkViewHeight - 61 -65 -44 - 24 - 14, kkViewWidth, 40);
        self.couponTypeButton.frame = CGRectMake(25, kkViewHeight - 61 -65 -44, kkViewWidth - 50, 44);
    }

}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    
   }

-(void)rightBackCliked{
    
    NSLog(@"分享---");
    
    [self shareTitle:@"" withUrl: walletCouponShareURL  withContent:[NSString stringWithFormat:@"我在%@的活动中抢了张%@，你也快来抢吧!",walletCouponInfoProductName,self.Model.COUPON_NAME] withImageName:@"" withShareType:1 ImgStr:self.Model.LOGO_IMAGE domainName:@"用优惠券来践踏我的尊严"];
}


- (void)couponTypeButtonDown:(UIButton *)sender {
    
    if ([self.Model.COUPON_TYPE isEqualToString:couponTypePlatform]) {
        
        NSLog(@"优惠券详情————————————");
    }else if ([self.Model.COUPON_TYPE isEqualToString:couponTypeThird]){
        
        NSLog(@"去使用");
        GDHCouponInfoWebViewController *Web = [[GDHCouponInfoWebViewController alloc] init];
        Web.webUrl = infoModel.THIRD_URL;
        Web.titleName = self.Model.THIRD_PARTY_NAME;
        [self.navigationController pushViewController:Web animated:YES];
        NSLog(@"%@",infoModel.THIRD_URL);
    }else if ([self.Model.COUPON_TYPE isEqualToString:couponTypeGoods]){
        NSLog(@"拨打商户电话 （商家）");
        
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",infoModel.SERVICE_TELEPHONE];
        //            NSLog(@"str======%@",str);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}


//String宽度
- (CGSize)widthOfString:(NSString *)string withFont:(int)font andCGFloat:(CGFloat)width{
    //    CGSize labsize = [string sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(275, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect textRect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                           context:nil];
    
    CGSize size = textRect.size;
    
    return size;
}
@end
