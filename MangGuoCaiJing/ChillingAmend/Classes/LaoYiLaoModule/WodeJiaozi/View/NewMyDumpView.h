//
//  NewMyDumpView.h
//  LaoYiLao
//
//  Created by sunsu on 15/12/9.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewInfoDumpView.h"
#import "SSMyDumplingModel.h"


@interface NewMyDumpView : UIView
@property (nonatomic, strong)NewInfoDumpView * infoDumpView;
@property (nonatomic, strong) SSMyDumplingModel * myDumpModel;
@end
