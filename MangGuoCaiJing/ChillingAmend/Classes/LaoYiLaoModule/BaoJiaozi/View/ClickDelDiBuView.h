//
//  ClickDelDiBuView.h
//  LaoYiLao
//
//  Created by liujinhe on 15/12/11.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  底部广告View
 */
@interface ClickDelDiBuView : UIView
@property (nonatomic, strong) UIButton *morewBtn;

@property (nonatomic, copy) void(^bummBtnBlock)(UIButton *button);
@end
