//
//  CJTopUpRecordTableViewCell.m
//  Wallet
//
//  Created by zhaochunjing on 15-10-22.
//  Copyright (c) 2015年 Sinoglobal. All rights reserved.
//

#import "CJTopUpRecordTableViewCell.h"

@implementation CJTopUpRecordTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setTopUpModel:(CJTopUpModel *)topUpModel
{
    _topUpModel = topUpModel;
    //    if ([_topUpModel.amountType intValue] == 1) {
    if ([self.recordType intValue] == 1) {
        self.payTypeLabel.text = [NSString stringWithFormat:@"%@（%@）",_topUpModel.bankName,_topUpModel.cardSn];
        //    }else if ([_topUpModel.amountType intValue] == 0) {
    }else if ([self.recordType intValue] == 0) {
        switch ([_topUpModel.payType intValue]) {
            case 1:
                self.payTypeLabel.text = @"钱包";
                break;
            case 2:
                self.payTypeLabel.text = @"支付宝";
                break;
            case 3:
                self.payTypeLabel.text = @"借记卡";
                break;
            case 4:
                self.payTypeLabel.text = @"微信";
                break;
            default:
                break;
        }
    }
    self.timeLabel.text = [WalletRequsetHttp WalletTimeDateFormatterWithStr:_topUpModel.createDate];
    self.cashLabel.text = [NSString stringWithFormat:@"%@元",[WalletRequsetHttp addMoneyZeroWithMoneyText:[NSString stringWithFormat:@"%@",_topUpModel.amount]]];
    
    
    if (_topUpModel.orderSn.length) {//充值的
        
        switch ([_topUpModel.payStatus intValue]) {
            case 1:
                self.statusLabel.text = @"成功";
                self.cashLabel.textColor = [UIColor colorWithRed:100 / 255.0 green:110 / 255.0 blue:98 / 255.0 alpha:1];
                self.statusLabel.textColor = [UIColor colorWithRed:100 / 255.0 green:110 / 255.0 blue:98 / 255.0 alpha:1];
                break;
            case 2:
                self.statusLabel.text = @"失败";
                self.cashLabel.textColor = [UIColor colorWithRed:100 / 255.0 green:110 / 255.0 blue:98 / 255.0 alpha:1];
                self.statusLabel.textColor = [UIColor colorWithRed:100 / 255.0 green:110 / 255.0 blue:98 / 255.0 alpha:1];
                break;
            case 3:
                if ([_topUpModel.amountType intValue] == 1) {
                    self.statusLabel.text = @"处理中";
                } else if ([_topUpModel.amountType intValue] == 0) {
                    
                    self.statusLabel.text = @"待充值";
                }
                self.cashLabel.textColor = [UIColor colorWithRed:0.84f green:0.18f blue:0.13f alpha:1.00f];
                self.statusLabel.textColor = [UIColor colorWithRed:0.84f green:0.18f blue:0.13f alpha:1.00f];
                
                break;
            case 4:
                self.statusLabel.text = @"充值中";
                self.cashLabel.textColor = [UIColor colorWithRed:1.00f green:0.51f blue:0.04f alpha:1.00f];
                self.statusLabel.textColor = [UIColor colorWithRed:1.00f green:0.51f blue:0.04f alpha:1.00f];
                break;
            case 5:
                self.statusLabel.text = @"已关闭";
                self.cashLabel.textColor = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];
                self.statusLabel.textColor = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];
                break;
                
            default:
                break;
        }
    } else {//提现的
        switch ([_topUpModel.status intValue]) {
            case 0:
                self.statusLabel.text = @"失败";
                self.cashLabel.textColor = [UIColor colorWithRed:100 / 255.0 green:110 / 255.0 blue:98 / 255.0 alpha:1];
                self.statusLabel.textColor = [UIColor colorWithRed:100 / 255.0 green:110 / 255.0 blue:98 / 255.0 alpha:1];
                break;
            case 1:
                self.statusLabel.text = @"成功";
                self.cashLabel.textColor = [UIColor colorWithRed:1.00f green:0.51f blue:0.04f alpha:1.00f];
                self.statusLabel.textColor = [UIColor colorWithRed:1.00f green:0.51f blue:0.04f alpha:1.00f];
                break;
            case 2:
                self.statusLabel.text = @"已关闭";
                self.cashLabel.textColor = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];
                self.statusLabel.textColor = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];
                break;
            case 3:
                if ([_topUpModel.amountType intValue] == 1) {
                    self.statusLabel.text = @"处理中";
                } else if ([_topUpModel.amountType intValue] == 0) {
                    
                    self.statusLabel.text = @"待充值";
                }
                self.cashLabel.textColor = [UIColor colorWithRed:0.84f green:0.18f blue:0.13f alpha:1.00f];
                self.statusLabel.textColor = [UIColor colorWithRed:0.84f green:0.18f blue:0.13f alpha:1.00f];
                break;
                
            default:
                break;
        }
    }
    
    
    
}


-(void)makeRefreshUIRowCell:(NSInteger)rowCell
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
