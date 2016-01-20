//
//  RemainingDumlingNumberSwitchModel.m
//  LaoYiLao
//
//  Created by wzh on 16/1/8.
//  Copyright © 2016年 sunsu. All rights reserved.
//

#import "RemainingDumlingNumberSwitchModel.h"

@implementation RemainingDumlingNumberSwitchModel
+ (RemainingDumlingNumberSwitchModel *)switchAndNumberModelWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

- (id)initWithDic:(NSDictionary *)dic{
    if(self = [super init]){
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
