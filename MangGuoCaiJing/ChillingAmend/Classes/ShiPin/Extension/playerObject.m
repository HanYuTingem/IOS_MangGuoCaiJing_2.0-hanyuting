//
//  playerObject.m
//  playerSDK
//
//  Created by nsstring on 15/8/11.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "playerObject.h"
static playerObject *instenceObject;

@implementation playerObject
//单例
+ (id)Instence {
  if (!instenceObject) {
    instenceObject = [[playerObject alloc] init];
  }
  return instenceObject;
}

+ (id)allocWithZone:(NSZone *)zone {
  @synchronized(self) {
    if (!instenceObject) {
      instenceObject = [super allocWithZone:zone]; //确保使用同一块内存地址
      return instenceObject;
    }
    return nil;
  }
}

- (id)init;
{
  @synchronized(self) {
    if (self = [super init]) {
      return self;
    }
    return nil;
  }
}

- (id)copyWithZone:(NSZone *)zone;
{
  return self; //确保copy对象也是唯一
}
@end
