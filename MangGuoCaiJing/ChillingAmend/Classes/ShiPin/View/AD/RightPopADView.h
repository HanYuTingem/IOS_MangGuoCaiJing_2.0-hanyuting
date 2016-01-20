//
//  RightPopADView.h
//  fanxiaoqi
//
//  Created by zuoxiong on 15/9/21.
//  Copyright (c) 2015年 sinoglobal. All rights reserved.
//

//#import "ADView.h"
@import UIKit;

@interface RightPopADView : UIView
@property (weak, nonatomic) IBOutlet UIView* placeHolderView;
@property (nonatomic, strong) NSArray* btnArray;
@property (weak, nonatomic) IBOutlet UIView* grabPlaceHolderView;

+ (id)createRPAV;
@end
