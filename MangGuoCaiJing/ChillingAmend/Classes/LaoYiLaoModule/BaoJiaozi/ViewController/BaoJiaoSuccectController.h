//
//  BaoJiaoSuccectController.h
//  LaoYiLao
//
//  Created by liujinhe on 15/12/16.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJHTanChuNeiView.h"
/**
 *  包饺子成功
 */
@interface BaoJiaoSuccectController : LaoYiLaoBaseViewController<LJHTanChuNeiViewDelegate>
@property (nonatomic,assign)NSInteger tempDe;//来源:1包饺子,2.包贺卡有缘人,3包贺卡朋友
@property (nonatomic,strong) NSString *dumplinguserputmoneyid;//
@end
