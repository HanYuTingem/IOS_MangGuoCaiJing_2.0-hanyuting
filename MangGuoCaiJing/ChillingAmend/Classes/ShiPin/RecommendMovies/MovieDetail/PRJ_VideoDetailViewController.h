//
//  PRJ_VideoDetailViewController.h
//  ChillingAmend
//
//  Created by svendson on 14-12-23.
//  Copyright (c) 2014年 SinoGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPCommonMacros.h"
#import "playerView.h"

@interface PRJ_VideoDetailViewController : GCViewController

//视频ID
@property (nonatomic, strong) NSString *videoID;
@property (strong, nonatomic) playerView* playerV;
@property (strong, nonatomic) UIButton *backBtn;
//详情字典
@property (nonatomic, strong) NSDictionary *detailDic;

- (void)requstTheAwardOfLookVideoInCompleteTime;
@end
