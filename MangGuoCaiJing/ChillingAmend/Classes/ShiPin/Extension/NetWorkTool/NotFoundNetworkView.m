//
//  NotFoundNetworkView.m
//  fanxiaoqi
//
//  Created by Li on 15/11/12.
//  Copyright © 2015年 sinoglobal. All rights reserved.
//

#import "NotFoundNetworkView.h"

@implementation NotFoundNetworkView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI
{
    self.backgroundColor = FXQColor(221, 221, 221);

    self.layer.cornerRadius = 2;

    UIImageView* tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(29, 12, 13, 13)];
    tipImageView.image = [UIImage imageNamed:@"public_img_nointranet"];
    [self addSubview:tipImageView];

    self.upTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 11, 100, 12)];
    self.upTipLabel.textColor = FXQColor(33, 33, 33);
    self.upTipLabel.font = [UIFont systemFontOfSize:12];
    self.upTipLabel.text = @"未发现有效网络";
    [self addSubview:self.upTipLabel];

    self.downTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 29, 100, 12)];
    self.downTipLabel.textColor = FXQColor(33, 33, 33);
    self.downTipLabel.font = [UIFont systemFontOfSize:12];
    self.downTipLabel.text = @"请检查网络连接";
    [self addSubview:self.downTipLabel];

    self.hidden = YES;
    self.alpha = 0;
}

+ (NotFoundNetworkView*)createNotFoundNetworkView
{
    static NotFoundNetworkView* notFoundNetworkView = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        notFoundNetworkView = [[NotFoundNetworkView alloc] initWithFrame:CGRectMake(screenWidth / 2 - 80, screenHeight / 2 - 26.5, 160, 53)];
    });

    return notFoundNetworkView;
}

- (void)showsOnView:(UIView*)view
{
    [view addSubview:self];
    self.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2);
    self.hidden = NO;
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.alpha = 1;
                     }];
}

- (void)hides
{
    [UIView animateWithDuration:0.2
        animations:^{
            self.alpha = 0;
        }
        completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
}

@end
