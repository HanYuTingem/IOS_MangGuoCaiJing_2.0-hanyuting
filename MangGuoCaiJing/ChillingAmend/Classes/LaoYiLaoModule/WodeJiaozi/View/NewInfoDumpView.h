//
//  NewInfoDumpView.h
//  LaoYiLao
//
//  Created by sunsu on 15/12/9.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DumpBtn.h"
#import "SSMyDumplingModel.h"


@protocol NewInfoDumpViewDelegate <NSObject>

-(void)wolaoBtnClicked:(DumpBtn *)sender;
-(void)wobaoBtnClicked:(DumpBtn *)sender;
-(void)Xuanyaoyixia;
@end

@interface NewInfoDumpView : UIView
@property (nonatomic, strong) SSMyDumplingModel  * myDumpModel;
@property (nonatomic, weak) id<NewInfoDumpViewDelegate>delegate;
@end
