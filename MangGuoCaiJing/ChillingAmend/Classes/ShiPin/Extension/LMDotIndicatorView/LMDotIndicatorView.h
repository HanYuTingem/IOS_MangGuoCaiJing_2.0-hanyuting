//
//  LMDotIndicatorView.h
//  fanxiaoqi
//
//  Created by 李敏 on 15/12/07.
//  Copyright (c) 2015年 sinoglobal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LMDotIndicatorViewStyle)
{
    LMDotIndicatorViewStyleSquare,
    LMDotIndicatorViewStyleRound,
    LMDotIndicatorViewStyleCircle
};

@interface LMDotIndicatorView : UIView

- (id)initWithFrame:(CGRect)frame
           dotStyle:(LMDotIndicatorViewStyle)style
           dotColor:(UIColor *)dotColor
            dotSize:(CGSize)dotSize;

+ (LMDotIndicatorView *)createDotShowView:(UIView *)showView;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;


@end
