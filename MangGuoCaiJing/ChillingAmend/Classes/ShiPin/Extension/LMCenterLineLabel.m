//
//  LMCenterLineLabel.m
//  fanxiaoqi
//
//  Created by 李敏 on 15/9/18.
//  Copyright (c) 2015年 sinoglobal. All rights reserved.
//

#import "LMCenterLineLabel.h"

@implementation LMCenterLineLabel

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // 1.获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2.设置颜色
    [self.textColor setStroke];
    
    // 3.画线
    CGFloat y = rect.size.height * 0.4;
    CGContextMoveToPoint(ctx, 0, y);
    
//    CGFloat endX = [self.text sizeWithFont:self.font].width;
    CGFloat endX = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}].width;
    
    CGContextAddLineToPoint(ctx, endX, y);
    
    // 4.渲染
    CGContextStrokePath(ctx);
}



@end
