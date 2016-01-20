//
//  SINOHttptool.m
//  AFNetWorking
//
//  Created by 许文波 on 15/10/14.
//  Copyright (c) 2015年 GDH. All rights reserved.
//

#import "LYLHttpTool.h"
#import "LYLTools.h"
#import "MyUrlAdress.h"
#include <CommonCrypto/CommonDigest.h>

@implementation LYLHttpTool

#define LYLIMEI  [MyUrlAdress imei]
/**
 *  字典转字符串
 *
 *  @param jsonMutdic 字典
 *
 *  @return 字符串
 */


+ (NSString *)urlWithJson:(NSMutableDictionary *)jsonMutdic{
    NSError *error ;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonMutdic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return json;
}

+ (NSString *)currentDumplingWithNumberProductCode:(NSString *)productCode sysType:(NSString *)sysType andSessionValue:(NSString *)sessionValue{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    [mutDic setObject:productCode forKey:@"productCode"];
    [mutDic setObject:sysType forKey:@"sysType"];
    [mutDic setObject:sessionValue forKey:@"sessionValue"];
    NSString * url = [NSString stringWithFormat:@"%@%@json=%@",URL_LYL_SERVER,NowDumplingNumber,[self urlWithJson:mutDic]];
    ZHLog(@"当前剩余饺子数量=%@",url);
    return url;
}

+ (NSString *)userDumplingListWithProductCode:(NSString *)productCode sysType:(NSString *)sysType andSessionValue:(NSString *)sessionValue{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    [mutDic setObject:productCode forKey:@"productCode"];
    [mutDic setObject:sysType forKey:@"sysType"];
    [mutDic setObject:sessionValue forKey:@"sessionValue"];
    NSString * url = [NSString stringWithFormat:@"%@%@json=%@",URL_LYL_SERVER,UserWithDumplingList,[self urlWithJson:mutDic]];
    ZHLog(@"捞饺子用户列表(按时间倒序) = %@",url);
    return url;
}

//一期不做
+ (NSString *)searchDumplingListWithProductCode:(NSString *)productCode sysType:(NSString *)sysType andSessionValue:(NSString *)sessionValue{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    [mutDic setObject:productCode forKey:@"productCode"];
    [mutDic setObject:sysType forKey:@"sysType"];
    [mutDic setObject:sessionValue forKey:@"sessionValue"];
    NSString * url = [NSString stringWithFormat:@"%@%@json=%@",URL_LYL_SERVER,SearchDoDumplingAndUserList,[self urlWithJson:mutDic]];
    return url;
}

+ (NSString *)markShareWithUserId:(NSString *)userId productCode:(NSString *)productCode sysType:(NSString *)sysType andSessionValue:(NSString *)sessionValue{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    [mutDic setObject:userId forKey:@"userId"];
    [mutDic setObject:productCode forKey:@"productCode"];
    [mutDic setObject:sysType forKey:@"sysType"];
    [mutDic setObject:sessionValue forKey:@"sessionValue"];
    NSString * url = [NSString stringWithFormat:@"%@%@json=%@",URL_LYL_SERVER,MarkShare,[self urlWithJson:mutDic]];
    ZHLog(@"%@",url);
    return url;
}

+ (NSString *)addDumplingNuumberWithUserId:(NSString *)userId productCode:(NSString *)productCode sysType:(NSString *)sysType andSessionValue:(NSString *)sessionValue{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    [mutDic setObject:userId forKey:@"userId"];
    [mutDic setObject:productCode forKey:@"productCode"];
    [mutDic setObject:sysType forKey:@"sysType"];
    [mutDic setObject:sessionValue forKey:@"sessionValue"];
//    [mutDic setObject:number forKeyedSubscript:@"number"];
    NSString * url = [NSString stringWithFormat:@"%@%@json=%@",URL_LYL_SERVER,AddNumberWithDumpling,[self urlWithJson:mutDic]];
    ZHLog(@"增加捞饺子机会接口 =%@",url);
    return url;
}

+ (NSString *)logingUserDumplingWithUserId:(NSString *)userId logingPhone:(NSString *)logingPhone productCode:(NSString *)productCode sysType:(NSString *)sysType andSessionValue:(NSString *)sessionValue;{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    [mutDic setObject:userId forKey:@"userId"];
    [mutDic setObject:productCode forKey:@"productCode"];
    [mutDic setObject:sysType forKey:@"sysType"];
    [mutDic setObject:sessionValue forKey:@"sessionValue"];
    [mutDic setObject:logingPhone forKey:@"phone"];
    NSString * url = [NSString stringWithFormat:@"%@%@json=%@",URL_LYL_SERVER,LogingUserWithDumpling,[self urlWithJson:mutDic]];
    ZHLog(@"%@",url);
    return url;
}

+ (NSString *)noLogingNumberCeilingWithProductCode:(NSString *)productCode sysType:(NSString *)sysType andSessionValue:(NSString *)sessionValue{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    [mutDic setObject:productCode forKey:@"productCode"];
    [mutDic setObject:sysType forKey:@"sysType"];
    [mutDic setObject:sessionValue forKey:@"sessionValue"];
    NSString * url = [NSString stringWithFormat:@"%@%@json=%@",URL_LYL_SERVER,NOLogingNumberCeiling,[self urlWithJson:mutDic]];
    ZHLog(@"%@",url);
    return url;
}

+ (NSString *)noLogingUserDumplingWithProductCode:(NSString *)productCode sysType:(NSString *)sysType andSessionValue:(NSString *)sessionValue{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    [mutDic setObject:productCode forKey:@"productCode"];
    [mutDic setObject:sysType forKey:@"sysType"];
    [mutDic setObject:sessionValue forKey:@"sessionValue"];
    NSString * url = [NSString stringWithFormat:@"%@%@json=%@",URL_LYL_SERVER,NOLogingWithDumpling,[self urlWithJson:mutDic]];
    ZHLog(@"%@",url);
    return url;
}

+ (NSString *)noLogingGetMoneyWithProductCode:(NSString *)productCode sysType:(NSString *)sysType sessionValue:(NSString *)sessionValue phone:(NSString *)phone prizeidList:(NSString *)prizeidList andUserId:(NSString *)userId{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    [mutDic setObject:productCode forKey:@"productCode"];
    [mutDic setObject:sysType forKey:@"sysType"];
    [mutDic setObject:sessionValue forKey:@"sessionValue"];
    [mutDic setObject:phone forKey:@"phone"];
    [mutDic setObject:prizeidList forKey:@"prizeidList"];
    [mutDic setObject:userId forKey:@"userId"];
    NSString * url = [NSString stringWithFormat:@"%@%@json=%@",URL_LYL_SERVER,NOLogingUserGetWithMoney,[self urlWithJson:mutDic]];
    ZHLog(@"%@",url);
    return url;
}


+ (NSString *)myDumplingWithProductCode:(NSString *)productCode sysType:(NSString *)sysType andSessionValue:(NSString *)sessionValue andUserId:(NSString*)userId{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    [mutDic setObject:userId forKey:@"userId"];
    [mutDic setObject:productCode forKey:@"productCode"];
    [mutDic setObject:sysType forKey:@"sysType"];
    [mutDic setObject:sessionValue forKey:@"sessionValue"];
    NSString * url = [NSString stringWithFormat:@"%@%@json=%@",URL_LYL_SERVER,MyDumpling,[self urlWithJson:mutDic]];
    return url;
}


+ (NSString *)sendIdentifyCodeWithUserName:(NSString *)userName andType:(NSString*)type{
    NSString * url = [NSString stringWithFormat:@"%@%@userName=%@&type=%@",URL_LYL_SINOCENTER,LYL_validateLogin,userName,type];
    ZHLog(@"%@",url);
    return url;
}

+ (NSString *)quickLoginWithUserName:(NSString *)userName Vcode:(NSString *)vcode Type:(NSString*)type andpProIden:(NSString *)proIden{
    NSString * url = [NSString stringWithFormat:@"%@%@userName=%@&vcode=%@&type=%@&proIden=%@",URL_LYL_SINOCENTER,LYL_QucikLogin,userName,vcode,type,proIden];
    ZHLog(@"%@",url);
    return url;
}

//php获取登陆信息
+ (NSMutableDictionary *)accessToLoginInformationUserId:(NSString *)userId userName:(NSString *)userName sex:(NSString *)sex nickName:(NSString *)nickName src:(NSString *)src jifen:(NSString *)jifeng status:(NSString *)status lat:(NSString *)lat ing:(NSString *)ing token:(NSString *)token {
//    NSLog(@"%@?por=%@&userId=%@&userName=%@&sex=%@&nickName=%@&src=%@&jifen=%@&status=%@&lat=%@&ing=%@&token=%@",ADDRESSPHP,@"9000",userId,userName,sex,nickName,src,jifeng,status,lat,ing,token);
    //需要我们初始化一个空间大小，用dictionaryWithCapacity
    NSMutableDictionary * mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:12];
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


+ (NSString *)getUserAndCountAgreementWithType:(NSString *)type{
    NSString * url = [NSString stringWithFormat:@"%@%@type=%@",URL_LYL_SINOCENTER,LYL_GetAgreement,type];
    ZHLog(@"用户协议url =%@",url);
    return url;
}

+ (NSString *)getShareInfoWithTempid:(NSString*)temp_id andProduct:(NSString *)producid andShareplat:(NSString *)share_plat andPicurl:(NSString *)picurl andParameterdes:(NSString *)parameter_des{
    
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    [mutDic setObject:temp_id forKey:@"temp_id"];
    [mutDic setObject:producid forKey:@"productid"];
    [mutDic setObject:share_plat forKey:@"share_plat"];
    [mutDic setObject:picurl forKey:@"picurl"];
    [mutDic setObject:parameter_des forKey:@"parameter_des"];
    NSString * url = [NSString stringWithFormat:@"%@%@json=%@",URL_LYL_SHARE,LYL_GetShareInfo,[self urlWithJson:mutDic]];
    ZHLog(@"%@",url);
    return url;
}





/***************************************************************************
                                    二期
 ***************************************************************************/


//生成订单
+ (NSString *)makeZhiFuDingDanPrefrs:(NSString *)dumplingMoney dumplingNum:(NSString *)dumplingNum andContent:(NSString *)content {
    NSMutableDictionary *trDic = [NSMutableDictionary dictionary];
    [trDic setObject:[NSString stringWithFormat:@"%@",LYLUserId] forKey:@"userId"];
    [trDic setObject:ProductCode forKey:@"productCode"];
    [trDic setObject:@"3" forKey:@"sysType"];
    [trDic setObject:LYLIMEI forKey:@"sessionValue"];
    [trDic setObject:dumplingMoney forKey:@"dumplingMoney"];
    [trDic setObject:dumplingNum forKey:@"dumplingNum"];
    [trDic setObject:content forKey:@"content"];
    [trDic setObject:LYLPhone forKey:@"phone"];
    NSString * url = [NSString stringWithFormat:@"%@%@?json=%@",URL_LYL_BaoCheDi,LYL_GetMakePretai,[self urlWithJson:trDic]];
    ZHLog(@"trDic==%@",trDic);
    return url;
    
}
// 生成分享链接
+ (NSString *)shareEndandPayforEndPayId:(NSString*)pannikinId{
    NSMutableDictionary *shareDiec = [NSMutableDictionary dictionary];
    [shareDiec setObject:[NSString stringWithFormat:@"%@",LYLUserId] forKey:@"userId"];
    [shareDiec setObject:ProductCode forKey:@"productCode"];
    [shareDiec setObject:@"3" forKey:@"sysType"];
    [shareDiec setObject:LYLIMEI forKey:@"sessionValue"];
    [shareDiec setObject:pannikinId forKey:@"pannikinId"];
    NSString *url = [NSString stringWithFormat:@"%@%@?json=%@",URL_LYL_BaoCheDi,LYL_GetPayShared,[self urlWithJson:shareDiec]];
    ZHLog(@"%@",url);
    return url;
    
}
//支付时余额支付
//“tradeId”:””//新增（密码解析标识）Android和IOS只有余额支付时，必填
+ (NSDictionary *)payForChuodseWeesMeney:(NSString*)menyId andWithPaychnel:(NSString*)paychnel andWithPassword:(NSString*)password{
    NSMutableDictionary *shsdeDiec = [NSMutableDictionary dictionary];
    [shsdeDiec setObject:[NSString stringWithFormat:@"%@",LYLUserId] forKey:@"userId"];
    [shsdeDiec setObject:ProductCode forKey:@"productCode"];
    [shsdeDiec setObject:@"3" forKey:@"sysType"];
    [shsdeDiec setObject:LYLIMEI forKey:@"sessionValue"];
    [shsdeDiec setObject:menyId forKey:@"pannikinId"];
    [shsdeDiec setObject:paychnel forKey:@"payChannel"];
    [shsdeDiec setObject:password forKey:@"password"];
    [shsdeDiec setObject:@"包饺子" forKey:@"goodName"];
    [shsdeDiec setObject:@"包饺子测试" forKey:@"goodDepice"];
    ZHLog(@"%@",shsdeDiec);
    return shsdeDiec;
}

//支付时非支付
+ (NSDictionary *)payFeiForwweMeney:(NSString*)menyId andWithPaychnel:(NSString*)paychnel{
    NSMutableDictionary *shsdeDiec = [NSMutableDictionary dictionary];
    [shsdeDiec setObject:[NSString stringWithFormat:@"%@",LYLUserId] forKey:@"userId"];
    [shsdeDiec setObject:ProductCode forKey:@"productCode"];
    [shsdeDiec setObject:@"3" forKey:@"sysType"];
    [shsdeDiec setObject:LYLIMEI forKey:@"sessionValue"];
    [shsdeDiec setObject:menyId forKey:@"pannikinId"];
    [shsdeDiec setObject:paychnel forKey:@"payChannel"];
    [shsdeDiec setObject:@"包饺子" forKey:@"goodName"];
    [shsdeDiec setObject:@"包饺子测试" forKey:@"goodDepice"];
//    ZHLog(@"%@",url);
    return shsdeDiec;
}

//我的贺卡
+ (NSString *)myGreetingCardWithSize:(NSString *)size page:(NSString *)page{
    NSMutableDictionary *shsdeDiec = [NSMutableDictionary dictionary];
    [shsdeDiec setObject:[NSString stringWithFormat:@"%d",101389] forKey:@"userId"];
    [shsdeDiec setObject:ProductCode forKey:@"productCode"];
    [shsdeDiec setObject:@"3" forKey:@"sysType"];
    [shsdeDiec setObject:LYLIMEI forKey:@"sessionValue"];
    [shsdeDiec setObject:size forKey:@"size"];
    [shsdeDiec setObject:page forKey:@"page"];
    
//    NSString *url = [NSString stringWithFormat:@"%@%@json=%@",URL_LYL_SERVER,LYL_MyGreetingCard,[self urlWithJson:shsdeDiec]];
    NSString *url = [NSString stringWithFormat:@"%@%@json=%@",@"http://192.168.30.66:8099/dumpling/",LYL_MyGreetingCard,[self urlWithJson:shsdeDiec]];
//    NSString * url = @"https://www.baidu.com";
    return url;
}

//我包现金
+ (NSString *)wobaoXianjinWithSize:(NSString *)size page:(NSString *)page{
    NSMutableDictionary *shsdeDiec = [NSMutableDictionary dictionary];
    [shsdeDiec setObject:LYLUserId forKey:@"userId"];
    [shsdeDiec setObject:ProductCode forKey:@"productCode"];
    [shsdeDiec setObject:@"3" forKey:@"sysType"];
    [shsdeDiec setObject:LYLIMEI forKey:@"sessionValue"];
    [shsdeDiec setObject:size forKey:@"size"];
    [shsdeDiec setObject:page forKey:@"page"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@json=%@",URL_LYL_SERVER,LYL_WobaoXianjin,[self urlWithJson:shsdeDiec]];

    return url;
}

+ (NSString *)makeDumplingDetailWithDumplingUserPutmoneytid:(NSString *)dumplingUserPutmoneytid{
    // size:(NSString *)size page:(NSString *)page{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    [mutDic setObject:[NSString stringWithFormat:@"%@",LYLUserId] forKey:@"userId"];
    [mutDic setObject:ProductCode forKey:@"productCode"];
    [mutDic setObject:SysType forKey:@"sysType"];
    [mutDic setObject:SessionValue forKey:@"sessionValue"];
//    [mutDic setObject:size forKey:@"size"];
//    [mutDic setObject:page forKey:@"page"];
    [mutDic setObject:dumplingUserPutmoneytid forKey:@"dumplingUserPutmoneytid"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@json=%@",URL_LYL_SERVER,LYL_MakeDumplingDetail,[self urlWithJson:mutDic]];
    ZHLog(@"3003我包现金明细 = %@",url);
    return url;

}

//我包贺卡
+ (NSString *)wobaoHekaWithSize:(NSString *)size Page:(NSString *)page{
    NSMutableDictionary *shsdeDiec = [NSMutableDictionary dictionary];
    [shsdeDiec setObject:LYLUserId forKey:@"userId"];
    [shsdeDiec setObject:ProductCode forKey:@"productCode"];
    [shsdeDiec setObject:@"3" forKey:@"sysType"];
    [shsdeDiec setObject:LYLIMEI forKey:@"sessionValue"];
    [shsdeDiec setObject:size forKey:@"size"];
    [shsdeDiec setObject:page forKey:@"page"];
    NSString *url = [NSString stringWithFormat:@"%@%@?json=%@",URL_LYL_SERVER,LYL_WobaoHeka,[self urlWithJson:shsdeDiec]];
    return url;
}
+ (NSString *)changeDumplingStateWithPannikinId:(NSString *)pannikinId{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    [mutDic setObject:pannikinId forKey:@"pannikinId"];
    NSString *url = [NSString stringWithFormat:@"%@%@json=%@",URL_LYL_SERVER,LYL_MarkShareChangeStatus,[self urlWithJson:mutDic]];
    ZHLog(@"%@",url);
    return url;

}

+ (NSString *)getAdvertisingListWithProductCode:(NSString *)productCode sysType:(NSString *)sysType sessionValue:(NSString *)sessionValue{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    [mutDic setObject:ProductCode forKey:@"productCode"];
    [mutDic setObject:SysType forKey:@"sysType"];
    [mutDic setObject:SessionValue forKey:@"sessionValue"];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",URL_LYL_SERVER,LYL_GetAdvertisingList,[self urlWithJson:mutDic]];
    ZHLog(@"广告位listUrl == %@",url);

    return url;
}

+ (NSString *)getTimeAxisWithProductCode:(NSString *)productCode sysType:(NSString *)sysType sessionValue:(NSString *)sessionValue{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    [mutDic setObject:productCode forKey:@"productCode"];
    [mutDic setObject:sysType forKey:@"sysType"];
    [mutDic setObject:sessionValue forKey:@"sessionValue"];
    NSString *url = [NSString stringWithFormat:@"%@%@json=%@",URL_LYL_SERVER,LYL_GetTimeAxis,[self urlWithJson:mutDic]];
    ZHLog(@"时间表listUrl == %@",url);

    return url;
}
/**
 *  2005 包贺卡(用户to用户,用户to有缘人)
 */
+ (NSString *)getNewCardDumplingWithPic:(NSString *)cardPic cardWish:(NSString*)cardWish sendType:(NSString*)sendType cardUrl:(NSString*)cardUrl{
    NSMutableDictionary *shareDiec = [NSMutableDictionary dictionary];
    [shareDiec setObject:[NSString stringWithFormat:@"%@",LYLUserId] forKey:@"userId"];
    [shareDiec setObject:ProductCode forKey:@"productCode"];
    [shareDiec setObject:@"3" forKey:@"sysType"];
    [shareDiec setObject:LYLIMEI forKey:@"sessionValue"];
    [shareDiec setObject:cardPic forKey:@"card_pic"];
    [shareDiec setObject:cardWish forKey:@"card_wish"];
    [shareDiec setObject:sendType forKey:@"send_type"];
    NSError *error ;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:shareDiec options:NSJSONWritingPrettyPrinted error:&error];
    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@dumpling/%@?json=%@",URL_LYL_qwyChas,cardUrl,[json stringByReplacingOccurrencesOfString:@"\\" withString:@""]];
    ZHLog(@"%@",url);
    return url;
}
@end
