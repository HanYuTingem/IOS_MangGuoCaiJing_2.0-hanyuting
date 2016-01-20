//
//  LJHTanChuTiView.h
//  LaoYiLao
//
//  Created by liujinhe on 15/12/17.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaoJiaoSuccectController.h"
#import "LJHTanChuNeiView.h"
@interface LJHTanChuTiView : UIView
@property (nonatomic,strong)LJHTanChuNeiView *teeVV;
+ (LJHTanChuTiView*)sharedManager;
- (void)turnDefoutViewWithTyp:(NSInteger)typ;
@end
