//
//  WoBaoViewFor.h
//  LaoYiLao
//
//  Created by sunsu on 15/12/16.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSWobaoCell.h"

@interface WoBaoViewFor : UIView
//@property (nonatomic, strong) NSString  * wobaoViewType;
@property (nonatomic, strong) UITableView   * woBaoTableView;
//-(void)showViewWithType:(NSString *)wobaoViewType;

@property (nonatomic, strong)UIViewController * controller;
@end
