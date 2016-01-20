//
//  ADModel.m
//  playerSDK
//
//  Created by zuoxiong on 15/8/26.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "ADModel.h"
#import "LMTicketModal.h"
#import "MJExtension.h"

@implementation ADModel

- (NSDictionary*)replacedKeyFromPropertyName
{
    return @{ @"adId" : @"id" };
}
@end
