//
//  GDHCouponTableViewCell.h
//  GongYong
//
//  Created by GDH on 15/12/30.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GDHCouponTableViewCellDelegate <NSObject>

- (void)GDHCouponTableViewCellShareButton:(UIButton *)shareButton;

@end

@class GDHCouponModel;
@interface GDHCouponTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgeViewHeight;

/**  模型 */
@property(nonatomic,strong)GDHCouponModel *couponModel;

@property (nonatomic,assign) id<GDHCouponTableViewCellDelegate>delegate;

+(instancetype)initWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
