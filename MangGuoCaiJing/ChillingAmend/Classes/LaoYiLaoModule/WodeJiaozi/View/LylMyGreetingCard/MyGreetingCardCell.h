//
//  MyGreetingCardCell.h
//  LaoYiLao
//
//  Created by sunsu on 15/12/16.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WobaoCardResultModel.h"
@interface MyGreetingCardCell : UITableViewCell

@property (nonatomic, strong) WobaoCardResultModel *resultModel;
+ (MyGreetingCardCell *)cellWithTableView:(UITableView *)tabelView;

@end
