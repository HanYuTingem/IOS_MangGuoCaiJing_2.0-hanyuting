//
//  WolaoCardModel.h
//  LaoYiLao
//
//  Created by sunsu on 15/12/19.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WolaoCardResultModel : NSObject

@property (nonatomic, assign) long long createDate;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *cardId;
@property (nonatomic, copy) NSString *userImg;


+ (WolaoCardResultModel *)getWolaoCardResultModelWithDic:(NSDictionary *)dic;

@end

