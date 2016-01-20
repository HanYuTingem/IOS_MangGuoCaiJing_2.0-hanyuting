//
//  ZHDataBase.h
//  LaoYiLao
//
//  Created by wzh on 15/12/15.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DumplingInforModel.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface ZHDataBase : NSObject


+ (ZHDataBase *)sharedDataBase;
/**
 *  创建数据库
 */
- (void)createDataBase;
/**
 *  创建表格
 */
- (void)createDumplingInforTable;

/**
 *  插入字段
 *
 *  @param columnName 字段名字
 */
- (void)addColumnForTableWithColumnName:(NSString *)columnName;
/**
 *  插入数据
 *
 *  @param dumplingInforModel 插入数据的model
 *  @param logingState        登陆状态 1是登陆 0 是未登录
 *  @param userId             登录人userId 未登录传空字符串
 */
- (void)insertWithModel:(DumplingInforModel *)dumplingInforModel logingState:(NSString *)logingState andUserId:(NSString *)userId;
/**
 *  删除数据
 *
 *  @param dumplingInforModel 插入数据的model
 *  @param logingState        登陆状态 1是登陆 0 是未登录
 *
 *  @return 是否删除成功
 */
- (BOOL)deleWithLogingState:(NSString *)logingState;


/**
 *  数据库查询
 *
 *  @param logingState 登陆状态 1是登陆 0 是未登录
 *
 *  @return 登陆或者未登录下今日共捞到的金钱
 */
- (CGFloat)selectLogingstateWithReturnTodayTotalMoney:(NSString*)logingState andUserId:(NSString *)userId;
/**
 *  数据库查询
 *
 *  @param logingState  登陆状态 1是登陆 0 是未登录
 *  @param userId      登录人userId 未登录传空字符串
 *
 *  @return 今日捞到的优惠劵数量
 */
- (int)selectLogingstateWithReturnTodayCouponCount:(NSString*)logingState andUserId:(NSString *)userId;

/**
 * 数据库查询
 *
 *  @param logingState 登陆状态 1是登陆 0 是未登录
 *  @param userId      登录人userId 未登录传空字符串
 *
 *  @return 今日捞到的贺卡数量
 */
- (int)selectLogingstateWithReturnTodayGreetingCardCount:(NSString*)logingState andUserId:(NSString *)userId;



/**
 *  数据库查询
 *
 *  @param logingState 登录状态
 *  @param userId 
 *  @return 当前登陆状态下的饺子信息
 */
- (NSMutableArray *)selectLogingStateWithReturnDumplingInfor:(NSString *)logingState andUserId:(NSString *)userId;
/**
 *   数据库查询
 *
 *  @param logingState 登陆状态 1是登陆 0 是未登录
 *   @param userId        当前登陆的userId
 *  @return 今日登陆或未登录捞的次数
 */
- (int)selectLogingstateWithReturnTodayCount:(NSString*)logingState andUserId:(NSString *)userId;

/**
 *  更新数据从未登录变成已登录
 *
 *  @param logingState   更改前登录状态
 *  @param toLogingState 更改后的登陆状态
 *  @param userId        当前登陆的userId
 */
- (void)upDataWithNoLogingFromlogingState:(NSString *)logingState toLogingState:(NSString *)toLogingState andUserId:(NSString *)userId;




@end
