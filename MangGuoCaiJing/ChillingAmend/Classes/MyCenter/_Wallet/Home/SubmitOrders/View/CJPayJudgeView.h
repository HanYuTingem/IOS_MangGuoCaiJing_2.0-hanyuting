//
//  CJPayJudgeView.h
//  Wallet
//
//  Created by zhaochunjing on 15-11-11.
//  Copyright (c) 2015年 Sinoglobal. All rights reserved.
//  支付密码的相关逻辑判断 (入口)

#import <UIKit/UIKit.h>
#import "CJTopUpPayModel.h"



/** 支付类型 */
typedef NS_ENUM(int, PayType) {
    PayTypeZhiFuBao = 0,
    PayTypeWeiXin,
    PayTypeUFu,
    PayTypeWallet
};

/** 状态 0失败 1成功 2关闭 3处理中 4待处理 */
typedef NS_ENUM(int, ResultPay) {
    /** 0失败 */
    ResultPayFailure = 0,
    /** 1成功 */
    ResultPaySucceed,
    /** 2关闭 */
    ResultPayClose,
    /** 3处理中 */
    ResultPayInHand,
    /** 4待处理 */
    ResultPayPending
};

@protocol CJPayJudgeViewDelegate <NSObject>

@optional
/** 密码验证 等逻辑判断 完成后的操作 encryptKey密钥  */
- (void)payJudgeViewSucceedFinishWithPassWord:(NSString *)passWord encryptKey:(NSString *)encryptKey ID:(NSString *)ID;
/** 充值类型的判断 返回的是 类型字符串 */
- (void)topUpJudgeViewSucceedFinishWithTopUpType:(PayType)topUpType payTypeModel:(CJTopUpPayModel *)payTypeModel;

/** 支付完成后的回调 payType判断的是否支付成功 */
- (void)payJudgeViewSucceedFinishPayWithPayType:(NSString *)payType;

@end


@class Wallet_BaseViewController;
@interface CJPayJudgeView : UIView<UITextFieldDelegate>

/** 金钱的提示框 判断 钱数  不能与moneyTextField并存 (充值) */
@property (nonatomic, copy) NSString *moneyText;
/** 有UITextField的情况 需要实现 代理 和负值  不能与moneyText并存 (提现) */
@property (nonatomic, strong) UITextField *moneyTextField;
@property (nonatomic, weak) id <CJPayJudgeViewDelegate> delegate;

/** 外面传入的订单号 */
@property (nonatomic, copy) NSString *requestStr;//

/** 单例  */
+ (CJPayJudgeView *)shareCJPayJudgeViewWithController:(Wallet_BaseViewController *)controller withRequestStr:(NSString *)requestStr;

/** 按钮的点击事件 逻辑判断入口 */
- (void)toCashBtnClick;

@end
