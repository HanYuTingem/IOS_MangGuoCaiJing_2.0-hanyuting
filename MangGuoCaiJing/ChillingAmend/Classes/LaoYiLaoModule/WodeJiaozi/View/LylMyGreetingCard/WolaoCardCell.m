//
//  WolaoCardCell.m
//  LaoYiLao
//
//  Created by sunsu on 15/12/18.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "WolaoCardCell.h"

#define ItemWidth  318/2
#define ItemHeight 240/2


@interface WolaoCardCell()
{
    UILabel       * _timeLabel;
    UIImageView   * _cardView;
    UILabel       * _phoneLabel;
    UILabel       * _lookLabel;
    
}
@end

@implementation WolaoCardCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self showUI];
        self.layer.borderColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f].CGColor;
        self.layer.borderWidth = 0.5;
    }
    return self;
}

-(void)showUI{
    _timeLabel =[[UILabel alloc]init];
    _cardView = [[UIImageView alloc]init];
    _phoneLabel = [[UILabel alloc]init];
    _lookLabel = [[UILabel alloc]init];
    
    [self addSubview:_timeLabel];
    [self addSubview:_cardView];
    [self addSubview:_phoneLabel];
    [self addSubview:_lookLabel];
    
    CGFloat timeY = (16/2) *KPercenY;
    _timeLabel.frame =  CGRectMake(0, timeY, self.frame.size.width-8, 11);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.textColor = [UIColor colorWithRed:0.69f green:0.69f blue:0.69f alpha:1.00f];
    _timeLabel.font = UIFont22;
    
    CGFloat cardW = 110/2;
    CGFloat cardX = (self.frame.size.width-cardW)/2;
    CGFloat cardY = (26/2)*KPercenY;
    CGFloat cardH = 114/2;
    _cardView.frame = CGRectMake(cardX, cardY, cardW, cardH);//113*109
    _cardView.image = [UIImage imageNamed:@"wodeheka_img"];
    
    CGFloat space = (22/2)*KPercenY;
    _phoneLabel.frame = CGRectMake(0, CGRectGetMaxY(_cardView.frame)+space, self.frame.size.width,13);
    _phoneLabel.textColor = [UIColor colorWithRed:0.13f green:0.00f blue:0.00f alpha:1.00f];
    _phoneLabel.font = UIFont26;
    _phoneLabel.textAlignment = NSTextAlignmentCenter;
    
    CGFloat lookY = CGRectGetMaxY(_phoneLabel.frame)+(8/2)*KPercenY;
    _lookLabel.frame  = CGRectMake(0, lookY, self.frame.size.width, 11);
    _lookLabel.textAlignment  = NSTextAlignmentCenter;
    _lookLabel.font = UIFont22;
    _lookLabel.textColor = [UIColor colorWithRed:0.81f green:0.16f blue:0.16f alpha:1.00f];

    _lookLabel.text = @"点击查看";
}

-(void)setLaoCardModel:(WolaoCardResultModel *)laoCardModel{
    _laoCardModel = laoCardModel;
    _timeLabel.text =  [self getTimeOfall:_laoCardModel.createDate/1000];
    _phoneLabel.text = _laoCardModel.phone;
//    [_cardView sd_setImageWithURL:[NSURL URLWithString:_laoCardModel.userImg] placeholderImage:[UIImage imageNamed:@"wodeheka_img"]];
}


-(NSString * )getTimeOfall:(long long)t{
    //时间加载
    NSString*String = [NSString stringWithFormat:@"%lld",t];
    NSTimeInterval time = [String doubleValue];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *timeStr = [formatter stringFromDate:timeDate];
    NSString *newTime = [timeStr substringWithRange:NSMakeRange(11, 5)];
    return newTime;
}


@end
