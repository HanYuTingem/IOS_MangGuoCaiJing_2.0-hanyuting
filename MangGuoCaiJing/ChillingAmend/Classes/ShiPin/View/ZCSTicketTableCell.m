//
//  ZCSTicketTableCell.m
//  fanxiaoqi
//
//  Created by ZCS on 15/12/1.
//  Copyright © 2015年 sinoglobal. All rights reserved.
//

#import "ZCSTicketTableCell.h"

#import "UIImageView+WebCache.h"
#import "CZButton.h"
@interface ZCSTicketTableCell ()

/** 店家名称 */
@property (weak, nonatomic) IBOutlet UILabel* shopNameLabel;

/** 券简介 */
@property (weak, nonatomic) IBOutlet UILabel* ticketIntroLabel;

/** 现价 */
@property (weak, nonatomic) IBOutlet UILabel* current_PriceLabel;
/** 原价 */
@property (weak, nonatomic) IBOutlet UILabel* old_PriceLabel;
/** 热门图片 */
@property (weak, nonatomic) IBOutlet UIImageView* hotImage;
/** 立即抢购 */
@property (weak, nonatomic) IBOutlet CZButton* grab;
/** 左边的View */
@property (weak, nonatomic) IBOutlet UIView* leftView;
/** 右边的 */
@property (weak, nonatomic) IBOutlet UIView* rightView;

@end
@implementation ZCSTicketTableCell
/** 创建单元格 */
+ (ZCSTicketTableCell*)createFooterCell:(UITableView*)tableView
{
    static NSString* cellID = @"ZCSTicketTableCellID";

    ZCSTicketTableCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ZCSTicketTableCell" owner:self options:nil][0];
    }

    return cell;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    //    [self.restCountLabel setNeedsLayout];
}

/** 取消高亮状态 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated

{
}
- (CGFloat)rowHight:(LMTicketModal*)grabModel
{
    self.lmTicketModal = grabModel;
    [self layoutIfNeeded];
    CGFloat h = CGRectGetMaxY(self.restCountLabel.frame) + 20;
    return h;
}
@end
