//
//  HCuttingVC.h
//  HImageCutting
//
//  Created by 李祖浩 on 14-5-15.
//  Copyright (c) 2014年 李祖浩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCuttingObject.h"
#import "HCuttingDelegate.h"

@interface HCuttingVC : UIViewController<UIScrollViewDelegate>
{
    UIScrollView* scrollView;
    CGFloat heightFloat;
    UIView* lowimageView;
    UIImageView* View;
    CGSize size1;
    UIView* nextView;
    UIImageView* zoomImageView;
}
/*
 第一步 绘制界面
 */
-(void)Draw;
-(void)Thread;
@property (nonatomic, retain) UIImage* editImage;//需要编辑的Image
@property (nonatomic, assign) id <HCuttingDelegate> delegate;
+ (id) Instance;
/*
 第二步 计算出当前剪切 在原图上的矩形坐标
 */

/*
 第三步 判断是否需要等比缩放 入需要 缩放
 */
@end
