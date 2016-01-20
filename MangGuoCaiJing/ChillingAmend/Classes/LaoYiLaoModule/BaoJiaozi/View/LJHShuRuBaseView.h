//
//  LJHShuRuBaseView.h
//  LaoYiLao
//
//  Created by liujinhe on 15/12/11.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJHShuRuView.h"
#import "ZhiFuErView.h"
/**
 *  输入view
 */

@interface LJHShuRuBaseView : UIScrollView<UITextFieldDelegate,UITextViewDelegate>
{
    BOOL isGei;
}
@property (nonatomic,strong)LJHShuRuView* teswView;//顶部text
@property (nonatomic,strong)LJHShuRuView* midView;//中部text
@property (nonatomic,strong)LJHShuRuView* bumView;//底部text
@property (nonatomic,strong)ZhiFuErView * zhiFuView;
@property (nonatomic,strong)UILabel* batre;
@property (nonatomic,strong)void(^TextFileDblock)(UITextField*textFiled);//回调输入
@property (nonatomic,strong)void(^TextViewDblock)(UITextView*textView);//留言回调
@end
