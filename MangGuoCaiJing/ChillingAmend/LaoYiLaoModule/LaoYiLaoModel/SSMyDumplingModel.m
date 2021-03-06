//
//  SSMyDumplingModel.m
//  LaoYiLao
//
//  Created by sunsu on 15/11/6.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "SSMyDumplingModel.h"

@implementation SSMyDumplingModel
+ (SSMyDumplingModel *)getMyDumplingModelWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

- (id)initWithDic:(NSDictionary *)dic{
    if(self = [super init]){
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"resultList"]){
        _resultListModel = [MyDumplingListModel getMyDumplingListModelWithDic:(NSDictionary *)value];
    }
}

@end
