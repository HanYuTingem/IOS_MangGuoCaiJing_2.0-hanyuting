//
//  GDHSelectCategoryView.h
//  GongYong
//
//  Created by GDH on 15/12/30.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GDHSelectCategoryViewDelegate <NSObject>

/** 选中的类型 */
-(void)GDHSelectCategoryViewSelectCategory:(NSString *)catrgory;
/** 遮罩点击事件 */
-(void)GDHSelectCategoryViewMaskButtonDown:(UIButton *)maskButton;

@end

@interface GDHSelectCategoryView : UIView

@property (nonatomic,assign) id <GDHSelectCategoryViewDelegate>delegate;

@property(nonatomic,strong) UITableView *selectTableView;

+(instancetype)selectCategoryView;


@end
