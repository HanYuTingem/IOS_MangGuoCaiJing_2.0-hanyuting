//
//  GDHCouponTableViewCell.m
//  GongYong
//
//  Created by GDH on 15/12/30.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "GDHCouponTableViewCell.h"
#import "GDHCouponModel.h"
#import "UIImageView+WebCache.h"
#import "UIImage+MJ.h"
@interface GDHCouponTableViewCell ()
/** 角标 */
//@property (weak, nonatomic) IBOutlet UIImageView *superscriptImageView;
/** 商品图片 */
@property (weak, nonatomic) IBOutlet UIImageView *shopImageVIew;
/** 分享按钮 */
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

/** 业务类型 */
@property (weak, nonatomic) IBOutlet UILabel *businessType;
/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/** 商家名称 */
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *CouponLabel;

@property (weak, nonatomic) IBOutlet UIImageView *shareBackImageView;

@property (weak, nonatomic) IBOutlet UILabel *shareLabel;
/** 背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;

- (IBAction)shareButtonDown:(id)sender;

@end

@implementation GDHCouponTableViewCell

+(instancetype)initWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idenCell = @"cell" ;
    GDHCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenCell];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"GDHCouponTableViewCell" owner:self options:nil] lastObject];
    }
    cell.backgroundColor = walletCouponBackgroundColor;
    cell.imgeViewHeight.constant =  50 *WalletSP_Width;

    cell.shareButton.tag = 2000+indexPath.row;
    
    [cell.bigImageView setImage:[UIImage resizedImageWithName:@"Wallet_youhuijuan_juanditu.png"]];
    
    return cell;
}

-(void)setCouponModel:(GDHCouponModel *)couponModel{
    
    _couponModel  = couponModel;
    [self.shopImageVIew setImageWithURL:[NSURL URLWithString:couponModel.LOGO_IMAGE] placeholderImage:[UIImage imageNamed:@"Wallet_youhuijuan-morentu"]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ — %@",couponModel.START_DATE,couponModel.END_DATE];
    self.shopNameLabel.text = couponModel.THIRD_PARTY_NAME;
    self.businessType.text  = couponModel.APPLY_SCOPE;
    self.CouponLabel.text = couponModel.COUPON_NAME;
    
    if ([couponModel.USE_STATE isEqualToString:@"0"]) {// 未使用

        
        self.shareLabel.text = @"立即分享";
    }else if([couponModel.USE_STATE  isEqualToString:@"2"]){// 过期
        [self changeCellLabelColor];


        self.shareBackImageView.image = [UIImage imageNamed:@"Wallet_youhuijuan_juanicon_bunengdianji"];
        self.shareLabel.text = @"已过期";

        self.shareButton.enabled = NO;
    }
    else{// 已使用
        self.shareButton.enabled = NO;
        self.shareLabel.text = @"已使用";
        self.shareBackImageView.image = [UIImage imageNamed:@"Wallet_youhuijuan-yishiyong"];

    }
    
    NSLog(@"couponModel.COUPON_NAME  +---- +%@",couponModel.COUPON_NAME);
    
}
/**  修改字体的颜色 */
-(void)changeCellLabelColor{
    self.CouponLabel.textColor = walletCouponCellInvailColor2;
    self.businessType.textColor = walletCouponCellInvailColor1;
    self.shopNameLabel.textColor = walletCouponCellInvailColor1;
    self.timeLabel.textColor =  walletCouponCellInvailColor3;
    self.shopImageVIew.alpha = 0.7;
}
- (IBAction)shareButtonDown:(id)sender {

    UIButton *button = sender;
    
    if ([self.delegate respondsToSelector:@selector(GDHCouponTableViewCellShareButton:)]) {
        [self.delegate GDHCouponTableViewCellShareButton:button];
    }
}
@end
