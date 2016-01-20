//
//  ZHPHPLogingManager.m
//  LaoYiLao
//
//  Created by wzh on 16/1/8.
//  Copyright © 2016年 sunsu. All rights reserved.
//

#import "ZHPHPLogingManager.h"

@implementation ZHPHPLogingManager

+ (NSDictionary *)phpLogingWithJavaDic:(NSDictionary *)resultDic{
   
    return [self accessToLoginInformationUserId:[resultDic objectForKey:@"id"] userName:[resultDic objectForKey:@"userName"] sex:[resultDic objectForKey:@"sex"] nickName:[resultDic objectForKey:@"nickname"] src:[resultDic objectForKey:@"src"] jifen:@"0"status:[resultDic objectForKey:@"status"] lat:@"" ing:@"" token:@""];
}

//php获取登陆信息
+ (NSMutableDictionary *)accessToLoginInformationUserId:(NSString *)userId userName:(NSString *)userName sex:(NSString *)sex nickName:(NSString *)nickName src:(NSString *)src jifen:(NSString *)jifeng status:(NSString *)status lat:(NSString *)lat ing:(NSString *)ing token:(NSString *)token {
    //    NSLog(@"%@?por=%@&userId=%@&userName=%@&sex=%@&nickName=%@&src=%@&jifen=%@&status=%@&lat=%@&ing=%@&token=%@",ADDRESSPHP,@"9000",userId,userName,sex,nickName,src,jifeng,status,lat,ing,token);
    //需要我们初始化一个空间大小，用dictionaryWithCapacity
    NSMutableDictionary * mutableDictionary = [NSMutableDictionary dictionary];
    //这里我们给的空间大小是5,当添加的数据超过的时候，它的空间大小会自动扩大
    //添加数据，注意：id key  是成对出现的
    [mutableDictionary setObject:@"9000" forKey:@"por"];
    [mutableDictionary setObject:userId forKey:@"userId"];
    [mutableDictionary setObject:userName forKey:@"userName"];
    [mutableDictionary setObject:sex forKey:@"sex"];
    [mutableDictionary setObject:nickName forKey:@"nickName"];
    [mutableDictionary setObject:src forKey:@"src"];
    [mutableDictionary setObject:jifeng forKey:@"jifen"];
    [mutableDictionary setObject:status forKey:@"status"];
    [mutableDictionary setObject:lat forKey:@"lat"];
    [mutableDictionary setObject:ing forKey:@"ing"];
    [mutableDictionary setObject:token forKey:@"token"];
    return mutableDictionary;
}

@end
