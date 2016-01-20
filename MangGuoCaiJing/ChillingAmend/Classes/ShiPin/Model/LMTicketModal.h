//
//  TicketModal.h
//  fanxiaoqi
//
//  Created by 李敏 on 15/9/16.
//  Copyright (c) 2015年 sinoglobal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMTicketModal : NSObject
/** 券ID */
@property(nonatomic,copy) NSString* coupon_id;

/** 券名称 */
@property(nonatomic,copy) NSString* coupon_name;

/** 优惠券图片 */
@property(nonatomic,copy)NSString *img;

/** 优惠券现价（活动期内，此项作废，走活动价） */
@property(nonatomic,copy)NSString *xj_money;

/** 优惠券原价 */
@property(nonatomic,copy)NSString *yj_money;

/** 券简介 */
//@property(nonatomic,copy)NSString *ticketIntro;

/** 有效日期 */
//@property(nonatomic,copy)NSString *effectiveDate;

/** 已经销售数量 */
@property (nonatomic, copy) NSString *xssl;

/** 是否热销 */
@property (nonatomic, copy) NSString *isHot;

//---------活动---------
/** 是否在活动期内 */
@property(nonatomic,copy) NSString *isMark;

/** 活动类型（1，限时；2，限量；3，限时且限量） */
@property(nonatomic,copy) NSString *marktype;

/** 剩余数量 */
@property(nonatomic,copy)NSString *sysl;

/** 活动开始时间 */
@property(nonatomic,copy)NSString *start_date;

/** 活动结束时间 */
@property(nonatomic,copy)NSString *end_date;

/** 每个ID限制购买数量 */
@property(nonatomic,copy) NSString *xzid;

/** 活动描述 */
@property(nonatomic,copy) NSString *markDesc;

//---------商家---------
/** 商家名称 */
@property(nonatomic,copy)NSString *business_name;

/** 商家ID */
@property(nonatomic,copy)NSString *business_id;

/** 热销商品 */
@property (nonatomic, copy) NSString *hot;

//--------我的关注------
/** 关注价格 */
@property(nonatomic,copy)NSString *gz_price;

/** 添加时间 */
@property(nonatomic,copy)NSString *addtime;

/** 用户id */
@property(nonatomic,copy)NSString *member_id;

/** 活动价格 */
@property(nonatomic,copy)NSString *markPrice;
/** 活动价 */
@property (nonatomic, copy) NSString *actprice;

///** 关注id */
//@property(nonatomic,copy)NSString *gz_id;


@end


