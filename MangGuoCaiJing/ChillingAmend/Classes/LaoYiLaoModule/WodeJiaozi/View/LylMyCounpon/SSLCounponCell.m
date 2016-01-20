//
//  SSLCounponCell.m
//  LaoYiLao
//
//  Created by sunsu on 15/12/15.
//  Copyright © 2015年 sunsu. All rights reserved.

/*
 _moneyLabel
 _merchantIcon
 _useDescLabel
 _useNowBtn
 _dateLabel
 _statusLabel
*/
//

#import "SSLCounponCell.h"

@interface SSLCounponCell ()
{
    UILabel         * _moneyLabel;
    UIImageView     * _merchantIcon;
    UILabel         * _useDescLabel;
    UIButton        * _useNowBtn;
    UILabel         * _dateLabel;
    UILabel         * _statusLabel;
    UIView          * _upView;
    
}
@end


@implementation SSLCounponCell

#pragma mark -- cell
- (SSLCounponCell *)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self showUI];
    }
    return self;
}

-(void)showUI{
    _upView         = [[UIView alloc]init];
    _moneyLabel     = [[UILabel alloc]init];
    _merchantIcon   = [[UIImageView alloc]init];
    _useDescLabel   = [[UILabel alloc]init];
    _useNowBtn      = [[UIButton alloc]init];
    _dateLabel      = [[UILabel alloc]init];
    _statusLabel    = [[UILabel alloc]init];
    
    [self addSubview:_upView];
    [_upView addSubview: _moneyLabel];
    [_upView addSubview: _merchantIcon];
    [_upView addSubview: _useDescLabel];
    
    [self addSubview: _dateLabel];
    [_dateLabel addSubview: _useNowBtn];
    
    [self addSubview: _statusLabel];
    
    [self addAttributes];
}

-(void)addAttributes{
    //frame
    CGFloat space = 20;
    CGFloat status_W = 20;//即将过期，新到手，已过期的label宽
    CGFloat upView_W = (self.frame.size.width-2*space)-status_W;
    CGFloat upView_X = (self.frame.size.width-upView_W-status_W)/2;
    CGFloat upView_Y = 5;
    CGFloat upView_H = 100;
    _upView.frame = CGRectMake(upView_X, upView_Y, upView_W, upView_H);
    
    _moneyLabel.frame = CGRectMake(0, 0, 100, 100);
    _merchantIcon.frame = _moneyLabel.frame;
    
    CGFloat dLabel_W = 100;
    CGFloat dLabel_X = upView_W-dLabel_W-space;
    CGFloat dLabel_H = 100;
    _useDescLabel.frame = CGRectMake(dLabel_X, 0, dLabel_W, dLabel_H);
    
    _useNowBtn.frame = CGRectMake(0, 0, 80, 30);
    _dateLabel.frame = CGRectMake(upView_X,CGRectGetMaxY(_upView.frame), upView_W, 30);
    _statusLabel.frame = CGRectMake(CGRectGetMaxX(_upView.frame),_moneyLabel.frame.origin.y+10,20, 80);
    
    _moneyLabel.text = @"￥8";
//    _merchantIcon
    _useDescLabel.text = @"充值平台使用\n\n满100元可用";
    [_useNowBtn setTitle:@"立即使用" forState:UIControlStateNormal];
    [_useNowBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _dateLabel.text = @"2015.11.01--2015.11.11";
    _statusLabel.text = @"即将过期";
    
    _moneyLabel.font            = [UIFont systemFontOfSize:44];
    _useDescLabel.font          = [UIFont systemFontOfSize:16];
    _statusLabel.font           = [UIFont systemFontOfSize:15];
    _useNowBtn.titleLabel.font  = [UIFont systemFontOfSize:16];
    
    _useDescLabel.numberOfLines = 0;
    _statusLabel.numberOfLines = 0;
    _dateLabel.textAlignment = NSTextAlignmentRight;
    _useDescLabel.textAlignment = NSTextAlignmentRight;
    
    
    _upView.backgroundColor         = [UIColor yellowColor];
    _dateLabel.backgroundColor      = [UIColor lightGrayColor];
    _useNowBtn.backgroundColor      = [UIColor blueColor];
    _statusLabel.backgroundColor    = [UIColor cyanColor];
//    _useDescLabel.backgroundColor   = [UIColor redColor];
}



+ (SSLCounponCell *)cellWithTableView:(UITableView *)tabelView{
    
    static NSString * ident = @"SSLCounponCell";
    
    SSLCounponCell * cell = [tabelView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        
        cell = [[SSLCounponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    return cell;
}


@end
