//
//  CZJudgeNetWork.m
//  fanxiaoqi
//
//  Created by ZCS on 15/11/17.
//  Copyright © 2015年 sinoglobal. All rights reserved.
//

#import "CZJudgeNetWork.h"
#import "Reachability.h"

@interface CZJudgeNetWork ()
@property (nonatomic, copy) NSString *netWorkState;
@property (nonatomic,strong) Reachability *reachabilityConn;
@end

@implementation CZJudgeNetWork
#pragma mark 处理网络状态改变
/**
 *  判断网络情况
 *
 *  @return WiFi情况下返回@"WIFI",3G/4G返回@"3G4G",没有网络返回@"NoNetWork"
 */
-(NSString *)creatJudgeNetWork{
    // 判断联网状态
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) {
        self.netWorkState = @"WIFI";
    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        self.netWorkState = @"3G4G";
    } else { // 没有网络
        self.netWorkState = @"NoNetWork";
    }
    return self.netWorkState;
}

/**
 *  判断网络情况
 *
 *  @return WiFi情况下返回@"WIFI",3G/4G返回@"3G4G",没有网络返回@"NoNetWork"
 */
+(NSString*)networkInfo{
    // 判断联网状态
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    NSString* netWorkState=[[NSString alloc]init];
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) {
        netWorkState = @"WIFI";
    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        netWorkState = @"3G4G";
    } else { // 没有网络
        netWorkState = @"NoNetWork";
    }
    return netWorkState;
}

@end
