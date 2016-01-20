//
//  GDHCouponModel.h
//  GongYong
//
//  Created by GDH on 15/12/30.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDHCouponModel : NSObject

/** 优惠券领取ID */
@property (nonatomic,copy) NSString *COUPON_CLAIM_ID;
/** 用户ID */
//@property (nonatomic,copy) NSString *USER_ID;

/** 用户账户 */
@property (nonatomic,copy) NSString *USER_PHONE;
/** 优惠券 */
@property (nonatomic,copy) NSString *COUPON_CODE;
/** 0：未使用1：已使用 */
@property (nonatomic,copy) NSString *USE_STATE;
/** 优惠券名称 */
@property (nonatomic,copy) NSString *COUPON_NAME;
/** 优惠券类型 */
@property (nonatomic,copy) NSString *COUPON_TYPE;
/** /适用业务 */
@property (nonatomic,copy) NSString *APPLY_SCOPE;
/** 优惠券有效开始时间 */
@property (nonatomic,copy) NSString *START_DATE;
/** 优惠券有效结束时间 */
@property (nonatomic,copy) NSString *END_DATE;
/** 图片链接 */
@property (nonatomic,copy) NSString *LOGO_IMAGE;
/** 商户名称 */
@property (nonatomic,copy) NSString *THIRD_PARTY_NAME;

//@property (nonatomic,copy) NSString *COUPON_PRICE;
//
//@property (nonatomic,copy) NSString *LIMIT_PRICE;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
