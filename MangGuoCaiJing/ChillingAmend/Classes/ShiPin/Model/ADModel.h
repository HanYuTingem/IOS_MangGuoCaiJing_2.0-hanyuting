//
//  ADModel.h
//  playerSDK
//
//  Created by zuoxiong on 15/8/26.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADModel : NSObject
/** 广告id */
@property (nonatomic, copy) NSString* adId;
/** 广告标题 */
@property (nonatomic, copy) NSString* adtitle;
/** 广告描述 */
@property (nonatomic, copy) NSString* admsg;
/** 广告图片 */
@property (nonatomic, copy) NSString* adimg;
/** 时间轴 */
@property (nonatomic, copy) NSString* sjz;
/** 添加时间 */
@property (nonatomic, copy) NSString* addtime;
/** 特价优惠券 数组 */
@property (nonatomic, copy) NSArray* tjq;
/** 普通优惠券 数组 */
@property (nonatomic, copy) NSArray* ptq;
/** 广告点击次数 */
@property (nonatomic, copy) NSString* tapCount;
/** 广告类型（1.视频头；2.视频尾；3.时间轴） */
@property (nonatomic, copy) NSString* adtype_id;
/** 视频广告URL */
@property (nonatomic, copy) NSString* spurl;
/** 图片广告的持续时间 */
@property (nonatomic, copy) NSString* zssj;

@end
