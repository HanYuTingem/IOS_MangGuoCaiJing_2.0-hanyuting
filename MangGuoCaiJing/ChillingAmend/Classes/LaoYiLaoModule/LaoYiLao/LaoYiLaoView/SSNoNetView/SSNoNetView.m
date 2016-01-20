//
//  SSNoNetView.m
//  LaoYiLao
//
//  Created by sunsu on 15/11/5.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "SSNoNetView.h"

@interface SSNoNetView ()
{
    
    UIImageView * _imageView;
    UILabel * _numOfJiaozi;
    UILabel * _textLabel;
    UIButton * _refreshBtn;
    UILabel  * _netLabel;
    
}

@end

@implementation SSNoNetView

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        self.backgroundColor = [UIColor colorWithPatternImage:[LYLTools scaleImage:[UIImage imageNamed:@"lao_bg"] ToSize:CGSizeMake(kkViewWidth, NavgationBarHeight)]];
//        self.backgroundColor = RGBACOLOR(242, 242, 242, 1);
//        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


-(void)initUI{
    CGFloat imgView_W = 466/2;
    CGFloat imgView_Y = 130/2;
    CGFloat imgView_H = 48/2;
    CGRect imageViewFrame = CGRectMake((self.frame.size.width-imgView_W)/2, imgView_Y, imgView_W, imgView_H);
    _imageView = [[UIImageView alloc]initWithFrame:imageViewFrame];
    _imageView.image = [UIImage imageNamed:@"writing"];
    [self addSubview:_imageView];
    
    CGRect jiaoziFrame = CGRectMake(0, CGRectGetMaxY(_imageView.frame)+20,  self.frame.size.width, 40);
    _numOfJiaozi = [[UILabel alloc]initWithFrame:jiaoziFrame];
    _numOfJiaozi.textAlignment = NSTextAlignmentCenter;
    NSString * str1 = @"200,000,000";
    NSString * str2 = @"个饺子";
    _numOfJiaozi.text  = [NSString stringWithFormat:@"%@%@",str1,str2];
    _numOfJiaozi.font = [UIFont systemFontOfSize:40.0f];
    [self settingLabelAttributedWithLabel:_numOfJiaozi Str1:str1 Str2:str2 font1:UIFont40  color1:[UIColor yellowColor ]  color2:[UIColor whiteColor]];

//    [self settingLabelAttributedWithLabel:_numOfJiaozi Str1:str1 Str2:str2 font1:UIFont40  color1:[UIColor colorWithRed:1.00f green:0.24f blue:0.00f alpha:1.00f]  color2:RGBACOLOR(134, 0, 0, 1)];
    [self addSubview:_numOfJiaozi];
    
    CGFloat text_H = 40;
    CGRect textLabelFrame = CGRectMake(0, self.frame.size.height-44/2-text_H - PosterHeight, self.frame.size.width, text_H);
    _textLabel = [[UILabel alloc]initWithFrame:textLabelFrame];
//    _textLabel.text = @"小年夜，更多饺子等你来捞~";
    _textLabel.text = @"2016媒体融合过年秀\n更多饺子等你来捞";
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.textColor = [UIColor whiteColor];
//    _textLabel.textColor = RGBACOLOR(134, 0, 0, 1);
    _textLabel.font = [UIFont systemFontOfSize:14.0f];
    _textLabel.numberOfLines = 0;
    [self addSubview:_textLabel];
    
    
    CGFloat netLabel_H = 20;
    CGRect netLabelFrame = CGRectMake(0, self.frame.size.height-510/2-netLabel_H - PosterHeight, self.frame.size.width, netLabel_H);
    _netLabel = [[UILabel alloc]initWithFrame:netLabelFrame];
    //    _textLabel.text = @"小年夜，更多饺子等你来捞~";
    _netLabel.text = @"无网络，请检查网络设置";
    _netLabel.textAlignment = NSTextAlignmentCenter;
    _netLabel.textColor = [UIColor whiteColor];
    //    _textLabel.textColor = RGBACOLOR(134, 0, 0, 1);
    _netLabel.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:_netLabel];
    
    
//    CGFloat refrsh_W = 280/2;
//    CGFloat refrsh_H = 20/2;
//    CGRect refreshBtnFrame = CGRectMake((self.frame.size.width-refrsh_W)/2, self.frame.size.height-refrsh_H-43.0/2 - PosterHeight, refrsh_W,refrsh_H);
//    _refreshBtn = [[UIButton alloc]initWithFrame:refreshBtnFrame];
    [_refreshBtn setTitle:@"网络状况不佳,点击刷新" forState:UIControlStateNormal];
    _refreshBtn.titleLabel.font = UIFont20;
    [_refreshBtn setTitleColor:RGBACOLOR(51, 51, 51, 1) forState:UIControlStateNormal];
    [_refreshBtn setImage:[UIImage imageNamed:@"iconfont-shuaxin"] forState:UIControlStateNormal];
    [_refreshBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 129, 0, 0)];
    [_refreshBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
//    _refreshBtn.backgroundColor = [UIColor blackColor];
    [_refreshBtn addTarget:self action:@selector(refreshView) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_refreshBtn];
}

- (void)settingLabelAttributedWithLabel:(UILabel *)label Str1:(NSString *)str1 Str2:(NSString *)str2  font1:(UIFont *)font1  color1:(UIColor *)color1 color2:(UIColor *)color2 {
    NSString * str = [NSString stringWithFormat:@"%@%@",str1,str2];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range = [str rangeOfString:str1];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.paragraphSpacing = 0;
    style.alignment = NSTextAlignmentCenter;
    
    NSDictionary * adic = @{NSFontAttributeName :font1,NSForegroundColorAttributeName:color1,NSParagraphStyleAttributeName:style};
    [AttributedStr addAttributes:adic range:range];
    
    NSRange range2 = [str rangeOfString:str2];
    NSDictionary * bdic = @{NSFontAttributeName :font1,NSForegroundColorAttributeName:color2,NSParagraphStyleAttributeName:style};
    [AttributedStr addAttributes:bdic range:range2];
    [label setAttributedText: AttributedStr];
}

- (void) refreshView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshNoNetView)]) {
        [self.delegate refreshNoNetView];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
