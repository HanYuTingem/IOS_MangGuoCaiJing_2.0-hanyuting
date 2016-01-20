//
//  NoDataView.m
//  fanxiaoqi
//
//  Created by Li on 15/11/13.
//  Copyright © 2015年 sinoglobal. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView

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
    
    UIImageView *potImageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth - 90)*0.5, 124*SviewHeight, 90, 107)];
    potImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-15);
    potImageView.image = [UIImage imageNamed:@"public_content_img_blank"];
    [self addSubview:potImageView];
    
    UILabel *contenLabel = [[UILabel alloc]init];
    
    contenLabel.text = @"这里空空如也!";
    
    contenLabel.textColor = FXQColor(33, 33, 33);
    
    contenLabel.font = [UIFont systemFontOfSize:15];
    
    contenLabel.textAlignment = NSTextAlignmentCenter;
    
    CGFloat labelW = 7*15;
    
    CGFloat labelH = 15;
    
    CGFloat labelY = CGRectGetMaxY(potImageView.frame)+30;
    
    CGFloat labelX = (screenWidth-labelW)*0.5;
    
    contenLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
    contenLabel.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 + 60);
    
    [self addSubview:contenLabel];
}

@end
