//
//  GDHCouponModel.m
//  GongYong
//
//  Created by GDH on 15/12/30.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "GDHCouponModel.h"

@implementation GDHCouponModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    NSLog(@"  防崩 ");
}

@end
