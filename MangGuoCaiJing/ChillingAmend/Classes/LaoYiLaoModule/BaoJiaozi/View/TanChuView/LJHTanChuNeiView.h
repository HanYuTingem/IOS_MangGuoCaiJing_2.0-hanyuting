//
//  LJHTanChuNeiView.h
//  LaoYiLao
//
//  Created by liujinhe on 15/12/17.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LJHTanChuNeiViewDelegate <NSObject>
- (void)buFaSong;
- (void)faSongEwss;
@end

@interface LJHTanChuNeiView : UIView
@property (nonatomic,strong)UIImageView *biaoTiImageView;//标题图片
@property (nonatomic,strong)UILabel *biaoTiMiddleLabel;//标题提示
@property (nonatomic,strong)UIButton *buFatButton;//不发button
@property (nonatomic,strong)UIButton *faJiaoZiButton;//发送button
@property (nonatomic,weak)id <LJHTanChuNeiViewDelegate>delegate;//
- (instancetype)initWithFrame:(CGRect)frame;
@end
