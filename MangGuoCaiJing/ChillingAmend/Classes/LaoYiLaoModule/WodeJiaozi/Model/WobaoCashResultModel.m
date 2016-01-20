//
//  WobaoCashResultModel.m
//  LaoYiLao
//
//  Created by sunsu on 15/12/19.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "WobaoCashResultModel.h"

@implementation WobaoCashResultModel
+ (WobaoCashResultModel *)getWobaoCashResultModelWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

- (id)initWithDic:(NSDictionary *)dic{
    if(self = [super init]){
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    if([key isEqualToString:@""]){
//    }
}
@end
