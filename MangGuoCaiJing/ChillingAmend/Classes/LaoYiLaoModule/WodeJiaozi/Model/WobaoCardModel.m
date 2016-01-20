//
//  WobaoCardModel.m
//  LaoYiLao
//
//  Created by sunsu on 15/12/21.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "WobaoCardModel.h"
#import "WobaoCardResultModel.h"
@implementation WobaoCardModel
+ (WobaoCardModel *)getWobaoCardModelWithDic:(NSDictionary *)dic{
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
            WobaoCardResultModel * model = [WobaoCardResultModel getWobaoCardResultModelWithDic:subDic];
            [dataArray addObject:model];
        }
        self.resultListArray = dataArray;
    }
}
@end
