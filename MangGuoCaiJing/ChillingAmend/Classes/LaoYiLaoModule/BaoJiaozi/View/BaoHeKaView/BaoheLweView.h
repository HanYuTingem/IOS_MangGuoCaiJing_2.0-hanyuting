//
//  BaoheLweView.h
//  LaoYiLao
//
//  Created by liujinhe on 16/1/14.
//  Copyright © 2016年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WobaoCardResultModel.h"
@interface BaoheLweView : UIView
@property (nonatomic,strong)UIImageView *iWmageView;//贺卡大图
@property (nonatomic,strong)UILabel *preFrecrLabel;//祝福语
@property (nonatomic,strong)UIButton *sendColede;//发送
@property (nonatomic,copy)void(^buttonClicBook)(UIButton*button);//

@property (nonatomic, strong) WobaoCardResultModel * model;


- (instancetype)initWithFrame:(CGRect)frame;
@end
