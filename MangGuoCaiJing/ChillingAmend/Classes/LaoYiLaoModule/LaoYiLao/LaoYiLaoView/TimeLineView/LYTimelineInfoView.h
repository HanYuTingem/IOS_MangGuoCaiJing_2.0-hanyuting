//
//  LYTimelineInfoView.h
//  做时间轴1233
//
//  Created by Li on 16/1/7.
//  Copyright © 2016年 Li. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, InfoViewType) {
    InfoViewTypeStart,
    InfoViewTypeEnd,
    InfoViewTypeNormal,
    InfoViewTypeHighlighted,
};

@interface LYTimelineInfoView : UIView

@property (nonatomic, assign) InfoViewType type;
@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) NSDictionary *typeDic;

@end
