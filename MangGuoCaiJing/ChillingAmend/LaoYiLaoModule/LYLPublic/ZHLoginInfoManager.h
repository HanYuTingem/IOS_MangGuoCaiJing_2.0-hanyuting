//
//  ZHLoginInfoManager.h
//  LaoYiLao
//
//  Created by wzh on 15/11/30.
//  Copyright (c) 2015年 sunsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHLoginInfoManager : NSObject

/**
 *  保存登陆信息
 *
 *  @param json  登陆成功后返回的信息
 */
+ (void)addSaveCacheInLoginWithJson:(id)json;


/**
 *  清除缓存并标记退出登陆
 */
+ (void)removeCacheAndOutLogin;
@end
