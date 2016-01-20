//
//  SSBaoJiaoZiBtnView.h
//  LaoYiLao
//
//  Created by sunsu on 15/11/26.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSBaoJiaoZiBtnViewDelegate  <NSObject>

- (void) ClickWoBaodeJiaozi;

@end

@interface SSBaoJiaoZiBtnView : UIView
@property (nonatomic, strong) UIButton * clickedBtn;
@property (nonatomic, weak)id<SSBaoJiaoZiBtnViewDelegate>delegate;
@end
