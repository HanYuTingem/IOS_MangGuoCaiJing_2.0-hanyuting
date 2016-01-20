//
//  YLLTextPutView.m
//  LaoYiLao
//
//  Created by liujinhe on 15/12/14.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#define KYLLLineHeight   5
#define KYLLTextViewLineSpacing 20
//#define kYllTextViewTextMax      30
//#define kYLLPlaceholderColor  [UIColor whiteColor]
#define kYLLTextColor    [UIColor blackColor]

#import "YLLTextPutView.h"

@implementation YLLTextPutView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        //顺序不能调
        [self initChangeBlessingButtonUI];
        [self initTextViewUI];
        [self initSendDumplingButtonUI];
    }
    return self;
}
/** 换一换 */
- (void)initChangeBlessingButtonUI{
    self.blessingStrArray = [[NSMutableArray alloc]initWithObjects:@"春风扣开羊年的门扉，对联贴满羊年的庭院，欢畅陶醉羊年的日子",@"愿明亮喜庆的春节，象征与温暖你一年中的每个日日夜夜",@"妈妈我感谢你赐给了我生命，我永远爱您，",@"除夕到，真热闹，家家户户放鞭炮，赶走晦气和烦恼，", nil];
    _blessingFlag = 0;
    self.changeBlessingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.changeBlessingButton.frame = CGRectMake(self.frame.size.width - 24 - 75, 16, 75, 15);
    [self.changeBlessingButton setImage:[UIImage imageNamed:@"ljh_baoheka_bg-shuaxin-2.png"] forState:UIControlStateNormal];
    self.changeBlessingButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.changeBlessingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.changeBlessingButton setTitle:@"换一换" forState:UIControlStateNormal];
    [self.changeBlessingButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [self.changeBlessingButton addTarget:self action:@selector(changeBlessingButtonClickAction:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.changeBlessingButton];
}
/** 输入框 */
- (void)initTextViewUI{
    self.textV = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(20, 40, self.frame.size.width - 40, 68)];
    [self.textV setBackgroundColor:[UIColor clearColor]];
    self.textV.font = [UIFont systemFontOfSize:13];
    self.textV.delegate = self;
    self.textV.placeholder = self.blessingStrArray[_blessingFlag];
    self.textV.typingAttributes = [self textViewTextLineSpacing];
//    [self.textV setTextColor:kYLLPlaceholderColor];
    [self addSubview:self.textV];
    
    
    _oneLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 33, self.textV.frame.size.width, 0.5)];
    _oneLine.backgroundColor = [UIColor whiteColor];
    [self.textV addSubview:_oneLine];
    _twoLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 67, self.textV.frame.size.width, 0.5)];
    _twoLine.backgroundColor = [UIColor whiteColor];
    //        _twoLine.hidden = YES;
    [self.textV addSubview:_twoLine];
}
/** 发送 */
- (void)initSendDumplingButtonUI{
    self.sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.sendButton.frame = CGRectMake(self.frame.size.width/2 - 86/2, (self.frame.size.height - 86 - 108)/2.0 + 108, 86, 86);
    [self.sendButton setBackgroundImage:[UIImage imageNamed:@"ljh_baoheka_bgbth.png"] forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(sendDumplingButtonClickAction:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.sendButton];
}
/** 行间距,字间距 */
- (NSDictionary *)textViewTextLineSpacing{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = KYLLTextViewLineSpacing;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:self.textV.font,
                                 NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName : @(1.3f),NSForegroundColorAttributeName : [UIColor whiteColor]
                                 };
    return attributes;
}

/** 发饺子Button Action */
- (void)sendDumplingButtonClickAction:(id)sender{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickSendDumplingByStr:)]) {
        if (self.textV.text.length > 0) {
            [self.delegate clickSendDumplingByStr:self.textV.text];
            self.nowBlessing = self.textV.text;
        }else{
            [self.delegate clickSendDumplingByStr:self.blessingStrArray[_blessingFlag]];
            self.nowBlessing = self.blessingStrArray[_blessingFlag];
        }
        
    }
}
/** 换一换Button Action */
- (void)changeBlessingButtonClickAction:(id)sender{
    if (self.textV.text.length > 0) {
        [self initAlertForChangeBlessing];
    }else{
        [self replaceBlessing];
    }
}

/** 提示是否换一换 */
-(void)initAlertForChangeBlessing{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否更换祝福语" message:@"原有祝福语将会被替换" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去更换", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self replaceBlessing];
    }
}
/** 替换祝福语 */
-(void)replaceBlessing{
    if (_blessingFlag < self.blessingStrArray.count-1) {
        _blessingFlag++;
    }else{
        _blessingFlag = 0;
    }
    self.textV.placeholder = self.blessingStrArray[_blessingFlag];
    self.textV.text = @"";
    self.textV.placeHolderLabel.attributedText = [[NSAttributedString alloc] initWithString:self.blessingStrArray[_blessingFlag] attributes:[self textViewTextLineSpacing]];
    [self.textV resignFirstResponder];
    _twoLine.hidden = NO;
}
/** 清除默认祝福语 */
- (void)cleanDefaultBlessing{
    self.textV.text = @"";
    self.textV.textColor = kYLLTextColor;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.contentSize.height > 68) {
        textView.text = [textView.text substringToIndex:textView.text.length-2];
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.contentSize.height > 68) {
        textView.text = [textView.text substringToIndex:textView.text.length-2];
    }
    return YES;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > 0) {
        [self.textV setContentOffset:CGPointMake(0, 0)];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textV resignFirstResponder];
}
-(void)hiddenYLLKeyBoard{
    [self.textV resignFirstResponder];
}
-(void)whenClickBackButton{
    if (self.textV.text.length > 0) {
        self.nowBlessing = self.textV.text;
    }else{
        self.nowBlessing = self.blessingStrArray[_blessingFlag];
    }
}
@end


