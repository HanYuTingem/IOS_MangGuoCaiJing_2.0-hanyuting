//
//  LJHTextView.h
//  LaoYiLao
//
//  Created by liujinhe on 15/12/15.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  TextView封装
 */
@interface LJHTextView : UITextView
@property (nonatomic,copy)NSString  *myPlaceholder;//文字
@property (nonatomic,strong)UIColor *myPlaceholderColor;//文字颜色
@end
