//
//  RightPopADView.m
//  fanxiaoqi
//
//  Created by zuoxiong on 15/9/21.
//  Copyright (c) 2015年 sinoglobal. All rights reserved.
//

#import "RightPopADView.h"
//#import "XXNibBridge.h"
#import "ZXADButton.h"

#define AD_BUTTON_HEIGHT 80 //广告按钮高度暂定40
#define AD_BUTTON_WIDTH 100
#define GAP 0 //定义每个元素之间的间隙为0

@interface RightPopADView ()
@property (weak, nonatomic) IBOutlet UIView* grabBackgroundView;
//@property (weak, nonatomic) IBOutlet UIScrollView *adScrollView;

@end
@implementation RightPopADView
+ (id)createRPAV
{
    return [[NSBundle mainBundle] loadNibNamed:@"RightPopADView" owner:self options:nil][0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}

@end
