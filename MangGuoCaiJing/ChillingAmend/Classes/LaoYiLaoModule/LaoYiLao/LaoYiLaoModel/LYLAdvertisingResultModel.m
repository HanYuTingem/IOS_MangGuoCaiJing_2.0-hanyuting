//
//  LYLAdvertisingResultModel.m
//  LaoYiLao
//
//  Created by wzh on 16/1/8.
//  Copyright © 2016年 sunsu. All rights reserved.
//

#import "LYLAdvertisingResultModel.h"

@implementation LYLAdvertisingResultModel

+ (LYLAdvertisingResultModel *)advertisingResultModelWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

- (id)initWithDic:(NSDictionary *)dic{
    if(self = [super init]){
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    if([key isEqualToString:@"resultList"]){
//        _resultModel = [LYLAdvertisingResultModel advertisingResultModelWithDic:(NSDictionary *)value];
//    }
}
@end
