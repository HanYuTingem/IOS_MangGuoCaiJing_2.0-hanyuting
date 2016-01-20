//
//  ZXADButton.m
//  fanxiaoqi
//
//  Created by xiong on 15/10/8.
//  Copyright (c) 2015年 sinoglobal. All rights reserved.
//

#import "ZXADButton.h"

@implementation ZXADButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (id)createButton
{
    return [[NSBundle mainBundle] loadNibNamed:@"ZXADButton" owner:self options:nil][0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.maskImageView.backgroundColor = [UIColor blackColor];
    self.maskImageView.alpha = 0.2;
    self.maskImageView.hidden = YES;
    //    self.bgView.userInteractionEnabled = YES;
    //    self.maskImageView.userInteractionEnabled = YES;
    //    self.backgroundImageView.userInteractionEnabled = YES;
    //    self.opaque = ;
}

//designated
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.backgroundImageView.frame = self.bounds;
//        [self addSubview:self.backgroundImageView];
//        CGFloat nlHeight = 30 / 144 * self.bounds.size.height;
//        CGFloat nlWidth = 42 / 180 * self.bounds.size.width;
//        self.numberLabel.textColor = [UIColor whiteColor];
//        self.numberLabel.backgroundColor = FXQColorRGBA(0, 0, 0, 0.5);
//        self.numberLabel.frame = CGRectMake(self.bounds.size.width - nlWidth, self.bounds.size.height - nlHeight, nlWidth, nlHeight);
//        [self addSubview:self.numberLabel];
//        self.maskImageView.backgroundColor = [UIColor blackColor];
//        self.maskImageView.alpha = 0.2;
//        self.maskImageView.hidden = YES;
//        self.maskImageView.frame = self.bounds;
//        [self addSubview:self.maskImageView];
//        self.opaque = NO;
//    }
//    return self;
//}

- (void)setState:(int)index
{
    switch (index) {
    case 0:
        //        self.maskImageView.hidden = NO;
        self.backgroundImageView.borderWidth = 0;
        self.borderWidth = 0;
        break;
    case 1:
        //        self.maskImageView.hidden = YES;
        self.backgroundImageView.borderWidth = 0.5;
        self.backgroundImageView.borderColor = [UIColor blackColor];
        break;
    case 2:
        self.borderWidth = 0.5;
        self.borderColor = FXQColor(202, 48, 130);
        break;
    default:
        break;
    }
}

- (id)copyWithZone:(NSZone*)zone
{
    ZXADButton* copy = [[self class] allocWithZone:zone];
    copy.frame = self.frame;
    copy.maskImageView = self.maskImageView;
    copy.backgroundImageView = self.backgroundImageView;
    copy.numberLabel = self.numberLabel;
    copy.landscape = self.landscape;
    return copy;
}

@end
