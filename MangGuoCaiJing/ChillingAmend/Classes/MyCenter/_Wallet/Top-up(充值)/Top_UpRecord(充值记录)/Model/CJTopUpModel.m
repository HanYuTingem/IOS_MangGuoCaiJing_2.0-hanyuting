//
//  CJTopUpModel.m
//  Wallet
//
//  Created by zhaochunjing on 15-10-29.
//  Copyright (c) 2015年 Sinoglobal. All rights reserved.
//

#import "CJTopUpModel.h"

@implementation CJTopUpModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"bkjson"]) {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:value];
        CJTopUpPayModel *model = [[CJTopUpPayModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        self.backJson = model;
        //        self.backJson = value;
    }
}
- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
