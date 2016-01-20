//
//  LYLAdvertisingModel.h
//  LaoYiLao
//
//  Created by wzh on 16/1/8.
//  Copyright © 2016年 sunsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYLAdvertisingResultModel.h"
@interface LYLAdvertisingModel : NSObject
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * message;
//@property (nonatomic, strong) LYLAdvertisingResultModel *resultModel;

@property (nonatomic, strong) NSMutableArray *resultModels;
+ (LYLAdvertisingModel *)advertisingModelWithDic:(NSDictionary *)dic;

@end
