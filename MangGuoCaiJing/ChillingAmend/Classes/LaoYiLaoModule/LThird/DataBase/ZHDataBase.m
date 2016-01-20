//
//  ZHDataBase.m
//  LaoYiLao
//
//  Created by wzh on 15/12/15.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "ZHDataBase.h"

@implementation ZHDataBase{
    FMDatabase *_dataBase;
}


static ZHDataBase *_sharedDataBase;
+ (ZHDataBase *)sharedDataBase{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedDataBase = [[ZHDataBase alloc]init];
    });
    return _sharedDataBase;
}

/**
 *  数据库路径
 *
 *  @return 数据库路径
 */
- (NSString *)tableWithPath{
    return [NSString stringWithFormat:@"%@/Library/Caches/dumplingInfor.db",NSHomeDirectory()];
}
/**
 *  数据库中饺子表的名字
 *
 *  @return  数据库中饺子表的名字
 */
- (NSString *)dumplingTableWithName{
    return @"dumplingInforTable";
}
- (void)createDataBase{
    NSLog(@"%@",NSHomeDirectory());
    _dataBase = [[FMDatabase alloc]initWithPath: [self tableWithPath]];
    if([_dataBase open]){
        ZHLog(@"打开数据库成功");
    }else{
        ZHLog(@"打开数据库失败");
    }
    ZHLog(@"数据库路径%@",[self tableWithPath]);
}
- (void)createDumplingInforTable{
    [_dataBase open];
    if([_dataBase executeUpdate:@"create table dumplingInforTable(logingState text,userId text,createDate text,dumplingType text,prizeAmount text,prizeId text,prizeInfo text,sessionValue text,status text,sysType text,isMarkShare text,starIcon text,starName text,userHasNum text,userImg text,putUser text)"]){
        ZHLog(@"创建饺子信息表成功");
    }else{
        ZHLog(@"创建饺子信息表失败");
    }
    [_dataBase close];

}

- (void)addColumnForTableWithColumnName:(NSString *)columnName{
    //判断字段是否存在
    [_dataBase open];
    if (![_dataBase columnExists:columnName inTableWithName:[self dumplingTableWithName]]){
        NSString *sql = [NSString stringWithFormat:@"alter table %@ add %@ text",[self dumplingTableWithName],columnName];
        ZHLog(@"%@",sql);
        if([_dataBase executeUpdate:sql]){
            ZHLog(@"插入了新字段%@成功",columnName);
        }else{
            ZHLog(@"插入了新字段%@失败",columnName);
        }
    }
    [_dataBase close];
}

- (void)insertWithModel:(DumplingInforModel *)dumplingInforModel logingState:(NSString *)logingState andUserId:(NSString *)userId{
    [_dataBase open];
    [_dataBase executeUpdate:@"insert into dumplingInforTable values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",logingState,userId,dumplingInforModel.resultListModel.dumplingModel.createDate,dumplingInforModel.resultListModel.dumplingModel.dumplingType,dumplingInforModel.resultListModel.dumplingModel.prizeAmount,dumplingInforModel.resultListModel.dumplingModel.prizeId,dumplingInforModel.resultListModel.dumplingModel.prizeInfo,dumplingInforModel.resultListModel.dumplingModel.sessionValue,dumplingInforModel.resultListModel.dumplingModel.status,dumplingInforModel.resultListModel.dumplingModel.sysType,dumplingInforModel.resultListModel.isMarkShare,dumplingInforModel.resultListModel.starIcon,dumplingInforModel.resultListModel.starName,dumplingInforModel.resultListModel.userHasNum,dumplingInforModel.resultListModel.dumplingModel.userImg,dumplingInforModel.resultListModel.dumplingModel.putUser];
    [_dataBase close];
    if([logingState isEqualToString:@"1"]){
        ZHLog(@"插入了登陆下的饺子一条信息");
    }else{
        ZHLog(@"插入了未登陆下的饺子一条信息");

    }
}

    
- (BOOL)deleWithLogingState:(NSString *)logingState{
    
    [_dataBase open];
    NSString *sql = @"delete from dumplingInforTable where logingState = ?";
    BOOL b = [_dataBase executeUpdate:sql,logingState];
    [_dataBase close];
    return b;
}

- (FMResultSet *)selectLogingstateWithReturnFMResultSet:(NSString*)logingState andUserId:(NSString *)userId{
    [_dataBase open];
    FMResultSet *set;
    if([logingState isEqualToString:@"0"]){
        set = [_dataBase executeQuery:@"select * from dumplingInforTable where logingState = ?",logingState];
    }else if([logingState isEqualToString:@"1"]){
        set = [_dataBase executeQuery:@"select * from dumplingInforTable where logingState = ? and userId=?",logingState,userId];
        
    }
    return set;
}

- (CGFloat)selectLogingstateWithReturnTodayTotalMoney:(NSString*)logingState andUserId:(NSString *)userId{
    
    FMResultSet *set =  [self selectLogingstateWithReturnFMResultSet:logingState andUserId:userId];
    CGFloat todayTotalMoney = 0.00;
    while ([set next]) {
        if([[set stringForColumn:@"dumplingType"] isEqualToString:DumplingTypeMoney]){
            todayTotalMoney =  todayTotalMoney + [[set stringForColumn:@"prizeAmount"] floatValue];
        }
    }
    ZHLog(@"今日捞到的总金额todayTotalMoney ===== %f 登陆状态logingState == %@",todayTotalMoney , logingState);
    [_dataBase close];
    return todayTotalMoney;
}

- (int)selectLogingstateWithReturnTodayCouponCount:(NSString*)logingState andUserId:(NSString *)userId{
    FMResultSet *set =  [self selectLogingstateWithReturnFMResultSet:logingState andUserId:userId];
    int couponCount = 0;
    while ([set next]) {
        NSString *dumpingType = [set stringForColumn:@"dumplingType"];
        if([dumpingType isEqualToString:DumplingTypePlatformCoupon] || [dumpingType isEqualToString:DumplingTypeGoodsCoupon] || [dumpingType isEqualToString:DumplingTypeThirdCoupon] || [dumpingType isEqualToString:DumplingTypeMerchantsCoupon]){//3=平台优惠券；4=商品优惠券；5=第三方优惠券;6=商家优惠券
            couponCount ++;
        }
    }
    ZHLog(@"优惠劵数量couponCount ===== %d  登陆状态logingState == %@",couponCount,logingState);
    [_dataBase close];
    return couponCount;
}

- (int)selectLogingstateWithReturnTodayGreetingCardCount:(NSString*)logingState andUserId:(NSString *)userId{
    FMResultSet *set =  [self selectLogingstateWithReturnFMResultSet:logingState andUserId:userId];
    int greetingCardCount = 0;
    while ([set next]) {
        if([[set stringForColumn:@"dumplingType"] isEqualToString:DumlingTypeGreetingCard]){
            greetingCardCount ++;
        }
    }
    ZHLog(@"贺卡数量greetingCardCount ===== %d 登陆状态logingState == %@",greetingCardCount,logingState);
    [_dataBase close];
    return greetingCardCount;
}


- (NSMutableArray *)selectLogingStateWithReturnDumplingInfor:(NSString *)logingState andUserId:(NSString *)userId{
    
    FMResultSet *set  =  [self selectLogingstateWithReturnFMResultSet:logingState andUserId:userId];
    //遍历结果集
    NSMutableArray *mutarray = [NSMutableArray array];
    while ([set next]) {
        DumplingInforModel *model = [[DumplingInforModel alloc]init];
        DumplingInforResultModel *resultListModel = [[DumplingInforResultModel alloc]init];
        
        resultListModel.isMarkShare = [set stringForColumn:@"isMarkShare"];
        resultListModel.starIcon = [set stringForColumn:@"starIcon"];
        resultListModel.starName = [set stringForColumn:@"starName"];
        resultListModel.userHasNum = [set stringForColumn:@"userHasNum"];

        DumplingInforDetailResultDumplingModel * dumplingModel = [[DumplingInforDetailResultDumplingModel alloc]init];
        dumplingModel.createDate = [set stringForColumn:@"createDate"];
        dumplingModel.dumplingType = [set stringForColumn:@"dumplingType"];
        dumplingModel.prizeAmount = [set stringForColumn:@"prizeAmount"];
        dumplingModel.prizeId = [set stringForColumn:@"prizeId"];
        dumplingModel.prizeInfo = [set stringForColumn:@"prizeInfo"];
        dumplingModel.sessionValue = [set stringForColumn:@"sessionValue"];
        dumplingModel.status = [set stringForColumn:@"status"];
        dumplingModel.sysType =[set stringForColumn:@"sysType"];
        dumplingModel.userImg = [set stringForColumn:@"userImg"];
        dumplingModel.putUser = [set stringForColumn:@"putUser"];
        resultListModel.dumplingModel = dumplingModel;
        [model setResultListModel: resultListModel];

        [mutarray addObject:model];
    }

    [_dataBase close];

    return mutarray;
}
- (int)selectLogingstateWithReturnTodayCount:(NSString*)logingState andUserId:(NSString *)userId{
    
    FMResultSet *set = [self selectLogingstateWithReturnFMResultSet:logingState andUserId:userId];
    int count = 0;
    while ([set next]) {
        count ++ ;
    }
    NSLog(@"count ===== %d",count);
    [_dataBase close];
    return count;

}

- (void)upDataWithNoLogingFromlogingState:(NSString *)logingState toLogingState:(NSString *)toLogingState andUserId:(NSString *)userId{
    [_dataBase open];    
//    [_dataBase executeUpdate:@"update dumplingInforTable set logingState = ?,userId = ? where logingState = ? and userId = ?",toLogingState,userId,logingState,NULL]
   BOOL set =  [_dataBase executeUpdate:@"update dumplingInforTable set logingState = ?,userId = ? where status = ? and logingState = ?",toLogingState,userId,@"1",
            logingState];
    if (set == NO) {
        ZHLog(@"修改失败");
    }else{
        ZHLog(@"领取成功后将未登录数据修改为已登录信息成功");
    }
    [_dataBase close];

}



@end
