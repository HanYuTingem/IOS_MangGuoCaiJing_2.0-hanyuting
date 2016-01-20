//
//  FaJiaoziView.h
//  LaoYiLao
//
//  Created by sunsu on 15/12/15.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  包饺子好了
 */
@protocol FaJiaoziViewDelegate <NSObject>
-(void)faJiaozi;
@end


@interface FaJiaoziView : UIView
@property(nonatomic,weak)id<FaJiaoziViewDelegate>delegate;
@end
