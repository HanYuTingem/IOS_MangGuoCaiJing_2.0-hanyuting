//
//  ChangePictureButton.m
//  fanxiaoqi
//
//  Created by ZCS on 15/10/12.
//  Copyright (c) 2015年 sinoglobal. All rights reserved.
//

#import "ChangePictureButton.h"

@implementation ChangePictureButton

//设置上图下字
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat w = contentRect.size.width *0.3;
    CGFloat h = contentRect.size.height ;
    CGFloat x = contentRect.size.width - w;
    return CGRectMake(x, 0, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat w = contentRect.size.width *0.7;
    CGFloat h = contentRect.size.height;
    
    return CGRectMake(0, 0, w, h);
}
@end
