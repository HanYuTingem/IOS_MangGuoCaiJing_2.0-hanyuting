//
//  RefreshNetworkView.m
//  fanxiaoqi
//
//  Created by Li on 15/11/12.
//  Copyright © 2015年 sinoglobal. All rights reserved.
//

#import "RefreshNetworkView.h"

#define SELFHEIGHT self.frame.size.height/568.0

@implementation RefreshNetworkView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI {
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2-62.5, 91*SELFHEIGHT, 125, 98.5)];
    iconImageView.image = [UIImage imageNamed:@"public_content_img_net"];
    [self addSubview:iconImageView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 91*SELFHEIGHT+128.5, screenWidth, 15)];
    tipLabel.textColor = FXQColor(204, 204, 204);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.text = @"检查网络，点击刷新";
    [self addSubview:tipLabel];
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.frame = CGRectMake(screenWidth/2-30, 91*SELFHEIGHT+173.5, 60, 30);
    [refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
    [refreshButton setTitleColor:FXQColor(202, 48, 130) forState:UIControlStateNormal];
    [refreshButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    refreshButton.titleLabel.font = [UIFont systemFontOfSize:14];
    refreshButton.layer.cornerRadius = 2;
    refreshButton.layer.borderWidth = 1;
    refreshButton.layer.borderColor = FXQColor(202, 48, 130).CGColor;
    [refreshButton addTarget:self action:@selector(refreshButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton addTarget:self action:@selector(refreshButtonChangeColor:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:refreshButton];
}

+ (RefreshNetworkView *)createRefreshNetworkView {
    static RefreshNetworkView *refreshView = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        refreshView = [[RefreshNetworkView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64)];
    });
    
    return refreshView;
}

- (void)refreshButtonClick:(UIButton *)button {
    button.layer.borderColor = FXQColor(202, 48, 130).CGColor;  
    
    if ([self.delegate respondsToSelector:@selector(refreshNetWork)]) {
        [self.delegate refreshNetWork];
    }
}

- (void)refreshButtonChangeColor:(UIButton *)button {
    button.layer.borderColor = FXQColor(175, 41, 112).CGColor;
}

@end
