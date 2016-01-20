//
//  DumplingInforDetailResultDumplingModel.h
//  LaoYiLao
//
//  Created by wzh on 15/11/7.
//  Copyright (c) 2015年 sunsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DumplingInforDetailResultDumplingModel : NSObject

@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *dumplingType;//饺子类型 1.钱 2祝福 3优惠卷
@property (nonatomic, copy) NSString *prizeId;//奖品ID：用户饺子ID，优惠券ID,祝福语ID
@property (nonatomic, copy) NSString *prizeInfo;//奖品描述
@property (nonatomic, copy) NSString *prizeAmount;//奖品价格
@property (nonatomic, copy) NSString *status;//状态  1捞到 2领取 3兑现
/**
 *  投放人
 */
@property (nonatomic, copy) NSString *putUser;
/**
 *  投放人图片全路径
 */
@property (nonatomic, copy) NSString *userImg;
/**
 *  卡卷图片路径
 */
@property (nonatomic, copy) NSString *cardUrl;
/**
 *  卡券类型优惠劵图片大小 有两种统一一下 1 460*150px  2 460*360px
 */
@property (nonatomic, copy) NSString *cardType;
/**
 *  卡券标识
 */
@property (nonatomic, copy) NSString *cardId;
/**
 *  饺子锅来源
 */
@property (nonatomic, copy) NSString *sourceProductcode;


@property (nonatomic, copy) NSString *sessionValue;
@property (nonatomic, copy) NSString *sysType;
/**
 * phone = "<null>";
 * productcode = "<null>";
 * userId = 10127;
 * userIp = "<null>";
 */
+ (DumplingInforDetailResultDumplingModel *)dumplingInforResultDumplingModelWithDic:(NSDictionary *)dic;

@end
