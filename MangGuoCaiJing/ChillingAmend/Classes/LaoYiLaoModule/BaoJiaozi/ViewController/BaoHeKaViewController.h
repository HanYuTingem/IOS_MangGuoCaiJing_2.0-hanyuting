//
//  BaoHeKaViewController.h
//  LaoYiLao
//
//  Created by liujinhe on 15/12/10.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LaoYiLaoBaseViewController.h"
#import "HCuttingVC.h"
#import "BaoHeKaBaseView.h"
#import "BaoJiaoSuccectController.h"
/**
 *  包贺卡
 */
@interface BaoHeKaViewController : LaoYiLaoBaseViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,assign)NSInteger baoHeKaLaitap;//记录来源:0:朋友 1: 有缘人
@end
