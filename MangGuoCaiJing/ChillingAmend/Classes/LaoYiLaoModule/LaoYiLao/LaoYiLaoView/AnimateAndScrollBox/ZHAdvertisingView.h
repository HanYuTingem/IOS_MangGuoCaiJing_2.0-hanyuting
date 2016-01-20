//
//  ZHAdvertisingView.h
//  LaoYiLao
//
//  Created by wzh on 16/1/7.
//  Copyright © 2016年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHTitleView.h"
#import "ZHAdvertisingItemView.h"

@interface ZHAdvertisingView : UIView
@property (nonatomic, strong) ZHTitleView *titleView;
@property (nonatomic, strong) ZHAdvertisingItemView *advertisingItemView;
//- (void)createItems:(NSArray *)items;

@end
