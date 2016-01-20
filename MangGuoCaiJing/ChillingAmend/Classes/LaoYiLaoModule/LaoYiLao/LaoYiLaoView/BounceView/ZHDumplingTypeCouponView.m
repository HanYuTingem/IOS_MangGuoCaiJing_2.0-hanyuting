//
//  ZHDumplingTypeCouponView.m
//  LaoYiLao
//
//  Created by wzh on 15/12/17.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "ZHDumplingTypeCouponView.h"

#define ZHDumplingTypeCouponView21W 460 / 2 * KPercenX
#define ZHDumplingTypeCouponView21H 150 / 2 * KPercenY

#define ZHDumplingTypeCouponView43W 460 / 2 * KPercenX
#define ZHDumplingTypeCouponView43H 360 / 2 * KPercenY

@implementation ZHDumplingTypeCouponView{
    UIImageView *_imageView;
    UIView *_couponView;
    UILabel *_contentLab;
//    UILabel *_nameLab;
//    UILabel *_startAndEndTimeLab;
    UILabel *_moneyLeb;
    UILabel *_desLab;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = [UIColor greenColor];
        self.frame = CGRectMake(0, 0, ZHDumplingTypeCouponView21W, ZHDumplingTypeCouponView21H);
        _imageView = [[UIImageView alloc]init];
        _imageView.hidden = YES;
        _imageView.frame = self.bounds;
        [self addSubview:_imageView];
        [self couponView];
        
    }
    return self;
}

- (void)couponView{
    
    CGFloat mid = 5 * KPercenX;
    CGFloat desH = 30 * KPercenY;
    CGFloat topY = 10 * KPercenY;
    
    _couponView = [[UIView alloc]initWithFrame:self.bounds];
    _couponView.backgroundColor = [UIColor colorWithPatternImage:[LYLTools scaleImage:[UIImage imageNamed:@"youhuiquan_img"] ToSize:_couponView.size]];
    _couponView.hidden = YES;
    [self addSubview:_couponView];
    
    _contentLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160 * KPercenX, self.frame.size.height)];
//    _contentLab.backgroundColor = [UIColor brownColor];
    _contentLab.textAlignment = NSTextAlignmentCenter;
    _contentLab.font = UIFont24;
    _contentLab.textColor = [UIColor whiteColor];
    _contentLab.numberOfLines = 0;
    _contentLab.center = CGPointMake(_contentLab.center.x, self.frame.size.height / 2);
    [_couponView addSubview:_contentLab];
    
 
    _moneyLeb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_contentLab.frame) + mid, topY, self.frame.size.width - 160 * KPercenX - mid, self.frame.size.height - desH - topY)];
    _moneyLeb.textAlignment = NSTextAlignmentCenter;
    _moneyLeb.font = UIFont24;

//    _moneyLeb.backgroundColor = [UIColor blueColor];
    [_couponView addSubview:_moneyLeb];
    
    _desLab = [[UILabel alloc]initWithFrame:CGRectMake(_moneyLeb.frame.origin.x, CGRectGetMaxY(_moneyLeb.frame), _moneyLeb.frame.size.width, desH )];
    _desLab.textAlignment = NSTextAlignmentCenter;
    _desLab.font = UIFont22;
//    _desLab.backgroundColor = [UIColor grayColor];
    [_couponView addSubview:_desLab];
    
    
//    _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
//    _nameLab.backgroundColor = [UIColor brownColor];
//    [_couponView addSubview:_nameLab];
//    
//    _startAndEndTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_nameLab.frame), 200, 15)];
//    _startAndEndTimeLab.backgroundColor = [UIColor grayColor];
//    [_couponView addSubview:_startAndEndTimeLab];
    
    
    
}
- (void)setModel:(DumplingInforModel *)model{
    _model = model;
    _imageView.hidden = YES;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"youhuiquan_zhengfangxing_default"]];
//    model.resultListModel.dumplingModel.cardType = @"2";
    if([model.resultListModel.dumplingModel.cardType isEqualToString:@"1"]){// 460*150px
        //小图优惠劵
        [_imageView sd_setImageWithURL:[NSURL URLWithString:model.resultListModel.dumplingModel.cardUrl] placeholderImage:[UIImage imageNamed:@"youhuiquan_default"]];
        _imageView.frame = CGRectMake(0, 0, ZHDumplingTypeCouponView21W, ZHDumplingTypeCouponView21H);
        self.height = _imageView.frame.size.height;
        _imageView.hidden = NO;
        
    }else if([model.resultListModel.dumplingModel.cardType isEqualToString:@"2"]){//460*360px
        //大图优惠劵
        [_imageView sd_setImageWithURL:[NSURL URLWithString:model.resultListModel.dumplingModel.cardUrl] placeholderImage:[UIImage imageNamed:@"youhuiquan_zhengfangxing_default"]];
        _imageView.frame = CGRectMake(0, 0, ZHDumplingTypeCouponView43W, ZHDumplingTypeCouponView43H);
        self.height = _imageView.frame.size.height;
        _imageView.hidden = NO;
    }else{//没有cardtype//容错处理
        //小图优惠劵
        [_imageView sd_setImageWithURL:[NSURL URLWithString:model.resultListModel.dumplingModel.cardUrl] placeholderImage:[UIImage imageNamed:@"youhuiquan_default"]];
        _imageView.frame = CGRectMake(0, 0, ZHDumplingTypeCouponView21W, ZHDumplingTypeCouponView21H);
        self.height = _imageView.frame.size.height;
        _imageView.hidden = NO;
    }
    

    /*
    //文字组合优惠劵
    NSString *nameStr = @"京西双十一母婴专场红包";
    NSString *startAndEndtimeStr = @"2015-11-04至2015-11-05";
    NSString *contentStr = [NSString stringWithFormat:@"%@\n%@",nameStr,startAndEndtimeStr];
    NSMutableAttributedString *contentAttributeStr = [[NSMutableAttributedString alloc]initWithString:contentStr];
    NSRange range = [contentStr rangeOfString:nameStr];
    [contentAttributeStr addAttribute:NSFontAttributeName value:UIFont28 range:range];
    _contentLab.attributedText = contentAttributeStr;
    
    NSString *moneyStr = @"900";
    NSString *moneyContentStr = [NSString stringWithFormat:@"%@元",moneyStr];
    NSMutableAttributedString *moneyAttributeStr = [[NSMutableAttributedString alloc]initWithString:moneyContentStr];
    NSRange moneyRange = [moneyContentStr rangeOfString:moneyStr];
    
    int bigFontW = (int)[LYLTools boundingRectWithStrW:moneyStr labStrH:_moneyLeb.frame.size.height andFont:UIFontBild60];
    int smallFontW = (int)[LYLTools boundingRectWithStrW:moneyContentStr labStrH:_moneyLeb.frame.size.height andFont:UIFont24];
    
    NSLog(@"bigFontW + smallFontWd%d,_moneyLeb.frame.size.width%f",bigFontW + smallFontW,_moneyLeb.frame.size.width);
    if(bigFontW + smallFontW > _moneyLeb.frame.size.width){
        [moneyAttributeStr addAttribute:NSFontAttributeName value:UIFontBild58 range:moneyRange];
    }else{
        [moneyAttributeStr addAttribute:NSFontAttributeName value:UIFontBild64 range:moneyRange];
    }
    _moneyLeb.attributedText = moneyAttributeStr;
    
    _desLab.text = @"满70元可用";
    _couponView.hidden = NO;
    self.height = _couponView.frame.size.height;
*/
}

@end
