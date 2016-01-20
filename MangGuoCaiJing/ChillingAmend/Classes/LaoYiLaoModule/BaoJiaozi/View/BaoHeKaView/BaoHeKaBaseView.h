//
//  BaoHeKaBaseView.h
//  LaoYiLao
//
//  Created by liujinhe on 16/1/7.
//  Copyright © 2016年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLLTextPutView.h"
#import "HCuttingVC.h"
#import "BaoHeKaViewController.h"
@interface BaoHeKaBaseView : UIScrollView <UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,HCuttingDelegate>
@property (nonatomic,strong)UIImageView *iWmageView;//贺卡大图

@property (nonatomic,strong)YLLTextPutView *textView;//下部View

@property (nonatomic,strong)UIImage *endimg;//显示图片

+ (BaoHeKaBaseView*)shareMangerWithVc:(UIViewController*)baoHeka;

- (void)turnBaseIttView;

@end
