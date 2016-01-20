//
//  GDHSelectCategoryTableViewCell.h
//  GongYong
//
//  Created by GDH on 15/12/30.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDHSelectCategoryTableViewCell : UITableViewCell
/** 名称 */
@property (weak, nonatomic) IBOutlet UILabel *selectNameText;
/** 图片对号 */
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end
