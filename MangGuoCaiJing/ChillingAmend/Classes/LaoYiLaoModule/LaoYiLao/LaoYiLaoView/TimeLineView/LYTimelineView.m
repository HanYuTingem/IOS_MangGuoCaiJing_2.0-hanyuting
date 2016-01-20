//
//  LYTimelineView.m
//  做时间轴1233
//
//  Created by Li on 16/1/7.
//  Copyright © 2016年 Li. All rights reserved.
//

#import "LYTimelineView.h"
#import "LYTimelineInfoView.h"
#import <QuartzCore/QuartzCore.h>

@interface LYTimelineView ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, assign) long long currentTime;
@property (nonatomic, strong) NSDictionary *startDic;
@property (nonatomic, strong) NSDictionary *endDic;

@end

@implementation LYTimelineView
//手机端判断
/*
//根据数据源初始化
+(instancetype)createTimelineViewWithDataArray:(NSArray *)dataArray currentTime:(NSDate *)time position:(CGPoint)position {
    LYTimelineView *timeLineView = [[LYTimelineView alloc] initWithFrame:CGRectMake(position.x, position.y, [UIScreen mainScreen].bounds.size.width / 3 * (dataArray.count+2), 58 * [UIScreen mainScreen].bounds.size.height / 568)];
    timeLineView.dataArray = dataArray;
    timeLineView.currentTime = (long long)[time timeIntervalSince1970];
    
    return timeLineView;
}
- (void)startTimer {
    _currentTime++;
    
//    NSLog(@"!");
    for (int i=0; i<_dataArray.count; i++) {
        long long dataTime = [_dataArray[i][@"time"] longLongValue];
        long long dataTimeNext = 0;
        if (i < _dataArray.count-1) {
            dataTimeNext = [_dataArray[i+1][@"time"] longLongValue];
            if (_currentTime >= dataTime && _currentTime < dataTimeNext) {
                LYTimelineInfoView *lastInfoView = [self viewWithTag:1000 + i - 1];
                if (lastInfoView.type == InfoViewTypeHighlighted) {
                    lastInfoView.type = InfoViewTypeNormal;
                }
                LYTimelineInfoView *infoView = [self viewWithTag:1000 + i];
                if (infoView.type != InfoViewTypeHighlighted) {
                    [UIView animateWithDuration:0.3 animations:^{
                        self.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width / 3 * i, self.frame.origin.y, [UIScreen mainScreen].bounds.size.width / 3 * (_dataArray.count+2), 58 * [UIScreen mainScreen].bounds.size.height / 568);
                        infoView.type = InfoViewTypeHighlighted;
                    }];
                }
            }
        } else {
            if (_currentTime >= dataTime) {
                LYTimelineInfoView *lastInfoView = [self viewWithTag:1000 + i - 1];
                if (lastInfoView.type == InfoViewTypeHighlighted) {
                    lastInfoView.type = InfoViewTypeNormal;
                }
                LYTimelineInfoView *infoView = [self viewWithTag:1000 + i];
                if (infoView.type != InfoViewTypeHighlighted) {
                    [UIView animateWithDuration:0.3 animations:^{
                        self.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width / 3 * i, self.frame.origin.y, [UIScreen mainScreen].bounds.size.width / 3 * (_dataArray.count+2), 58 * [UIScreen mainScreen].bounds.size.height / 568);
                        infoView.type = InfoViewTypeHighlighted;
                        
                        [_timer invalidate];
                    }];
                }
            }
        }
    }
}

- (void)setDataArray:(NSArray *)dataArray {
    if(self.isThirdData){
        _dataArray = dataArray;
    }else{
        if (dataArray.count >= 2) {
            NSMutableArray *mutArr = [NSMutableArray arrayWithArray:dataArray];
            [mutArr removeLastObject];
            [mutArr removeObjectAtIndex:0];
            _dataArray = [NSArray arrayWithArray:mutArr];
            
            _startDic = [dataArray firstObject];
            _endDic = [dataArray lastObject];
        } else {
            _dataArray = dataArray;
        }
    }
}

- (void)setCurrentTime:(long long)currentTime {
    _currentTime = currentTime;
    if(self.isThirdData){
        [self refreshTimeIsAccurateIsNOUI];
    }else{
        [self refreshUI];
    }
}
- (void)refreshUI {
    if (_timer) {
        [_timer invalidate];
    }
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    if (_dataArray && _dataArray.count) {
        NSInteger hightlightedIndex = 1;
        for (int i=0; i<_dataArray.count+2; i++) {
            LYTimelineInfoView *infoView = [[LYTimelineInfoView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 3 * i, (58 * [UIScreen mainScreen].bounds.size.height / 568 - 44.5 * [UIScreen mainScreen].bounds.size.width / 320) / 2, [UIScreen mainScreen].bounds.size.width / 3, 44.5 * [UIScreen mainScreen].bounds.size.width / 320)];
            if (i == 0) {
                infoView.typeDic = _startDic;
                infoView.type = InfoViewTypeStart;
            } else if (i == _dataArray.count + 1) {
                infoView.typeDic = _endDic;
                infoView.type = InfoViewTypeEnd;
            } else {
                long long dataTime = [_dataArray[i-1][@"time"] longLongValue];
                if (_currentTime < dataTime && i == 1) {
                    infoView.type = InfoViewTypeHighlighted;
                } else {
                    long long dataTimeNext = 0;
                    if (i < _dataArray.count) {
                        dataTimeNext = [_dataArray[i][@"time"] longLongValue];
                    }
                    if ((_currentTime >= dataTime && _currentTime < dataTimeNext) || (_currentTime >= dataTime && i == _dataArray.count)) {
                        infoView.type = InfoViewTypeHighlighted;
                        hightlightedIndex = i;
                        
                        if (i == _dataArray.count) {
                            [_timer invalidate];
                        }
                    } else {
                        infoView.type = InfoViewTypeNormal;
                    }
                }
                
                infoView.tag = 1000 + i - 1;
                
                infoView.productNameLabel.text = _dataArray[i-1][@"info"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"HH:mm";
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:dataTime];
                infoView.startTimeLabel.text = [NSString stringWithFormat:@"%@ %@", _dataArray[i-1][@"pot"], [formatter stringFromDate:date]];
            }
            [self addSubview:infoView];
        }
    
    
        self.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width / 3 * (hightlightedIndex-1), self.frame.origin.y, [UIScreen mainScreen].bounds.size.width / 3 * (_dataArray.count+2), 58 * [UIScreen mainScreen].bounds.size.height / 568);
        
        if (hightlightedIndex < _dataArray.count) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
        }
        
        [self addDottedLine];
    }
}
*/
//添加正中间的虚线
- (void)addDottedLine {
    if ([self.layer.sublayers containsObject:_shapeLayer]) {
        [_shapeLayer removeFromSuperlayer];
    }
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.bounds = self.bounds;
    _shapeLayer.position = CGPointMake(self.frame.size.width/2, (58 * [UIScreen mainScreen].bounds.size.height / 568 - 44.5 * [UIScreen mainScreen].bounds.size.width / 320) / 2 + 21.75 * [UIScreen mainScreen].bounds.size.width / 320);
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    _shapeLayer.lineDashPattern = @[@2, @3];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, (58 * [UIScreen mainScreen].bounds.size.height / 568 - 44.5 * [UIScreen mainScreen].bounds.size.width / 320) / 2 + 21.75 * [UIScreen mainScreen].bounds.size.width / 320);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width, (58 * [UIScreen mainScreen].bounds.size.height / 568 - 44.5 * [UIScreen mainScreen].bounds.size.width / 320) / 2 + 21.75 * [UIScreen mainScreen].bounds.size.width / 320);
    
    _shapeLayer.path = path;
    CGPathRelease(path);
    
    [self.layer insertSublayer:_shapeLayer atIndex:0];
}


//服务器判断
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self refreshTimeIsAccurateIsNOUI];

}
- (void)refreshTimeIsAccurateIsNOUI{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }

    if (_dataArray && _dataArray.count) {
        for (int i=0; i<_dataArray.count; i++) {
            LYTimelineInfoView *infoView = [[LYTimelineInfoView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 3 * i, (58 * [UIScreen mainScreen].bounds.size.height / 568 - 44.5 * [UIScreen mainScreen].bounds.size.width / 320) / 2, [UIScreen mainScreen].bounds.size.width / 3, 44.5 * [UIScreen mainScreen].bounds.size.width / 320)];

            if (i == 1) {
                infoView.type = InfoViewTypeHighlighted;
            } else {
                infoView.type = InfoViewTypeNormal;
            }

            infoView.productNameLabel.text = _dataArray[i][@"info"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"HH:mm";
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_dataArray[i][@"time"] longLongValue]];
            infoView.startTimeLabel.text = [NSString stringWithFormat:@"%@ %@", _dataArray[i][@"pot"], [formatter stringFromDate:date]];
            [self addSubview:infoView];
        }

        [self addDottedLine];
    }
}

//
////#pragma mark - 只有三条数据的方法
//+ (instancetype)createTimelineViewWithDataArray:(NSArray *)dataArray currentTime:(NSDate *)time position:(CGPoint)position {
//    LYTimelineView *timeLineView = [[LYTimelineView alloc] initWithFrame:CGRectMake(position.x, position.y, [UIScreen mainScreen].bounds.size.width, 58 * [UIScreen mainScreen].bounds.size.height / 568)];
//    timeLineView.dataArray = dataArray;
//    timeLineView.currentTime = (long long)[time timeIntervalSince1970];
//
//    return timeLineView;
//}

@end
