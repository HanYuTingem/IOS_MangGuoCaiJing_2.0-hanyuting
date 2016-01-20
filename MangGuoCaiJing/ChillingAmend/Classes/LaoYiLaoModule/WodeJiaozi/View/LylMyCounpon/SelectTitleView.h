//
//  SelectTitleView.h
//  LaoYiLao
//
//  Created by sunsu on 15/12/17.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTitleView : UIView
@property (nonatomic, assign) int defaultIndex;
@property (nonatomic, strong) NSArray *itemsArray;
@property (nonatomic, copy) void(^selectIndexWithBlock)(int selectIndex);
- (void)createItem:(NSArray *)itemsArray;

- (void)rollingBackViewWithIndex:(int)selectIndex;
@end
