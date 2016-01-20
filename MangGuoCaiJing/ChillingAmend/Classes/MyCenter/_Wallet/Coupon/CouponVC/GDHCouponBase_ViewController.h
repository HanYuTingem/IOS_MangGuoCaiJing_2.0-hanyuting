//
//  GDHCouponBase_ViewController.h
//  GongYong
//
//  Created by GDH on 15/12/30.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "Wallet_BaseViewController.h"
#import "MyCouponHeadView.h"
#import "GDHCouponTableViewCell.h"
#import "GDHCouponModel.h"
#import "GDHCouponFootView.h"
#import "GDHSelectCategoryView.h"

typedef NS_ENUM(int, couponUserState) {
 
    /** 未使用 */
    couponUserStateNOtUser ,
    /** 已使用 */
    couponUserStateUsed ,
    /** 已过期 */
    couponUserStateExpired
};


@interface GDHCouponBase_ViewController : Wallet_BaseViewController<MyCouponHeadViewDelegate,GDHCouponFootViewDelegate,GDHSelectCategoryViewDelegate>
@property(nonatomic,strong)NSMutableArray *data;

/**  判断是 我的优惠券还是已经失效的优惠券 */
@property (nonatomic,assign) BOOL heaViewIFShow;

@property(nonatomic,strong)UITableView *couponTableView;

@property(nonatomic,assign) couponUserState couponState;

@property(nonatomic,strong)GDHCouponFootView *couponFootView;


-(void)mycouponRequest;
@end
