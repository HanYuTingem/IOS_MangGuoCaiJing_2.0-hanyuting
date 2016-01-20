//
//  WobaoCardResultModel.h
//  LaoYiLao
//
//  Created by sunsu on 15/12/21.
//  Copyright © 2015年 sunsu. All rights reserved.
/*
 
 {“code”:100,//成功标识码
 “message”:”It's ok.”,//消息
 “my_pic”:”20.00”//我包的美图
 “my_card”:”20.00”//我包的贺卡
 “resultList”: //返回的消息内容
 [{
 “dumpling_user_put_card_id”:" ”afefasdf” //贺卡订单ID "
 "createTime":"", //时间  算完的时间
 “status:”//状态
 }]
 }
 
 “dumplingUserPutcardId”:" ”afefasdf” //贺卡订单ID "
 "createDate":"", //时间  算完的时间
 “status:”//状态  1未领取2已领取3不可用(被举报)
 “cardWish”:”祝福语”
 
*/

#import <Foundation/Foundation.h>
@interface WobaoCardResultModel : NSObject

@property (nonatomic, copy) NSString * dumplingUserPutcardId;
@property (nonatomic, assign) long long createDate;
@property (nonatomic, copy) NSString * cardWish;
@property (nonatomic, assign) int  status;
@property (nonatomic, copy) NSString *cardPic;//贺卡id

+ (WobaoCardResultModel *)getWobaoCardResultModelWithDic:(NSDictionary *)dic;

@end
