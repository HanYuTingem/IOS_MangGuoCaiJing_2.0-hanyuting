//
//  ZCSTicketTableCell.h
//  fanxiaoqi
//
//  Created by ZCS on 15/12/1.
//  Copyright © 2015年 sinoglobal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LMTicketModal,ZCSTicketTableCell;
@protocol LMTicketTableDelegate <NSObject>

-(void)grabBtnClick:(LMTicketModal *)ticketModal;

@end



@interface ZCSTicketTableCell : UITableViewCell
/** 创建单元格 */
+(ZCSTicketTableCell *)createFooterCell:(UITableView *)tableView;
/** 券modal */
@property(nonatomic,strong)LMTicketModal *lmTicketModal;
/** 剩余份数 */
@property (weak, nonatomic) IBOutlet UILabel *restCountLabel;
@property (nonatomic, weak) id<LMTicketTableDelegate> delegate;
/** 底部的一条线 */
@property (weak, nonatomic) IBOutlet UIView *footLine;

/** 优惠券的图片 */
@property (weak, nonatomic) IBOutlet UIImageView *ticketImage;
-(CGFloat)rowHight:(LMTicketModal *)grabModel;
@end
