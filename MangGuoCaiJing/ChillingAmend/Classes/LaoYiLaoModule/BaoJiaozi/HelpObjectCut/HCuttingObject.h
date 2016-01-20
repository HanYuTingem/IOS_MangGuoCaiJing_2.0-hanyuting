//
//  HCuttingObject.h
//  HImageCutting
//
//  Created by 李祖浩 on 14-5-15.
//  Copyright (c) 2014年 李祖浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#define HHSizeMaximumWide 1280     //最大宽
#define HHSizeMaximumHigh 960     //最大高

#define HHSizeLeastWide 640       //最小宽
#define HHSizeLeastHigh 480      //最小高
@interface HCuttingObject : NSObject

/*
 第一步 判断图片尺寸规格 规格长宽必须在自定规格 “初始指定规格为长宽分别必须大于640*480” 如果尺寸不符合规范则会直接跳回从选
 */
+(BOOL)HimageSizeJudge:(UIImage*)image;
/*
 第二步 计算出当前剪切 在原图上的矩形坐标
 */
//切图  imageCutOut需剪切的Image  startingPoint剪切矩形对角起点X/Y的值 Terminal剪切矩形对角终点X/Y的值
+(UIImage*)HimageCutOut:(UIImage*)imageCutOut StartingPointX:(CGFloat)startingPointX StartingPointY:(CGFloat)startingPointY TerminalX:(CGFloat)terminalX TerminalY:(CGFloat)terminalY;

/*
 第三步 判断是否需要等比缩放 入需要 缩放
 */
+(UIImage*)scaleToSize:(CGSize)size image:(UIImage*)image;
@end
