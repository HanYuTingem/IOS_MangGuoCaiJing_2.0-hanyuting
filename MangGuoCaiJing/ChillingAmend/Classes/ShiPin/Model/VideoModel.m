//
//  VideoModel.m
//  playerSDK
//
//  Created by zuoxiong on 15/8/26.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "MJExtension.h"
#import "VideoModel.h"

@implementation VideoModel

- (void)setValue:(id)value forUndefinedKey:(NSString*)key
{
    if ([key isEqualToString:@"id"])
        self.videoId = value;
}

- (NSDictionary*)replacedKeyFromPropertyName
{
    return @{ @"videoId" : @"id" };
}
@end
