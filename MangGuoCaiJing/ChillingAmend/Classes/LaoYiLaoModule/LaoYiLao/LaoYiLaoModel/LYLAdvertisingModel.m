//
//  LYLAdvertisingModel.m
//  LaoYiLao
//
//  Created by wzh on 16/1/8.
//  Copyright © 2016年 sunsu. All rights reserved.
//

#import "LYLAdvertisingModel.h"

@implementation LYLAdvertisingModel
+ (LYLAdvertisingModel *)advertisingModelWithDic:(NSDictionary *)dic{
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
        
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *subDic in (NSArray *)value) {
            LYLAdvertisingResultModel *model = [LYLAdvertisingResultModel advertisingResultModelWithDic:subDic];
            [dataArray addObject:model];
        }
        self.resultModels = dataArray;
    }
}
@end
