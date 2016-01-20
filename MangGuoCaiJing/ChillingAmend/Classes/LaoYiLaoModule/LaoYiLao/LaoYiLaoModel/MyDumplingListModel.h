//
//  MyDumplingListModel.h
//  LaoYiLao
//
//  Created by sunsu on 15/11/9.
//  Copyright © 2015年 sunsu. All rights reserved.
//我的饺子模型result字典

#import <Foundation/Foundation.h>


/*
 “count”:" ”60” //捞到饺子个数
 “price” :”50.52” 金额
 “moneyNumber”:”10”//现金饺子数量
 “blessingNumber”:”10”//祝福数量
 “couponNumber”:”10”//优惠券数量
 “cardNumber”:”10”//贺卡数量
 “putDumpNumber”:" ”60” //投放饺子个数
 “putMoney” :”50.52” 投放金额
 “putMoneyNumber”:" ”20” //我包现金饺子个数
 “putCardNumber”:”10”//投放贺卡个数
 */


@interface MyDumplingListModel : NSObject
//@property (nonatomic, copy) NSString * in_count;
//@property (nonatomic, copy) NSString * out_count;


@property (nonatomic, copy) NSString * count;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * blessingNumber;
@property (nonatomic, copy) NSString * couponNumber;
@property (nonatomic, copy) NSString * cardNumber;
@property (nonatomic, copy) NSString * putDumpNumber;
@property (nonatomic, copy) NSString * putMoney;
@property (nonatomic, copy) NSString * putCardNumber;
@property (nonatomic, copy) NSString * moneyNumber;
@property (nonatomic, copy) NSString * putMoneyNumber;


+ (MyDumplingListModel *)getMyDumplingListModelWithDic:(NSDictionary *)dic;
@end
