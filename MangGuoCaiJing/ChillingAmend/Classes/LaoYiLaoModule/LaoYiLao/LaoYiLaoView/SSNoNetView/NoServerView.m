//
//  NoServerView.m
//  LaoYiLao
//
//  Created by sunsu on 15/12/22.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "NoServerView.h"
@interface NoServerView()
{
    UIImageView * _imageView;
    UILabel     * _serverLabel;
}
@end

@implementation NoServerView
- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self showUI];
        self.backgroundColor = RGBACOLOR(247, 247, 247, 1);
//        self.backgroundColor = [UIColor colorWithPatternImage:[LYLTools scaleImage:[UIImage imageNamed:@"lao_bg"] ToSize:CGSizeMake(kkViewWidth, NavgationBarHeight)]];
    }
    return self;
}

-(void)showUI{
    //153*105
    CGFloat imgW = 154/2;
    CGFloat imgX = (self.frame.size.width-imgW)/2;
    CGFloat imgY = 182/2 *KPercenY;
    CGFloat imgH = 106/2 *KPercenY;
    
    CGRect ImgFrame = CGRectMake(imgX, imgY, imgW, imgH);
    _imageView = [[UIImageView alloc]initWithFrame:ImgFrame];
    [self addSubview:_imageView];
    
    
    CGRect labelFrame = CGRectMake(0, CGRectGetMaxY(_imageView.frame)+(30/2)*KPercenY, self.frame.size.width, 15*KPercenY);
    _serverLabel = [[UILabel alloc]initWithFrame:labelFrame];
    [self addSubview:_serverLabel];
    
    _imageView.image = [UIImage imageNamed:@"fuwuqi__iconfont-find-fill"];
    _serverLabel.text = @"服务器去月球啦~";
    _serverLabel.font = UIFont30;
    _serverLabel.textColor = [UIColor colorWithRed:0.70f green:0.70f blue:0.70f alpha:1.00f];
    _serverLabel.textAlignment = NSTextAlignmentCenter;
//    ZHDataBase
}




@end
