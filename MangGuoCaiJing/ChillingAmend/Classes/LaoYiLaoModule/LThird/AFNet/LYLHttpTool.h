//
//  SINOHttptool.h
//  AFNetWorking
//
//  Created by 许文波 on 15/10/14.
//  Copyright (c) 2015年 GDH. All rights reserved.


/*--------  可以把我们请求的参数放在此类中 ----------*/

#import <Foundation/Foundation.h>
@interface LYLHttpTool : NSObject


///**
// *  返回请求体
// *
// *  @return 请求体参数
// */
//+(NSDictionary *)nowDumplingNumber;

/**
 *  1001. 显示当前饺子剩余总数量
 *
 *  @param productCode  产品标识
 *  @param sysType       /渠道：1 H5，2 Android，3 IOS
 *  @param sessionValue /浏览器用cookie ,APP用IMEI
 *
 *  @return 显示当前饺子剩余总数量
 */
+ (NSString *)currentDumplingWithNumberProductCode:(NSString *)productCode sysType:(NSString *)sysType andSessionValue:(NSString *)sessionValue;

/**
 *  1002. 捞饺子用户列表(按时间倒序)
 *
 *  @param productCode  产品标识
 *  @param sysType      /渠道：1 H5，2 Android，3 IOS
 *  @param sessionValue /浏览器用cookie ,APP用IMEI
 *
 *  @return 捞饺子用户列表(按时间倒序)
 */
+ (NSString *)userDumplingListWithProductCode:(NSString *)productCode sysType:(NSString *)sysType andSessionValue:(NSString *)sessionValue;


/**
 *  1003. 查询用户包/捞的饺子列表(一期不做)
 *
 *  @param productCode  产品标识
 *  @param sysType      /渠道：1 H5，2 Android，3 IOS
 *  @param sessionValue /浏览器用cookie ,APP用IMEI
 *
 *  @return 查询用户包/捞的饺子列表(一期不做)
 */
+ (NSString *)searchDumplingListWithProductCode:(NSString *)productCode sysType:(NSString *)sysType andSessionValue:(NSString *)sessionValue;


/**
 *  1004. 标记分享1次
 *
 *  @param userId       用户id（主键）
 *  @param productCode  产品标识*
 *  @param sysType      渠道：1 H5，2 Android，3 IOS
 *  @param sessionValue 浏览器用cookie ,APP用IMEI
 *
 *  @return 标记分享1次
 */
+ (NSString *)markShareWithUserId:(NSString *)userId productCode:(NSString *)productCode sysType:(NSString *)sysType andSessionValue:(NSString *)sessionValue;


/**
 *  1005增加捞饺子机会接口 (在前段和APP页面第一次请求捞一捞页面 登陆状态)
 *
 *  @param userId       用户id（主键）
 *  @param productCode  产品标识*
 *  @param sysType      渠道：1 H5，2 Android，3 IOS
 *  @param sessionValue 浏览器用cookie ,APP用IMEI
 *  @return 增加捞饺子机会接口 (在前段和APP页面第一次请求捞一捞页面 登陆状态)
 */
+ (NSString *)addDumplingNuumberWithUserId:(NSString *)userId productCode:(NSString *)productCode sysType:(NSString *)sysType andSessionValue:(NSString *)sessionValue;

/**
 *  1006登陆用户捞饺子
 *
 *  @param userId       用户id（主键）
 *  @param productCode  产品标识*
 *  @param sysType      渠道：1 H5，2 Android，3 IOS
 *  @param sessionValue 浏览器用cookie ,APP用IMEI
 *
 *  @return 登陆用户捞饺子
 */
+ (NSString *)logingUserDumplingWithUserId:(NSString *)userId logingPhone:(NSString *)logingPhone productCode:(NSString *)productCode sysType:(NSString *)sysType andSessionValue:(NSString *)sessionValue;

/**
 *  1007未登录获取捞饺子上限
 *
 *  @param productCode  产品标识*
 *  @param sysType      /渠道：1 H5，2 Android，3 IOS
 *  @param sessionValue /浏览器用cookie ,APP用IMEI
 *
 *  @return 未登录获取捞饺子上限url
 */
+ (NSString *)noLogingNumberCeilingWithProductCode:(NSString *)productCode sysType:(NSString *)sysType andSessionValue:(NSString *)sessionValue;


/**
 *  1008未登陆用户捞饺子
 *
 *  @param productCode  产品标识*
 *  @param sysType      /渠道：1 H5，2 Android，3 IOS
 *  @param sessionValue /浏览器用cookie ,APP用IMEI
 *
 *  @return 未登陆用户捞饺子
 */
+ (NSString *)noLogingUserDumplingWithProductCode:(NSString *)productCode sysType:(NSString *)sysType andSessionValue:(NSString *)sessionValue;


/**
 *  1009未登录用户登陆领取接口
 *
 *  @param productCode  产品标识*
 *  @param sysType      /渠道：1 H5，2 Android，3 IOS
 *  @param sessionValue /浏览器用cookie ,APP用IMEI
 *  @param phone        手机号*
 *  @param userId         userID
 *  @param prizeidList  饺子ID(多个逗号分隔)
 *
 *  @return 未登录用户登陆领取接口
 */
+ (NSString *)noLogingGetMoneyWithProductCode:(NSString *)productCode sysType:(NSString *)sysType sessionValue:(NSString *)sessionValue phone:(NSString *)phone prizeidList:(NSString *)prizeidList andUserId:(NSString *)userId;

/**
 *  1010我的饺子
 *
 *  @param productCode  产品标识*
 *  @param sysType      /渠道：1 H5，2 Android，3 IOS
 *  @param sessionValue /浏览器用cookie ,APP用IMEI
 *
 *  @return 我的饺子
 */
//+ (NSString *)myDumplingWithProductCode:(NSString *)productCode sysType:(NSString *)sysType andSessionValue:(NSString *)sessionValue andUserId:(NSString*)userId;
+ (NSString *)myDumplingWithProductCode:(NSString *)productCode sysType:(NSString *)sysType andSessionValue:(NSString *)sessionValue andUserId:(NSString*)userId;
/**
 *  //发送登陆验证码
 *
 *  @param userName
 *  @param type     3.登录验证码
 *
 *  @return 发送登录验证码接口
 */
+ (NSString *)sendIdentifyCodeWithUserName:(NSString *)userName andType:(NSString*)type;



/**
 *  //JAVA验证码登陆
 *  @param NSString 用户名、验证码、产品标识
 *  @return 快速登录
 */
//+ (NSString *)quickLoginWithUserName:(NSString *)userName Pwd:(NSString *)pwd andpProIden:(NSString *)proIden;
+ (NSString *)quickLoginWithUserName:(NSString *)userName Vcode:(NSString *)vcode Type:(NSString*)type andpProIden:(NSString *)proIden;

/**
 *  PHP登陆
 *
 *  @param userId   <#userId description#>
 *  @param userName <#userName description#>
 *  @param sex      <#sex description#>
 *  @param nickName <#nickName description#>
 *  @param src      <#src description#>
 *  @param jifeng   <#jifeng description#>
 *  @param status   <#status description#>
 *  @param lat      <#lat description#>
 *  @param ing      <#ing description#>
 *  @param token    <#token description#>
 *
 *  @return <#return value description#>
 */
+ (NSMutableDictionary *)accessToLoginInformationUserId:(NSString *)userId userName:(NSString *)userName sex:(NSString *)sex nickName:(NSString *)nickName src:(NSString *)src jifen:(NSString *)jifeng status:(NSString *)status lat:(NSString *)lat ing:(NSString *)ing token:(NSString *)token;
/**
 *  获取用户协议和账号说明
 *
 *  @param type 协议类型 1.用户协议 2.服务协议
 *
 *  @return 获取用户协议
 */
+ (NSString *)getUserAndCountAgreementWithType:(NSString *)type;



/**
 *  获取分享内容接口
 *
 *  @param temp_id       模板ID  10001：活动分享  10002：饺子分享
 *  @param producid      产品标识
 *  @param share_plat    分享平台
 *  @param picurl        图片URL
 *  @param parameter_des 参数
 *
 *  @return 获取分享信息
 */
+ (NSString *)getShareInfoWithTempid:(NSString*)temp_id andProduct:(NSString *)producid andShareplat:(NSString *)share_plat andPicurl:(NSString *)picurl andParameterdes:(NSString *)parameter_des;




/***************************************************************************
                                二期
 ***************************************************************************/



/**
 *  用户包饺子生成小锅钱包订单去支付时调用
 {
 “userId”：“”//用户ID*
 “productCode”: //产品标识*
 “sysType”: “” ,   //渠道：1 H5，2 Android，3 IOS  *
 “sessionValue”: “” , //浏览器用cookie ,APP用IMEI *
 “dumplingMoney”: // 钱总数*
 “dumplingNum”: // 饺子个数*
 “content”: // 祝福语*
 }
 
 */

+ (NSString *)makeZhiFuDingDanPrefrs:(NSString *)dumplingMoney dumplingNum:(NSString *)dumplingNum andContent:(NSString *)content;
/**
 *  用户包饺子后查询支付状态-第三方支付（获取分享链接）
 */
+ (NSString *)shareEndandPayforEndPayId:(NSString*)dumpling_user_put_money_id;
/**
 *  选择支付方式后支付
 */
+ (NSDictionary *)payForChuodseWeesMeney:(NSString*)menyId andWithPaychnel:(NSString*)paychnel andWithPassword:(NSString*)password;
/**
 * 非余额支付
 *
 */
+ (NSDictionary *)payFeiForwweMeney:(NSString*)menyId andWithPaychnel:(NSString*)paychnel;



/**
 *  我的贺卡
 *
 *  @return 我的贺卡
 */
+ (NSString *)myGreetingCardWithSize:(NSString *)size page:(NSString *)page;
/**
 *  //3002 我包现金
 *
 *  @param size 每页多少条
 *  @param page 第几页
 *
 *  @return我包现金
 */
+ (NSString *)wobaoXianjinWithSize:(NSString *)size page:(NSString *)page;



/**
 *  3003我包现金明细
 *
 *  @param dumpling_user_put_card_id 小锅id
 *  @param size                      每页展示条数
 *  @param page                      页数
 *
 *  @return 3003我包现金明细
 */
+ (NSString *)makeDumplingDetailWithDumplingUserPutmoneytid:(NSString *)dumplingUserPutmoneytid;// size:(NSString *)size page:(NSString *)page;

//我包贺卡
+ (NSString *)wobaoHekaWithSize:(NSString *)size Page:(NSString *)page;

/**
 *  分享完饺子后改变饺子状态
 *
 *  @param pannikinId 小锅id
 *
 *  @return 分享完饺子后改变饺子状态
 */
+ (NSString *)changeDumplingStateWithPannikinId:(NSString *)pannikinId;
/**
 *  获得广告位列表
 *
 *  @param productCode  产品标识
 *  @param sysType      /渠道：1 H5，2 Android，3 IOS
 *  @param sessionValue /浏览器用cookie ,APP用IMEI
 *
 *  @return 获得广告位列表
 */
+ (NSString *)getAdvertisingListWithProductCode:(NSString *)productCode sysType:(NSString *)sysType sessionValue:(NSString *)sessionValue;


/**
 *  获取节目时间表
 *
 *  @param productCode  产品标识
 *  @param sysType      渠道：1 H5，2 Android，3 IOS  
 *  @param sessionValue /浏览器用cookie ,APP用IMEI
 *
 *  @return 获取节目时间表
 */
+ (NSString *)getTimeAxisWithProductCode:(NSString *)productCode sysType:(NSString *)sysType sessionValue:(NSString *)sessionValue;
/**
 *  2005 包贺卡(用户to用户,用户to有缘人)
 */
+ (NSString *)getNewCardDumplingWithPic:(NSString *)cardPic cardWish:(NSString*)cardWish sendType:(NSString*)sendType cardUrl:(NSString*)cardUrl;



@end
