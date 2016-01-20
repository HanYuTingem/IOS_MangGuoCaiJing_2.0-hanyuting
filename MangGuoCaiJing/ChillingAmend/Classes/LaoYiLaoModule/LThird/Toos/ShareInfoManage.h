//
//  ShareInfoManage.h
//  LaoYiLao
//
//  Created by sunsu on 15/11/16.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  分享类型
 */
typedef NS_ENUM(NSUInteger, ShareType) {
    /**
     *  捞饺子弹框分享
     */
    ShareTypeWithMainBounce = 1,
    /**
     *  捞一捞活动分享 即捞一捞界面导航分享
     */
    ShareTypeWithScoopDumplingActivity,
    /**
     *  包饺子活动分享 即包饺子首页导航分享
     */
    ShareTypeWithMakeDumplingActivity,
    /**
     *  炫耀一下分享  即我的饺子界面的炫耀一下
     */
    ShareTypeWithShowOff,
    /**
     *  发送现金饺子分享 即包完现金饺子后的分享
     */
    ShareTypeWithSendCashDumpling,
    /**
     *  发送贺卡饺子的分享 即包完贺卡饺子后的分享
     */
    ShareTypeWithSendGreetingCardDumpling
};


@interface ShareInfoManage : NSObject

/**
 *  点击弹出分享的操作
 *
 *  @param type           分享类型
 *  @param contentStr      ShareTypeWithShowOff 传 当前用户捞到的现金   ShareTypeWithSendCashDumpling  小锅id  其他 传空字符串即可
 *  @param viewController 调用分享的当前VC
 */
+ (void)shareWithType:(ShareType)type andContentStr:(NSString *)contentStr andViewController:(LaoYiLaoBaseViewController *)viewController;


@end
