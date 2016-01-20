//
//  ZHLoginInfoManager.m
//  LaoYiLao
//
//  Created by wzh on 15/11/30.
//  Copyright (c) 2015年 sunsu. All rights reserved.
//

#import "ZHLoginInfoManager.h"
#import "SaveMessage.h"

@implementation ZHLoginInfoManager

+ (void)addSaveCacheInLoginWithJson:(id)json{
        //ZHLog(@"登陆信息%@",json);
    
    if([[json objectForKey:@"code"] integerValue] == 1)
    {
        
    }
}


+ (void)removeCacheAndOutLogin{
    MySetObjectForKey(LoginStateNO, LoginStateKey);
    //清除缓存饺子信息
    NSMutableArray *dumplingLogingInforArray = [NSMutableArray arrayWithContentsOfFile:DumplingInforLogingPath];
    [dumplingLogingInforArray removeAllObjects];
    [dumplingLogingInforArray writeToFile:DumplingInforLogingPath atomically:YES];
}


@end
