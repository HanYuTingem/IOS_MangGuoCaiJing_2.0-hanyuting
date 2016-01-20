//
//  ZhiFuErView.m
//  LaoYiLao
//
//  Created by liujinhe on 15/12/10.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "ZhiFuErView.h"
#define llHight  50 //价钱高度
#define DiBuLabHight  15 //底部高度
#define PINGBuLabHight  15
#define TUPIANViewHight  14 //图片高度
#define TUPIANViewWITH  11 //图片宽度
#define ZHIFUWiTH   54//支付宽度
#define ZHIFUHIGHT 40 //支付高度
#define JianGeDIBU self.bounds.size.height-5-DiBuLabHight//底部间隔
#define JInadegeRE  12
#define ZHifuWY self.bounds.size.height/2-ZHIFUHIGHT/2
#define JIAGEHIGHT self.bounds.size.height/4-llHight/2-ZHIFUHIGHT/4
@implementation ZhiFuErView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self makeUIandWith:frame];
    }
    return self;
}
- (void)makeUIandWith:(CGRect)frame{
    //价格
    _pricelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, JIAGEHIGHT, frame.size.width, llHight)];
    _pricelabel.text = @"￥0.00";
   // _pricelabel.backgroundColor = [UIColor redColor];
    _pricelabel.textAlignment = NSTextAlignmentCenter;
    _pricelabel.textColor = [UIColor whiteColor];
    _pricelabel.font = UIFontBild80;
    [self addSubview:_pricelabel];
//点击支付
    _zhiFuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect zhiFURect = CGRectMake(ZHIFUWiTH,ZHifuWY,kkViewWidth - 2*ZHIFUWiTH, ZHIFUHIGHT);
    _zhiFuButton.frame = zhiFURect;
    _zhiFuButton.backgroundColor = [UIColor colorWithRed:0.9922 green:0.7176 blue:0.1451 alpha:1.0];
    [_zhiFuButton setTitle:@"去支付" forState:UIControlStateNormal];
    _zhiFuButton.layer.cornerRadius = 5.0f;
    [_zhiFuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_zhiFuButton addTarget:self action:@selector(clientWithPayFor:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_zhiFuButton];
   //平台label
    CGRect pinFRect = CGRectMake(0,CGRectGetMaxY(zhiFURect)+JInadegeRE , kkViewWidth , PINGBuLabHight);
    _pinTailabel = [[UILabel alloc]initWithFrame:pinFRect];
    _pinTailabel.text = @"平台安全支付";
    _pinTailabel.font = UIFont28;
    _pinTailabel.textAlignment = NSTextAlignmentCenter;
    _pinTailabel.textColor = [UIColor yellowColor];
    [self addSubview:_pinTailabel];
    //平台图片
    
    _pinTaiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kkViewWidth/2-55, 0, TUPIANViewWITH, TUPIANViewHight)];
    _pinTaiImageView.image = [UIImage imageNamed:@"ljh_yu_iconfont-anquan.png"];
    [_pinTailabel addSubview:_pinTaiImageView];
    //底部label
    _diBuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, JianGeDIBU , frame.size.width, DiBuLabHight)];
    _diBuLabel.adjustsFontSizeToFitWidth = YES;
    _diBuLabel.text = @"未领取的饺子,24小时后退回到我的钱包余额中";
    _diBuLabel.font = UIFont26;
    _diBuLabel.textColor = [UIColor whiteColor];
    _diBuLabel.textAlignment = NSTextAlignmentCenter;
   // _diBuLabel.backgroundColor = [UIColor orangeColor];
    [self addSubview:_diBuLabel];
}
- (void)clientWithPayFor:(UIButton*)button{
    ZHLog(@"去支付");
    _goPayForBtnBlock(button);
}

@end
