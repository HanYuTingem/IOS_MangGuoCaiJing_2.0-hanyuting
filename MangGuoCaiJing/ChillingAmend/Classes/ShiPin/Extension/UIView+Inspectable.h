//
//  UIView+Inspectable.h
//  SinaWeiBo
//
//  Created by 朱长昇 on 15/7/12.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Inspectable)
//IBInspectable 显示到属性页面
/** 圆角半径 */
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
/** 边线宽 */
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
/** 边线颜色 */
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

@end
