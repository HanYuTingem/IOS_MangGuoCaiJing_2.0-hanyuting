//
//  CJTopUpdetailCell.h
//  GongYong
//
//  Created by zhaochunjing on 15-12-15.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJTopUpCellModel.h"

/** 内容位置 默认为left */
typedef NS_ENUM(int, ContentLocation) {
    ContentLocationLeft,
    ContentLocationRight,
    ContentLocationCenter
};

@interface CJTopUpdetailCell : UITableViewCell

@property (nonatomic, strong) CJTopUpCellModel *cellModel;
/** 内容位置 默认为left */
@property (nonatomic, assign) ContentLocation contentLocation;
@end
