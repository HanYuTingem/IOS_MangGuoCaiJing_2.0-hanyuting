//
//  WolaoCardModel.h
//  LaoYiLao
//
//  Created by sunsu on 15/12/21.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WolaoCardModel : NSObject

@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, strong) NSMutableArray * resultListArray;
+ (WolaoCardModel *)getWolaoCardModelWithDic:(NSDictionary *)dic;

@end
