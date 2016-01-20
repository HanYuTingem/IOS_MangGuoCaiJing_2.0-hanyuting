//
//  MyGreetingCardCell.m
//  LaoYiLao
//
//  Created by sunsu on 15/12/16.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "MyGreetingCardCell.h"
#define CellWidth  kkViewWidth-2*10
@interface MyGreetingCardCell()
{
    UILabel  * _blessLabel;
    UILabel  * _dateLabel;
    UILabel  * _tipoffLabel;//举报
    UILabel  * _getStatusLabel;
//    UIView   * _cellView;
}
@end


@implementation MyGreetingCardCell
- (MyGreetingCardCell *)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _blessLabel     = [[UILabel alloc]init];
        _dateLabel      = [[UILabel alloc]init];
        _tipoffLabel     = [[UILabel alloc]init];
//        _getStatusLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_blessLabel];
        [self.contentView addSubview:_dateLabel];
        [self.contentView addSubview:_tipoffLabel];
//        [self.contentView addSubview:_getStatusLabel];
        
//        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = RGBACOLOR(220, 220, 220, 1);
        [self showUI];
    }
    return self;
}

+ (MyGreetingCardCell *)cellWithTableView:(UITableView *)tabelView{
    
    static NSString * ident = @"MyGreetingCardCell";
    
    MyGreetingCardCell * cell = [tabelView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell = [[MyGreetingCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    return cell;
}

-(void)showUI{
    
    //frame
    CGFloat start_Y = 10;
    CGFloat space = 20/2;

    CGFloat money_w = 80;
    CGFloat money_h = 20;
    CGFloat money_x = CellWidth-money_w-space;
    CGFloat money_y = (50 - money_h)/2;
    _tipoffLabel.frame   = CGRectMake(money_x,money_y, money_w,money_h);
    
    CGFloat bless_W = (kkViewWidth-40-money_w);
    _blessLabel.frame   = CGRectMake(10, start_Y, bless_W, 16);
    _dateLabel.frame    = CGRectMake(10, CGRectGetMaxY(_blessLabel.frame)+11, 100, 10);
//    _blessLabel.backgroundColor = [UIColor yellowColor];

    
    _blessLabel.font        = [UIFont systemFontOfSize:14];
    _tipoffLabel.font        = [UIFont systemFontOfSize:14];
    _dateLabel.font         = [UIFont systemFontOfSize:10];
//    _getStatusLabel.font    = [UIFont systemFontOfSize:10];
    
    _tipoffLabel.textAlignment       = NSTextAlignmentRight;
//    _getStatusLabel.textAlignment   = NSTextAlignmentRight;
    
}


-(void)setResultModel:(WobaoCardResultModel *)resultModel{
    NSLog(@"resultModel==%@",resultModel);
    
    _resultModel = resultModel;
    
    _blessLabel.text = _resultModel.cardWish;
    
    long long createTime =  _resultModel.createDate/1000;
    NSString * timeStr = [self getTimeStrStyle1:createTime];
    _dateLabel.text = [NSString stringWithFormat:@"%@", timeStr];

    
    int status =   _resultModel.status;
    
    if (status == 1) {//未领取 [_resultModel.status isEqualToString:@"1"]
        _tipoffLabel.hidden = YES;
        _blessLabel.textColor       = [UIColor colorWithRed:0.22f green:0.22f blue:0.22f alpha:1.00f];
        _dateLabel.textColor        = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];        _getStatusLabel.textColor   = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }else if (status == 2){//已领取
        _tipoffLabel.hidden = YES;
        _blessLabel.textColor       = [UIColor colorWithRed:0.22f green:0.22f blue:0.22f alpha:1.00f];
        _dateLabel.textColor        = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];        _getStatusLabel.textColor   = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];
        self.contentView.backgroundColor = [UIColor whiteColor];
    } else if (status == 3){
        _tipoffLabel.text = @"被举报";
        _tipoffLabel.hidden = NO;
        _blessLabel.textColor       = [UIColor colorWithRed:0.55f green:0.55f blue:0.55f alpha:1.00f];
        _tipoffLabel.textColor       = [UIColor colorWithRed:0.55f green:0.55f blue:0.55f alpha:1.00f];
        _dateLabel.textColor        = [UIColor colorWithRed:0.73f green:0.73f blue:0.73f alpha:1.00f];
    }
}

- (NSString*) getTimeStrStyle1:(long long)time
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
//    else if(distance<60*60*24*3)
//        string=[NSString stringWithFormat:@"%02ld月%02ld日",month,day];
    //    else if(year ==t_year)
    //        string=[NSString stringWithFormat:@"%ld年%ld月%ld日",t_year,month,day];
    else
        string=[NSString stringWithFormat:@"%ld年%ld月%ld日",year,month,day];
    return string;
    
}


//@interface MyGreetingCardCell ()
//{
//    UILabel  * _infoLabel;
//    UILabel  * _timeLabel;
//}
//@end
//
//@implementation MyGreetingCardCell
//
//- (MyGreetingCardCell *)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self showUI];
//    }
//    return self;
//}
//
//+ (MyGreetingCardCell *)cellWithTableView:(UITableView *)tabelView{
//    
//    static NSString * ident = @"MyGreetingCardCell";
//    
//    MyGreetingCardCell * cell = [tabelView dequeueReusableCellWithIdentifier:ident];
//    if (!cell) {
//        
//        cell = [[MyGreetingCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
//    }
//    return cell;
//}
//
//-(void)showUI{
//    _infoLabel = [[UILabel alloc]init];
//    _timeLabel = [[UILabel alloc]init];
//    
//    [self addSubview:_infoLabel];
//    [self addSubview:_timeLabel];
//    
//    CGFloat space = 20;
//    CGFloat info_w = self.frame.size.width-2*space;
//    CGFloat info_h = 50;
//    CGFloat info_x = (self.frame.size.width-info_w)/2;
//    CGFloat info_y = 5;
//
//    _infoLabel.frame = CGRectMake(info_x, info_y,info_w, info_h);
//    
//    _timeLabel.textAlignment = NSTextAlignmentRight;
//    _infoLabel.numberOfLines = 0;
//    _timeLabel.frame = CGRectMake(0, CGRectGetMaxY(_infoLabel.frame), self.frame.size.width-2*space, 20);
//    
//    _infoLabel.text = @"186****8689给你包了一个饺子，点击领取";
//    _timeLabel.text = @"17:18";
//}

@end
