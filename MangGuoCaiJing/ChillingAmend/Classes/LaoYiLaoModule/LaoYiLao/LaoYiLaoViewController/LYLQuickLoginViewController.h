//
//  LYLQuickLoginViewController.h
//  LaoYiLao
//
//  Created by sunsu on 15/11/7.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickLoginView.h"
/**
 *  进入当前界面的类型
 */
typedef NS_ENUM(NSUInteger, EnterType) {
    /**
     *  包饺子
     */
    EnterTypeMakeDumpilng = 1,
    /**
     *  我得饺子
     */
    EnterTypeMyDumpling,
    /**
     *  我得钱包
     */
    EnterTypeMyWallect,
    /**
     *  首页弹框
     */
    EnterTypeMainWithBounce,
    /**
     *  首页领取钱
     */
    EnterTypeMainWithGetMoney,
    /**
     *  首页投票
     */
    EnterTypeMainWithVote,
    /**
     *  其它
     */
    EnterTypeOther

};

@interface LYLQuickLoginViewController : UIViewController<QuickLoginViewDelegate>
//必须实现
@property (nonatomic, copy) void(^backBlock)();

//必须给一种
@property (nonatomic, assign) EnterType enterType;

///**
// *  0.包饺子(投票) 1 首页我的饺子 （默认领取不弹领取成功） 2.首页我得钱包 
// */
//@property (nonatomic, strong) NSString *type;
@end
