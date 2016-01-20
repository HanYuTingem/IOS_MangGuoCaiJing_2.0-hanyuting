//
//  ZhiFuErView.h
//  LaoYiLao
//
//  Created by liujinhe on 15/12/10.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  去支付View
 */
@interface ZhiFuErView : UIView
@property (nonatomic,strong)UILabel* pricelabel;//价钱
@property (nonatomic,strong)UILabel* pinTailabel;//平台
@property (nonatomic,strong)UIButton* zhiFuButton;//支付
@property (nonatomic,strong)UIImageView *pinTaiImageView;//平台图片
@property (nonatomic,strong)UILabel *diBuLabel ;//底部
@property (nonatomic,copy) void(^goPayForBtnBlock)(UIButton*button);
- (instancetype)initWithFrame:(CGRect)frame;
@end
