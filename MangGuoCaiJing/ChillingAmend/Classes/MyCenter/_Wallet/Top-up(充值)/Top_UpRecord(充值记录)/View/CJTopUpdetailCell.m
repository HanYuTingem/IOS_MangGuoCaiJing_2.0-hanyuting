//
//  CJTopUpdetailCell.m
//  GongYong
//
//  Created by zhaochunjing on 15-12-15.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "CJTopUpdetailCell.h"

@interface CJTopUpdetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation CJTopUpdetailCell



- (void)setCellModel:(CJTopUpCellModel *)cellModel
{
    self.titleNameLabel.text = cellModel.name;
    self.contentLabel.text = cellModel.content;
    if ([cellModel.name isEqualToString:@"实际到账："]) {
        self.contentLabel.textColor =  [UIColor colorWithRed:0.84f green:0.18f blue:0.13f alpha:1.00f];
        self.contentLabel.font = [UIFont boldSystemFontOfSize:14];
    } else if ([cellModel.name isEqualToString:@"提现金额："]) {
        if (![cellModel.content rangeOfString:@"("].length) {
            self.contentLabel.textColor =  [UIColor colorWithRed:0.84f green:0.18f blue:0.13f alpha:1.00f];
        }
    }
}
- (void)setContentLocation:(ContentLocation)contentLocation
{
    _contentLocation = contentLocation;
    if (contentLocation == ContentLocationRight) {
        self.contentLabel.textAlignment = NSTextAlignmentRight;
    } else if (contentLocation == ContentLocationLeft){
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
    } else {
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
