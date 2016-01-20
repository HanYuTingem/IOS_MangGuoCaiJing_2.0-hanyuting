//
//  RemainingDumlingNumberSwitchModel.h
//  LaoYiLao
//
//  Created by wzh on 16/1/8.
//  Copyright © 2016年 sunsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemainingDumlingNumberSwitchModel : NSObject
@property (nonatomic, strong) NSString *num;
@property (nonatomic, strong) NSString *timeup;  //首页时间列表 0关1开
@property (nonatomic, strong) NSString *vote;  //广告位0关1开
@property (nonatomic, copy) NSString *voteUrl;//投票地址
+ (RemainingDumlingNumberSwitchModel *)switchAndNumberModelWithDic:(NSDictionary *)dic;

@end
