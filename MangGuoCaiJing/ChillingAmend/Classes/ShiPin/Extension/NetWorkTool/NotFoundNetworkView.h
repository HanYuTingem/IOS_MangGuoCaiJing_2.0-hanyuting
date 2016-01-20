//
//  NotFoundNetworkView.h
//  fanxiaoqi
//
//  Created by Li on 15/11/12.
//  Copyright © 2015年 sinoglobal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotFoundNetworkView : UIView

@property (nonatomic, strong) UILabel* upTipLabel;
@property (nonatomic, strong) UILabel* downTipLabel;
/**
 创建一个未发现网络连接的弹窗
 */
+ (NotFoundNetworkView*)createNotFoundNetworkView;

/**
 将弹窗显示在view上
 
 @param <view> 要显示弹窗的view
 */
- (void)showsOnView:(UIView*)view;

/**
 去除弹窗
 */
- (void)hides;

@end
