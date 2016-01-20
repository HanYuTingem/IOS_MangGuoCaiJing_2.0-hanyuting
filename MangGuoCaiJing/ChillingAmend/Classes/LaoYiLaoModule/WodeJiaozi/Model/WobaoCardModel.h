//
//  WobaoCardModel.h
//  LaoYiLao
//
//  Created by sunsu on 15/12/21.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WobaoCardModel : NSObject

@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * messsage;
@property (nonatomic, copy) NSString * my_pic;
@property (nonatomic, copy) NSString * my_card;
@property (nonatomic, strong) NSMutableArray * resultListArray;
+ (WobaoCardModel *)getWobaoCardModelWithDic:(NSDictionary *)dic;

@end
