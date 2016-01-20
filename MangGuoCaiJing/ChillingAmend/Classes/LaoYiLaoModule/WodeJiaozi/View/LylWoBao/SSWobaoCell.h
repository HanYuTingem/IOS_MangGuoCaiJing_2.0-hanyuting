//
//  SSWobaoCell.h
//  LaoYiLao
//
//  Created by sunsu on 15/12/16.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WobaoCashResultModel.h"
@interface SSWobaoCell : UITableViewCell
//- (void)showViewWithCellType:(NSString *)cellType;

@property (nonatomic, strong)WobaoCashResultModel * cashResultModel;
+ (SSWobaoCell *)cellWithTableView:(UITableView *)tabelView;
@end
