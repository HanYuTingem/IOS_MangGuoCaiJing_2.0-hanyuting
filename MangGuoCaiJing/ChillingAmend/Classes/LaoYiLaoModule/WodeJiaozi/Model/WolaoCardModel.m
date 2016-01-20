//
//  WolaoCardModel.m
//  LaoYiLao
//
//  Created by sunsu on 15/12/21.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "WolaoCardModel.h"
#import "WolaoCardResultModel.h"
@implementation WolaoCardModel
+ (WolaoCardModel *)getWolaoCardModelWithDic:(NSDictionary *)dic{
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
            WolaoCardResultModel * model = [WolaoCardResultModel getWolaoCardResultModelWithDic:subDic];
            [dataArray addObject:model];
        }
        self.resultListArray = dataArray;
    }
}
@end
