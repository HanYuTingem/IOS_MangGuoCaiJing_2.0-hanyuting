//
//  HCuttingObject.m
//  HImageCutting
//
//  Created by 李祖浩 on 14-5-15.
//  Copyright (c) 2014年 李祖浩. All rights reserved.
//

#import "HCuttingObject.h"

@implementation HCuttingObject
+(BOOL)HimageSizeJudge:(UIImage *)image{
    if (image.size.width < HHSizeLeastWide||image.size.width < HHSizeLeastHigh) {
        return NO;
    }
    return YES;
}
+(UIImage*)HimageCutOut:(UIImage *)imageCutOut StartingPointX:(CGFloat)startingPointX StartingPointY:(CGFloat)startingPointY TerminalX:(CGFloat)terminalX TerminalY:(CGFloat)terminalY{
    
    CGFloat artworkMultiple = imageCutOut.size.width/320;//原图想不屏幕显示放大的倍数
    CGRect rect;
	rect.origin.x = startingPointX*artworkMultiple;
    rect.origin.y = startingPointY*artworkMultiple;
    rect.size.width = terminalX*artworkMultiple;
    rect.size.height = terminalY*artworkMultiple;
    CGImageRef cr = CGImageCreateWithImageInRect([imageCutOut CGImage], rect);
	UIImage *cropped = [UIImage imageWithCGImage:cr];
    CGImageRelease(cr);
    CGSize size1 = CGSizeMake(HHSizeMaximumWide, HHSizeMaximumHigh);
    imageCutOut = nil;
    return [self scaleToSize:size1 image:cropped];
}

+(UIImage*)scaleToSize:(CGSize)size image:(UIImage*)image
{
    if (image.size.width <= HHSizeMaximumHigh) {
        return image;
    }
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    image = nil;
    // 返回新的改变大小后的图片
    return scaledImage;
}
@end
