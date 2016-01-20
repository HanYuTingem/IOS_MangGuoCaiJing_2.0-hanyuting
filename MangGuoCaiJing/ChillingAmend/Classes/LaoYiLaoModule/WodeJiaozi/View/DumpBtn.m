//
//  DumpBtn.m
//  LaoYiLao
//
//  Created by sunsu on 15/12/10.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "DumpBtn.h"

@interface DumpBtn ()
{
    UIImageView *_imgView;
    UILabel     *_countLabel;
    UILabel     *_titleLabel;
    
}
@end

@implementation DumpBtn

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _countLabel     = [[UILabel alloc]init];
        _imgView        = [[UIImageView alloc]init];
        _titleLabel     = [[UILabel alloc]init];
        
        [self addSubview:_countLabel];
        [self addSubview:_imgView];
        [self addSubview:_titleLabel];
        
//        self.backgroundColor = [UIColor yellowColor];
//        _countLabel.backgroundColor = [UIColor cyanColor];
//        _titleLabel.backgroundColor = [UIColor blueColor];
    }
    return self;
}



- (void)dumpBtnWithCount:(NSString*)count Img:(NSString *)img title:(NSString * )title{
    CGFloat Space_label_img  = 10/2*KPercenY;;
    CGFloat img_W = 50/2 *KPercenX;
    CGFloat img_H = 50/2 *KPercenY;
    CGFloat img_X = (self.frame.size.width - img_W)/2;
    _imgView.frame = CGRectMake(img_X,0, img_W, img_H);
    _imgView.image = [UIImage imageNamed:img];
//    _imgView.layer.cornerRadius = img_W/2;
    _imgView.layer.masksToBounds = YES;
    
    _countLabel.text = count;
    _countLabel.textColor = RGBACOLOR(189, 0, 0, 1);//[UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:1.00f];
    _countLabel.font = UIFont32;
    _countLabel.textAlignment = NSTextAlignmentCenter;
    
    CGFloat countH = 30 *KPercenY;
    _countLabel.frame = CGRectMake(0, CGRectGetMaxY(_imgView.frame)+Space_label_img, self.frame.size.width,countH);
    
    _titleLabel.text = title;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor colorWithRed:0.65f green:0.65f blue:0.65f alpha:1.00f];//RGBACOLOR(85, 85, 85, 1);
    
    CGFloat title_space =   10/2*KPercenY;
    CGFloat titleH = 15 *KPercenY;
    CGFloat titleY = self.frame.size.height - titleH-title_space;
//
    _titleLabel.frame = CGRectMake(0, titleY, self.frame.size.width, 15);//CGRectGetMaxY(_countLabel.frame)+title_space
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = UIFont22;
    NSString * str = _countLabel.text;
//    ZHLog(@"_countLabel=%@",_countLabel.text);
    NSString * str2 = @"";
    //[str containsString:@"元"]
    if ([str rangeOfString:@"元"].location != NSNotFound) {
        str2 = @"元";
    }else if ([str rangeOfString:@"张"].location != NSNotFound){
        str2 = @"张";
    }
    
    UIColor * color1 = [UIColor colorWithRed:0.81f green:0.16f blue:0.16f alpha:1.00f];
    [self settingLabelAttributedWithLabel:_countLabel String:_countLabel.text modelStr:count str2:str2  font1:UIFont28 font2:UIFont18  color1:color1 color2:RGBACOLOR(202, 73, 78, 1)];//[UIColor grayColor]
    
    
//    [_countLabel sizeToFit];
//    [_titleLabel sizeToFit];
    
//    _countLabel.backgroundColor = [UIColor yellowColor];
//    _titleLabel.backgroundColor = [UIColor lightGrayColor];
}
/*
 
 

 
 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)settingLabelAttributedWithLabel:(UILabel *)label String:(NSString *)textStr modelStr:(NSString *)modelStr str2:(NSString *)str2 font1:(UIFont *)font1 font2:(UIFont *)font2 color1:(UIColor *)color1 color2:(UIColor *)color2 {
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:textStr];
    NSRange range = [textStr rangeOfString:modelStr];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.paragraphSpacing = 0;
    
    style.alignment = NSTextAlignmentCenter;
    NSDictionary * adic = @{NSFontAttributeName :font1,NSForegroundColorAttributeName:color1,NSParagraphStyleAttributeName:style};
    [AttributedStr addAttributes:adic range:range];
    
    NSRange range2 = [textStr rangeOfString:str2];
    NSDictionary * bdic = @{NSFontAttributeName :font2,NSForegroundColorAttributeName:color2,NSParagraphStyleAttributeName:style};
    [AttributedStr addAttributes:bdic range:range2];
    
    //    NSRange range3 = [textStr rangeOfString:str3];
    //    NSDictionary * cdic = @{NSFontAttributeName :font3,NSForegroundColorAttributeName:color3,NSParagraphStyleAttributeName:style};
    //    [AttributedStr addAttributes:cdic range:range3];
    [label setAttributedText: AttributedStr];
}

@end
