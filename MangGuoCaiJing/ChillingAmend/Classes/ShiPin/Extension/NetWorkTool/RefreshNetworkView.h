//
//  RefreshNetworkView.h
//  fanxiaoqi
//
//  Created by Li on 15/11/12.
//  Copyright © 2015年 sinoglobal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RefreshNetWorkDelegate <NSObject>

- (void)refreshNetWork;

@end

@interface RefreshNetworkView : UIView

@property (nonatomic, assign) id <RefreshNetWorkDelegate> delegate;

/**
 创建出来是屏幕的大小，想自定义大小的话用initWithFrame
 */
+ (RefreshNetworkView *)createRefreshNetworkView;

@end
