//
//  LJHShuRuView.h
//  LaoYiLao
//
//  Created by liujinhe on 15/12/9.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJHTextView.h"
/**
 *  输入框
 */
@interface LJHShuRuView : UIView
@property (nonatomic,strong)UILabel* cheHulabel;//名称
@property (nonatomic,strong)UILabel* danWeilabel;//单位
@property (nonatomic,strong)UITextField* shuRulabel;//名称
@property (nonatomic,strong)LJHTextView *textTlike;//留言
- (instancetype)initWithFrame:(CGRect)frame;
@end
