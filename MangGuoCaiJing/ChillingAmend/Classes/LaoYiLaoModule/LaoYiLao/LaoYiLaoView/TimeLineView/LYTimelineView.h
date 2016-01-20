//
//  LYTimelineView.h
//  做时间轴1233
//
//  Created by Li on 16/1/7.
//  Copyright © 2016年 Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYTimelineView : UIView

/**
 * 数据源数组
 */
@property (nonatomic, strong) NSArray *dataArray;
/**
 * 当前时间
 */
@property (nonatomic, strong) NSDate *currentDate;
/**
 *   是否调用三条数据接口 yes 是  no 不是
 */
@property (nonatomic, assign) BOOL isThirdData;

/**
 * @param   dataArray   数据源数组
 * @param   time        当前时间
 * @param   position    时间轴frame的origin
 */
+ (instancetype)createTimelineViewWithDataArray:(NSArray *)dataArray
                                    currentTime:(NSDate *)time
                                       position:(CGPoint)position;

@end
