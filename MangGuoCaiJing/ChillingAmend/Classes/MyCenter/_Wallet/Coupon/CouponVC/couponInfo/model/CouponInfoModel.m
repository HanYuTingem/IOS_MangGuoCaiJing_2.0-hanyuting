//
//  CouponInfoModel.m
//  GongYong
//
//  Created by GDH on 16/1/4.
//  Copyright (c) 2016年 DengLu. All rights reserved.
//

#import "CouponInfoModel.h"

@implementation CouponInfoModel


-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"防崩");
}
@end
