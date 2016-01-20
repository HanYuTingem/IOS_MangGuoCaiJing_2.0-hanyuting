//
//  LYTimelineInfoView.m
//  做时间轴1233
//
//  Created by Li on 16/1/7.
//  Copyright © 2016年 Li. All rights reserved.
//

#import "LYTimelineInfoView.h"

@interface LYTimelineInfoView ()

@property (nonatomic, strong) UIImageView *stateImageView;
@property (nonatomic, strong) UIView *dotView;

@end

@implementation LYTimelineInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI {
    _startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 10 * [UIScreen mainScreen].bounds.size.width / 320)];
    _startTimeLabel.textColor = [UIColor colorWithRed:220/255.0 green:171/255.0 blue:170/255.0 alpha:1.0];
    _startTimeLabel.font = [UIFont systemFontOfSize:10];
    _startTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_startTimeLabel];
    
    _stateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10.5 * [UIScreen mainScreen].bounds.size.width / 320, 11.5 * [UIScreen mainScreen].bounds.size.width / 320)];
    _stateImageView.image = [UIImage imageNamed:@"jiesu"];
    _stateImageView.center = CGPointMake(self.frame.size.width/2, 21.25 * [UIScreen mainScreen].bounds.size.width / 320);
    [self addSubview:_stateImageView];
    
    _productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_stateImageView.frame) + 6 * [UIScreen mainScreen].bounds.size.width / 320, self.frame.size.width, 11 * [UIScreen mainScreen].bounds.size.width / 320)];
    _productNameLabel.textColor = [UIColor colorWithRed:220/255.0 green:171/255.0 blue:170/255.0 alpha:1.0];
    _productNameLabel.font = [UIFont systemFontOfSize:11];
    _productNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_productNameLabel];
}

- (void)setType:(InfoViewType)type {
    _type = type;
    
    switch (type) {
        case InfoViewTypeStart: {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"HH:mm";
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_typeDic[@"time"] longLongValue]];
            NSString *timeStr = [formatter stringFromDate:date];
            _startTimeLabel.text = timeStr;
            _productNameLabel.text = _typeDic[@"info"];
        }
            break;
        case InfoViewTypeEnd: {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"HH:mm";
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_typeDic[@"time"] longLongValue]];
            NSString *timeStr = [formatter stringFromDate:date];
            _startTimeLabel.text = timeStr;
            _productNameLabel.text = _typeDic[@"info"];
        }
            break;
        case InfoViewTypeNormal: {
            _productNameLabel.textColor = [UIColor colorWithRed:220/255.0 green:171/255.0 blue:170/255.0 alpha:1.0];
            _startTimeLabel.textColor = [UIColor colorWithRed:220/255.0 green:171/255.0 blue:170/255.0 alpha:1.0];
            _stateImageView.frame = CGRectMake(_stateImageView.frame.origin.x, _stateImageView.frame.origin.y, 10.5 * [UIScreen mainScreen].bounds.size.width / 320, 11.5 * [UIScreen mainScreen].bounds.size.width / 320);
            _stateImageView.image = [UIImage imageNamed:@"jiesu"];
            _stateImageView.center = CGPointMake(self.frame.size.width/2, 21.25 * [UIScreen mainScreen].bounds.size.width / 320);
        }
            break;
        case InfoViewTypeHighlighted: {
            _productNameLabel.textColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:0/255.0 alpha:1.0];
            _startTimeLabel.textColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:0/255.0 alpha:1.0];
            _stateImageView.frame = CGRectMake(_stateImageView.frame.origin.x, _stateImageView.frame.origin.y, 34.5 * [UIScreen mainScreen].bounds.size.width / 320, 34.5 * [UIScreen mainScreen].bounds.size.width / 320);
            _stateImageView.image = [UIImage imageNamed:@"ing"];
            _stateImageView.center = CGPointMake(self.frame.size.width/2, 21.75 * [UIScreen mainScreen].bounds.size.width / 320);
        }
            break;
    }
}

@end
