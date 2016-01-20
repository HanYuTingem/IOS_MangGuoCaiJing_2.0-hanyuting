//
//  ZXADTableView.h
//  fanxiaoqi
//
//  Created by xiong on 15/10/27.
//  Copyright © 2015年 sinoglobal. All rights reserved.
//

#import "ZCSTicketTableCell.h"
#import <UIKit/UIKit.h>

@interface ZXADTableView : UIView <UITableViewDelegate, UITableViewDataSource, LMTicketTableDelegate>
/** 下方的滚动广告 */
@property (weak, nonatomic) IBOutlet UIScrollView* bottomADScrollView;
/** 免费菜品的列表页 */
@property (weak, nonatomic) IBOutlet UITableView* tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* tableHeight;

+ (id)createADTableView;
- (void)updateTableHeight;

@end
