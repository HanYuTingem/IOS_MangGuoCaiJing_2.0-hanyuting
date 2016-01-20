//
//  YLLTextPutView.h
//  LaoYiLao
//
//  Created by liujinhe on 15/12/14.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@protocol YLLTextPutViewDelegate <NSObject>
/** 点击发饺子 */
- (void)clickSendDumplingByStr:(NSString *)str;
@end

@interface YLLTextPutView : UIView<UITextViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    /** 线 */
    UILabel *_oneLine;
    UILabel *_twoLine;
    /** 默认祝福语是第几句标记 */
    int  _blessingFlag;
    /** 祝福语替换 */
    NSString  *_blessingTemp;
    
}
/** 发贺卡代理 */
@property (nonatomic, assign) id<YLLTextPutViewDelegate> delegate;
@property (nonatomic,strong)UIPlaceHolderTextView *textV;
/** 祝福语数组 */
@property (nonatomic, strong) NSMutableArray *blessingStrArray;
/** 换一换祝福语button */
@property (nonatomic, strong) UIButton *changeBlessingButton;
/** 发送(发饺子) */
@property (nonatomic, strong) UIButton *sendButton;
/** 当前祝福语 */
@property (nonatomic, copy) NSString *nowBlessing;
/** 隐藏键盘 */
-(void)hiddenYLLKeyBoard;
/** 当前祝福语,未点击发饺子直接返回 需先调此方法，才能直接调nowBlessing 得到当前的祝福语 */
-(void)whenClickBackButton;
@end
