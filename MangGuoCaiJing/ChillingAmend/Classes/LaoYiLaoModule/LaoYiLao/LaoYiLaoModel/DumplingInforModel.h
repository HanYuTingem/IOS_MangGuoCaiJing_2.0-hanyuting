//
//  DumplingInforModel.h
//  LaoYiLao
//
//  Created by wzh on 15/11/6.
//  Copyright (c) 2015年 sunsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DumplingInforResultModel.h"
#define DumplingTypeMoney @"1"//1.钱
#define DumplingTypeBlessing @"2"//2祝福
#define DumplingTypePlatformCoupon @"3" //3=平台优惠券；7=商品优惠券；5=第三方优惠券;6=商家优惠券;
#define DumplingTypeGoodsCoupon @"7"
#define DumplingTypeThirdCoupon @"5"
#define DumplingTypeMerchantsCoupon @"6"
#define DumlingTypeGreetingCard @"8" // 贺卡
@interface DumplingInforModel : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) DumplingInforResultModel *resultListModel;


+ (DumplingInforModel *)dumplingInforModelWithDic:(NSDictionary *)dic;
@end
