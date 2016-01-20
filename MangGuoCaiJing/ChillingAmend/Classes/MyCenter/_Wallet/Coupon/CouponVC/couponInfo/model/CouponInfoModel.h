//
//  CouponInfoModel.h
//  GongYong
//
//  Created by GDH on 16/1/4.
//  Copyright (c) 2016年 DengLu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponInfoModel : NSObject


/** 优惠券领取ID */
@property (nonatomic,copy) NSString *COUPON_CLAIM_ID;
/** 第三方链接 */
@property (nonatomic,copy) NSString *THIRD_URL;
/** 使用说明 */
@property (nonatomic,copy) NSString *USED_DERECTION;
/** 核销码 */
@property (nonatomic,copy) NSString *COUPON_CODE;
/** 电话 */
@property (nonatomic,copy) NSString *SERVICE_TELEPHONE;


-(instancetype)initWithDict:(NSDictionary *)dict;
@end
