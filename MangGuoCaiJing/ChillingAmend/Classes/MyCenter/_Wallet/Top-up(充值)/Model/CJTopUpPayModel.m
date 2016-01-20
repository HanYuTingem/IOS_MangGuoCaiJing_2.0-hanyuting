//
//  CJTopUpPayModel.m
//  GongYong
//
//  Created by zhaochunjing on 15-12-18.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "CJTopUpPayModel.h"

@implementation CJTopUpPayModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    [self setValuesForKeysWithDictionary:dict];
    return self;
}

@end
