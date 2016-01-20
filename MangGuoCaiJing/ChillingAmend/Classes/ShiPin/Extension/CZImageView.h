//
//  CZImageView.h
//  fanxiaoqi
//
//  Created by ZCS on 15/9/25.
//  Copyright (c) 2015年 sinoglobal. All rights reserved.
//

#import <UIKit/UIKit.h>
//IB_DESIGNABLE 显示实时效果
IB_DESIGNABLE
@interface CZImageView : UIImageView
@property (nonatomic, assign)  CGFloat cornerRadius;
@property (nonatomic, assign)  CGFloat borderWidth;
@property (nonatomic, strong)  UIColor *borderColor;
@end
