//
//  WobaoCashResultModel.h
//  LaoYiLao
//
//  Created by sunsu on 15/12/19.
//  Copyright © 2015年 sunsu. All rights reserved.
/*

 “dumpling_user_put_money_id”:" ”afefasdf” //钱小锅订单ID
 "createTime":"", //时间  算完的时间
 “content”: // 祝福语
 “dumplingMoney”: // 钱总数
 “dumplingNum”: // 饺子个数
 “getDumplingNum “：//领取的个数
 “status:”//状态   5已过期，4已领完，3未领完,1未发送
 
*/

#import <Foundation/Foundation.h>

@interface WobaoCashResultModel : NSObject
@property (nonatomic, copy) NSString * moneyNum;
@property (nonatomic, assign) int  dumplinglNum;

@property (nonatomic, copy) NSString * dumplingUserPutmoneytid;
@property (nonatomic, assign) long long  createDate;
@property (nonatomic, copy) NSString * updateDate;
@property (nonatomic, copy) NSString * blessing;
@property (nonatomic, copy) NSString * dumplingMoney;
@property (nonatomic, assign) int receiveNum;//领取个数
@property (nonatomic, assign) int  status;//5已过期，4已领完，3未领完,1未发送

+ (WobaoCashResultModel *)getWobaoCashResultModelWithDic:(NSDictionary *)dic;
@end
