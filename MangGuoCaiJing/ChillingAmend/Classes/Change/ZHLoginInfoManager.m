//
//  ZHLoginInfoManager.m
//  LaoYiLao
//
//  Created by wzh on 15/11/30.
//  Copyright (c) 2015年 sunsu. All rights reserved.
//

#import "ZHLoginInfoManager.h"

@implementation ZHLoginInfoManager

+ (void)addSavePHPCacheInLoginWithJson:(id)json{
    ZHLog(@"php登陆信息%@",json);

    [SaveMessage saveUserMessagePHP:json];
    
    [kkUserInfo resetInfo:[[NSUserDefaults standardUserDefaults]objectForKey:usernameMessagePHP]];
    [BSaveMessage saveUserMessage:[[NSUserDefaults standardUserDefaults]objectForKey:usernameMessagePHP]];
    [GCUtil saveLajiaobijifenWithJifen:[[[NSUserDefaults standardUserDefaults]objectForKey:usernameMessagePHP] objectForKey:@"jifen"]];}

+ (void)addSaveJavaCacheInLoginWithJson:(id)json{
    
    NSDictionary *dict = (NSDictionary *)json;
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)[dict objectForKey:@"result"]];
    NSArray *arr = [resultDic allKeysForObject:[NSNull null]];
    [arr enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
        [resultDic setObject:@"" forKey:arr[idx]];
    }];
    [SaveMessage saveUserMessageJava:resultDic];
}


+ (void)removeCacheAndOutLogin{
    MySetObjectForKey(@"", UserIDKey);
    MySetObjectForKey(@"", LoginPhoneKey);
//    NSMutableArray *dumplingLogingInforArray = [NSMutableArray arrayWithContentsOfFile:DumplingInforLogingPath];
//    [dumplingLogingInforArray removeAllObjects];
//    [dumplingLogingInforArray writeToFile:DumplingInforLogingPath atomically:YES];
}


/**
 *  为捞一捞模块保存登陆信息
 */
+ (void)saveLoginInforWithUserId:(NSString *)userId andPhone:(NSString *)phone{
    
    MySetObjectForKey(userId, UserIDKey);
    MySetObjectForKey(phone, LoginPhoneKey);
}

@end
