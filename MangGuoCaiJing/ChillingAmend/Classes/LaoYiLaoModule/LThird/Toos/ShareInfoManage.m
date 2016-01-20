//
//  ShareInfoManage.m
//  LaoYiLao
//
//  Created by sunsu on 15/11/16.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "ShareInfoManage.h"

@implementation ShareInfoManage
+ (void)shareWithType:(ShareType)type andContentStr:(NSString *)contentStr andViewController:(LaoYiLaoBaseViewController *)viewController{
    
    [LYLTools showloadingProgressView];
    
    NSString *requestUrl = @"";
    if(type == ShareTypeWithMainBounce){// 奖励次数的分享接口 捞饺子的弹框
        
        [LYLTools removeDumplingInforOfFailure];
        if([[ZHDataBase sharedDataBase]selectLogingstateWithReturnTodayCount:@"1" andUserId:LYLUserId] == 0){
            [LYLTools showInfoAlert:@"没有可分享饺子"];
        }else{
            
            
            NSMutableArray *dumplingInforArray = [[ZHDataBase sharedDataBase]selectLogingStateWithReturnDumplingInfor:@"1" andUserId:LYLUserId];
            CGFloat totalMoney = [[ZHDataBase sharedDataBase]selectLogingstateWithReturnTodayTotalMoney:@"1"andUserId:LYLUserId];
            
            DumplingInforModel *lastModel = (DumplingInforModel *)[dumplingInforArray lastObject];
            NSString * starName = lastModel.resultListModel.dumplingModel.putUser;
            NSString * starIcon = lastModel.resultListModel.dumplingModel.userImg;
            if([lastModel.resultListModel.dumplingModel.dumplingType isEqualToString:@"3"]){//是不是优惠劵
                //                [LYLTools showHint:@"分享当前优惠劵"];
                
                NSError *error ;
                NSDictionary * shareInfoDic = @{@"@starName":starName,@"@prizeMoney":[NSString stringWithFormat:@"%@",lastModel.resultListModel.dumplingModel.prizeInfo]};
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:shareInfoDic options:NSJSONWritingPrettyPrinted error:&error];
                NSString *parameter_des =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                requestUrl = [LYLHttpTool getShareInfoWithTempid:@"10006" andProduct:@"" andShareplat:@"all" andPicurl:starIcon andParameterdes:parameter_des];
            }else{
                NSError *error ;
                NSDictionary * shareInfoDic = @{@"@starName":starName,@"@prizeMoney":[NSString stringWithFormat:@"%.2f",totalMoney]};
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:shareInfoDic options:NSJSONWritingPrettyPrinted error:&error];
                NSString *parameter_des =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                requestUrl = [LYLHttpTool getShareInfoWithTempid:@"10002" andProduct:@"" andShareplat:@"all" andPicurl:starIcon andParameterdes:parameter_des];
            }
        }
        
    }else if (type == ShareTypeWithScoopDumplingActivity){//导航的分享 分享捞一捞活动
        
        requestUrl = [LYLHttpTool getShareInfoWithTempid:@"10001" andProduct:@"" andShareplat:@"all" andPicurl:@"" andParameterdes:@""];
        
    }else if (type == ShareTypeWithShowOff){//炫耀一下分享  即我的饺子界面的炫耀一下
        
        NSError *error ;
        NSDictionary * shareInfoDic = @{@"@allMoney":contentStr};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:shareInfoDic options:NSJSONWritingPrettyPrinted error:&error];
        NSString *parameter_des =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        requestUrl = [LYLHttpTool getShareInfoWithTempid:@"10003" andProduct:@"" andShareplat:@"all" andPicurl:@"" andParameterdes:parameter_des];
        
    }else if (type == ShareTypeWithSendCashDumpling){//发送现金饺子分享 即包完现金饺子后的分享
     
        requestUrl = [LYLHttpTool getShareInfoWithTempid:@"10004" andProduct:@"" andShareplat:@"all" andPicurl:@"" andParameterdes:@""];
        
    }else if (type == ShareTypeWithMakeDumplingActivity){// 包饺子活动分享 即包饺子首页导航分享
        
        requestUrl = [LYLHttpTool getShareInfoWithTempid:@"10005" andProduct:@"" andShareplat:@"all" andPicurl:@"" andParameterdes:@""];
        
    }
    
    
    
    
    [LYLAFNetWorking postWithBaseURL:requestUrl success:^(id json) {
        [LYLTools hideloadingProgressView];
        ZHLog(@"ShareType == %ld,%@",type,json);
        int  code = [[json objectForKey:@"code"]intValue];
        switch (code) {
            case 100://成功
            {
                NSDictionary * resultListDict = [(NSDictionary *)json objectForKey:@"resultList"];
                NSString * content = [resultListDict objectForKey:@"content"];
                NSString * jsonUrl = [resultListDict objectForKey:@"url"];
                NSString * proUrl;
                
                if(type == ShareTypeWithSendCashDumpling){
                    jsonUrl = [NSString stringWithFormat:@"%@/?name=%@&productCode=%@&pannikin_id=%@",jsonUrl,LYLPhone,ProductCode,contentStr];
                    proUrl = [NSString stringWithFormat:@"%@",jsonUrl];
                }else{
                    if ([jsonUrl rangeOfString:@"http://"].location != NSNotFound) {
                        
                    }else{
                        jsonUrl = [@"http://" stringByAppendingString:jsonUrl];
                    }
                    proUrl = [NSString stringWithFormat:@"%@?productCode=%@",jsonUrl,ProductCode];
                }
                NSString * picUrl = [resultListDict objectForKey:@"picurl"];
                NSString * title = [resultListDict objectForKey:@"title"]; //饺子捞起来~我包！众明星携手为你包饺子，捞一捞，2亿现金等你拿！~;//待产品确定分享内容
                NSString * newTitle = [NSString stringWithFormat:@"%@ %@",content,proUrl];
                
                [viewController selfWithSubVC:viewController];
                [viewController baseShareText:content withUrl:proUrl withContent:content withImageName:picUrl ImgStr:picUrl domainName:@"" withqqTitle:title withqqZTitle:title withweCTitle:title withweChtTitle:title withsinaTitle:newTitle];
            }
                break;
            case 102:
            {
                [LYLTools showInfoAlert:json[@"message"]];
            }
                break;
                
                
            default:
                break;
        }
    } failure:^(NSError *error) {
        [LYLTools hideloadingProgressView];
        [LYLTools showInfoAlert:@"网络状态不佳"];
    }];
    

    
}

////          1. 奖励次的分享接口 捞饺子的弹框  2.导航的分享 分享捞一捞活动 3.炫耀一下的分享，分享饺子的
//+ (void)shareWithType:(NSString *)type andContentStr:(NSString *)contentStr andViewController:(LaoYiLaoBaseViewController *)viewController{
//
//    [LYLTools showloadingProgressView];
//
//    NSString *requestUrl = @"";
//    if([type isEqualToString:@"1"]){//1. 奖励次的分享接口 捞饺子的弹框
// 
//        [LYLTools removeDumplingInforOfFailure];
//        if([[ZHDataBase sharedDataBase]selectLogingstateWithReturnTodayCount:@"1" andUserId:LYLUserId] == 0){
//            [LYLTools showInfoAlert:@"没有可分享饺子"];
//        }else{
//
//           
//            NSMutableArray *dumplingInforArray = [[ZHDataBase sharedDataBase]selectLogingStateWithReturnDumplingInfor:@"1" andUserId:LYLUserId];
//            CGFloat totalMoney = [[ZHDataBase sharedDataBase]selectLogingstateWithReturnTodayTotalMoney:@"1"andUserId:LYLUserId];
//            
//            DumplingInforModel *lastModel = (DumplingInforModel *)[dumplingInforArray lastObject];
//            NSString * starName = lastModel.resultListModel.dumplingModel.putUser;
//            NSString * starIcon = lastModel.resultListModel.dumplingModel.userImg;
//            if([lastModel.resultListModel.dumplingModel.dumplingType isEqualToString:@"3"]){//是不是优惠劵
////                [LYLTools showHint:@"分享当前优惠劵"];
//                
//                NSError *error ;
//                NSDictionary * shareInfoDic = @{@"@starName":starName,@"@prizeMoney":[NSString stringWithFormat:@"%@",lastModel.resultListModel.dumplingModel.prizeInfo]};
//                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:shareInfoDic options:NSJSONWritingPrettyPrinted error:&error];
//                NSString *parameter_des =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//                
//                requestUrl = [LYLHttpTool getShareInfoWithTempid:@"10006" andProduct:@"" andShareplat:@"all" andPicurl:starIcon andParameterdes:parameter_des];
//            }else{
//                NSError *error ;
//                NSDictionary * shareInfoDic = @{@"@starName":starName,@"@prizeMoney":[NSString stringWithFormat:@"%.2f",totalMoney]};
//                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:shareInfoDic options:NSJSONWritingPrettyPrinted error:&error];
//                NSString *parameter_des =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//                
//                requestUrl = [LYLHttpTool getShareInfoWithTempid:@"10002" andProduct:@"" andShareplat:@"all" andPicurl:starIcon andParameterdes:parameter_des];
//            }
//        }
//
//    }else if ([type isEqualToString:@"2"]){//2.导航的分享 分享活动
//        
//        requestUrl = [LYLHttpTool getShareInfoWithTempid:@"10001" andProduct:@"" andShareplat:@"all" andPicurl:@"" andParameterdes:@""];
//        
//    }else if ([type isEqualToString:@"3"]){//
//    
//        NSError *error ;
//        NSDictionary * shareInfoDic = @{@"@allMoney":contentStr};
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:shareInfoDic options:NSJSONWritingPrettyPrinted error:&error];
//        NSString *parameter_des =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        
//        requestUrl = [LYLHttpTool getShareInfoWithTempid:@"10003" andProduct:@"" andShareplat:@"all" andPicurl:@"" andParameterdes:parameter_des];
//    }else if ([type isEqualToString:@"4"]){
//        requestUrl = [LYLHttpTool getShareInfoWithTempid:@"10004" andProduct:@"" andShareplat:@"all" andPicurl:@"" andParameterdes:@""];
//    }else if ([type isEqualToString:@"5"]){
//        requestUrl = [LYLHttpTool getShareInfoWithTempid:@"10005" andProduct:@"" andShareplat:@"all" andPicurl:@"" andParameterdes:@""];
//    }
//    
//    
//    
//    
//    [LYLAFNetWorking postWithBaseURL:requestUrl success:^(id json) {
//        [LYLTools hideloadingProgressView];
//        ZHLog(@" 1. 奖励次的分享接口 2.导航的分享 3.炫耀一下的分享 4.分享包好的饺子   5.导航分享 分享包饺子活动 type ==%@,%@",type,json);
//        int  code = [[json objectForKey:@"code"]intValue];
//        switch (code) {
//            case 100://成功
//            {
//                ZHLog(@"4.分享包好的饺子 === %@",json);
//                NSDictionary * resultListDict = [(NSDictionary *)json objectForKey:@"resultList"];
//                NSString * content = [resultListDict objectForKey:@"content"];
//                NSString * jsonUrl = [resultListDict objectForKey:@"url"];
//                NSString * proUrl;
//
//                if([type isEqualToString:@"4"]){
//                    jsonUrl = [NSString stringWithFormat:@"%@/?name=%@&productCode=%@&pannikin_id=%@",jsonUrl,LYLPhone,ProductCode,contentStr];
//                    proUrl = [NSString stringWithFormat:@"%@",jsonUrl];
//                }else{
//                    if ([jsonUrl rangeOfString:@"http://"].location != NSNotFound) {
//                        
//                    }else{
//                        jsonUrl = [@"http://" stringByAppendingString:jsonUrl];
//                    }
//                    proUrl = [NSString stringWithFormat:@"%@?productCode=%@",jsonUrl,ProductCode];
//                }
//                NSString * picUrl = [resultListDict objectForKey:@"picurl"];
//                NSString * title = [resultListDict objectForKey:@"title"]; //饺子捞起来~我包！众明星携手为你包饺子，捞一捞，2亿现金等你拿！~;//待产品确定分享内容
//                NSString * newTitle = [NSString stringWithFormat:@"%@ %@",content,proUrl];
//                [viewController baseShareText:content withUrl:proUrl withContent:content withImageName:picUrl ImgStr:picUrl domainName:@"" withqqTitle:title withqqZTitle:title withweCTitle:title withweChtTitle:title withsinaTitle:newTitle];
//
//            }
//                break;
//            case 102:
//            {
//                [LYLTools showInfoAlert:json[@"message"]];
//            }
//                break;
//                
//                
//            default:
//                break;
//        }
//    } failure:^(NSError *error) {
//        [LYLTools hideloadingProgressView];
//        [LYLTools showInfoAlert:@"网络状态不佳"];
//    }];
//
//
//}
@end
