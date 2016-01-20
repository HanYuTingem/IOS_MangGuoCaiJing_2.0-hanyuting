//
//  SSWobaoCell.m
//  LaoYiLao
//
//  Created by sunsu on 15/12/16.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "SSWobaoCell.h"

#define CellWidth  kkViewWidth-2*10
#define TextHighlightedColor [UIColor colorWithRed:0.22f green:0.22f blue:0.22f alpha:1.00f];
#define TextNormalColor

@interface SSWobaoCell()
{
    UILabel  * _blessLabel;
    UILabel  * _dateLabel;
    UILabel  * _moneyLabel;
    UILabel  * _getStatusLabel;
    UIView   * _cellView;
}
@end


@implementation SSWobaoCell


-(instancetype)initWithFrame:(CGRect)frame{
    if ( self = [super initWithFrame:frame]) {
//        CGRect  cellFrame = CGRectMake(0, 0, kkViewWidth, 50 *ScaleForHeight);

    }
    return self;
}


- (SSWobaoCell *)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGRect  cellFrame = CGRectMake(0, 0, kkViewWidth, 50 *ScaleForHeight);
        _cellView         = [[UIView alloc]initWithFrame:cellFrame];
        _cellView.backgroundColor  = RGBACOLOR(220, 220, 220, 1);
        _cellView.hidden = YES;



        _blessLabel     = [[UILabel alloc]init];
        _dateLabel      = [[UILabel alloc]init];
        _moneyLabel     = [[UILabel alloc]init];
        _getStatusLabel = [[UILabel alloc]init];
        [self addSubview:_cellView];
        [self addSubview:_blessLabel];
        [self addSubview:_dateLabel];
        [self addSubview:_moneyLabel];
        [self addSubview:_getStatusLabel];
//        self.contentView.backgroundColor = [UIColor whiteColor];
//        self.contentView.backgroundColor = RGBACOLOR(220, 220, 220, 1);
        [self showUI];
    }
    return self;
}

+ (SSWobaoCell *)cellWithTableView:(UITableView *)tabelView{
    
    static NSString * ident = @"MyGreetingCardCell";
    
    SSWobaoCell * cell = [tabelView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell = [[SSWobaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    return cell;
}

-(void)showUI{

    
    //frame
    CGFloat start_Y = 10*ScaleForHeight;
    CGFloat space = 20/2;
    CGFloat bless_W = 220;
    _blessLabel.frame   = CGRectMake(10, start_Y, bless_W, 14 *ScaleForHeight);
    _dateLabel.frame    = CGRectMake(10, CGRectGetMaxY(_blessLabel.frame)+11, 100, 10*ScaleForHeight);


    CGFloat money_w = 80;
    CGFloat money_h = 14;
    CGFloat money_x = CellWidth-money_w-space;
    CGFloat money_y = start_Y;
    _moneyLabel.frame   = CGRectMake(money_x,money_y, money_w,money_h);
    
    CGFloat status_w = 100;
    CGFloat status_h = 10*ScaleForHeight;
    CGFloat status_x = CellWidth-status_w-space;
    CGFloat status_y = CGRectGetMaxY(_moneyLabel.frame)+11*ScaleForHeight;
    _getStatusLabel.frame = CGRectMake(status_x, status_y, status_w, status_h);
    
    
    _blessLabel.font        = [UIFont systemFontOfSize:14];
    _moneyLabel.font        = [UIFont systemFontOfSize:14];
    _dateLabel.font         = [UIFont systemFontOfSize:10];
    _getStatusLabel.font    = [UIFont systemFontOfSize:10];
    
    _moneyLabel.textAlignment       = NSTextAlignmentRight;
    _getStatusLabel.textAlignment   = NSTextAlignmentRight;
}




-(void)setCashResultModel:(WobaoCashResultModel*)cashResultModel{
    _cashResultModel = cashResultModel;
    
    NSString * blessStr = _cashResultModel.blessing;
    if ([blessStr isEqual:[NSNull null]]||blessStr==nil||[blessStr isEqualToString:@""]) {
        _blessLabel.text = @"新年快乐，恭喜发财";
    } else {
        _blessLabel.text = _cashResultModel.blessing;
    }
    
    long long createTime =  _cashResultModel.createDate/1000;
    
    NSString * timeStr = [self getTimeStrStyle1:createTime];
    
    _dateLabel.text = timeStr;
    _moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[_cashResultModel.moneyNum floatValue]];
    
    int receiveNum = _cashResultModel.receiveNum;
    int totalDumpNum = _cashResultModel.dumplinglNum;
    int   statusStr = _cashResultModel.status;
    if (statusStr == 1) {//未发送
        _blessLabel.textColor       = [UIColor colorWithRed:0.22f green:0.22f blue:0.22f alpha:1.00f];
        _moneyLabel.textColor       = [UIColor colorWithRed:0.22f green:0.22f blue:0.22f alpha:1.00f];
        _dateLabel.textColor        = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];
        _getStatusLabel.textColor   = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];
        _getStatusLabel.text  = [NSString stringWithFormat:@"未发送%d/%d个",receiveNum,totalDumpNum];//@"未领完14/15个";
        _cellView.hidden = YES;
    }else if (statusStr == 3) {//未领完
        _blessLabel.textColor       = [UIColor colorWithRed:0.22f green:0.22f blue:0.22f alpha:1.00f];
        _moneyLabel.textColor       = [UIColor colorWithRed:0.22f green:0.22f blue:0.22f alpha:1.00f];
        _dateLabel.textColor        = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];
        _getStatusLabel.textColor   = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];
        _getStatusLabel.text  = [NSString stringWithFormat:@"未领完%d/%d个",receiveNum,totalDumpNum];//@"未领完14/15个";
//        self.contentView.backgroundColor = [UIColor whiteColor];
        _cellView.hidden = YES;
    }else if (statusStr == 4){//已领完
        _blessLabel.textColor       = [UIColor colorWithRed:0.55f green:0.55f blue:0.55f alpha:1.00f];
        _moneyLabel.textColor       = [UIColor colorWithRed:0.55f green:0.55f blue:0.55f alpha:1.00f];
        _dateLabel.textColor        = [UIColor colorWithRed:0.73f green:0.73f blue:0.73f alpha:1.00f];
        _getStatusLabel.textColor   = [UIColor colorWithRed:0.73f green:0.73f blue:0.73f alpha:1.00f];
        _getStatusLabel.text  = [NSString stringWithFormat:@"已领完%d/%d个",receiveNum,totalDumpNum];
        _cellView.hidden = NO;
    }else if (statusStr == 5){//已过期
        _blessLabel.textColor       = [UIColor colorWithRed:0.55f green:0.55f blue:0.55f alpha:1.00f];
        _moneyLabel.textColor       = [UIColor colorWithRed:0.55f green:0.55f blue:0.55f alpha:1.00f];
        _dateLabel.textColor        = [UIColor colorWithRed:0.73f green:0.73f blue:0.73f alpha:1.00f];
        _getStatusLabel.textColor   = [UIColor colorWithRed:0.73f green:0.73f blue:0.73f alpha:1.00f];
        _getStatusLabel.text  = [NSString stringWithFormat:@"已过期%d/%d个",receiveNum,totalDumpNum];
        _cellView.hidden = NO;
    }else{
        
    }
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
    NSString *newTime = [timeStr substringWithRange:NSMakeRange(0, 10)];
    return newTime;
}


-(NSString*) getTimeStrStyle1:(long long)time
{
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:(time)];
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay|NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitSecond|NSCalendarUnitWeekday;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    
    long year=[component year];
    long month=[component month];
    long day=[component day];
    
    long hour=[component hour];
    long minute=[component minute];
    
    NSDate * today=[NSDate date];
    component=[calendar components:unitFlags fromDate:today];
    
//    long t_year=[component year];//今年
    
    NSString *string=nil;
    
    long long now = [today timeIntervalSince1970];

    long long distance = now-time;
    
    if(distance<60)
        string=@"刚刚";
    else if(distance<60*60)
        string=[NSString stringWithFormat:@"%lld分钟前",distance/60];
    else if(distance<60*60*24)
        string=[NSString stringWithFormat:@"%lld小时前",distance/60/60];
    else if(distance<60*60*24*2)
        string=[NSString stringWithFormat:@"昨天 %ld:%02ld",hour,minute];//distance/60/60/24
    else if(distance<60*60*24*3)
        string=[NSString stringWithFormat:@"%02ld月%02ld日",month,day];
//    else if(year ==t_year)
//        string=[NSString stringWithFormat:@"%ld年%ld月%ld日",t_year,month,day];
    else
        string=[NSString stringWithFormat:@"%ld年%ld月%ld日",year,month,day];
    return string;
    
}



-(void)layoutSubviews{
    [super layoutSubviews];
    

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
