//
//  CZImageView.m
//  fanxiaoqi
//
//  Created by ZCS on 15/9/25.
//  Copyright (c) 2015年 sinoglobal. All rights reserved.
//

#import "CZImageView.h"

@implementation CZImageView

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

- (void)setBorderColor:(UIColor*)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor*)borderColor
{
    return [[UIColor alloc] initWithCGColor:self.layer.borderColor];
}

@end
