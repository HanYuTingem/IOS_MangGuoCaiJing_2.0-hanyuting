//
//  LYMyDumplingsReceiveView.m
//  LaoYiLao
//
//  Created by Li on 15/12/17.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "LYMyDumplingsReceiveView.h"

@implementation LYMyDumplingsReceiveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI {
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 11, kkViewWidth-17-16-14, 12)];
    _infoLabel.font = [UIFont systemFontOfSize:12];
    _infoLabel.textColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1.0];
    _infoLabel.numberOfLines = 0;
    [self addSubview:_infoLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 32, kkViewWidth-17-16-14, 10)];
    _timeLabel.font = [UIFont systemFontOfSize:10];
    _timeLabel.textColor = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1.0];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_timeLabel];
}

@end
