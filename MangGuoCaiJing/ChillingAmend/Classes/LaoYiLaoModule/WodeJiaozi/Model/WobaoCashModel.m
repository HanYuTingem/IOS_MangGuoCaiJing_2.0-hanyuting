//
//  WobaoCashModel.m
//  LaoYiLao
//
//  Created by sunsu on 15/12/19.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "WobaoCashModel.h"

@implementation WobaoCashModel
+ (WobaoCashModel *)getWobaoCashModelWithDic:(NSDictionary *)dic{
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
            WobaoCashResultModel * model = [WobaoCashResultModel getWobaoCashResultModelWithDic:subDic];
            [dataArray addObject:model];
        }
        self.cashResultArray = dataArray;
    }
}
@end
