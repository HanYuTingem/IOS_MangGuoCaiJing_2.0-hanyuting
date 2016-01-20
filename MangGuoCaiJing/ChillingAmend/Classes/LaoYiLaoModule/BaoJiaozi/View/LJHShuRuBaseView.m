//
//  LJHShuRuBaseView.m
//  LaoYiLao
//
//  Created by liujinhe on 15/12/11.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import "LJHShuRuBaseView.h"

#define LLTEXTHight  48//text的高度
#define LL_JianGe_Hight  16 //间隔1
#define LL_JianGe2_Hight  34 //间隔2
#define LL_TEXT_Hight  37 //输入框起点
#define LL_TEXT_XPoiT  15
#define LL_LABEL_XLABT  18
#define myDotNumbers     @"0123456789.\n"
#define myNumbers          @"0123456789\n"

@implementation LJHShuRuBaseView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self makeUIerWite];
    }

    return self;
}
- (void)makeUIerWite{
    //顶部
    CGRect frAse = CGRectMake(LL_TEXT_XPoiT, LL_TEXT_Hight,kkViewWidth-LL_TEXT_XPoiT*2, LLTEXTHight);
    _teswView = [[LJHShuRuView alloc] initWithFrame:frAse];
    _teswView.shuRulabel.delegate = self;
    _teswView.cheHulabel.text = @"饺子个数:";
    _teswView.danWeilabel.text = @"个";
    _teswView.shuRulabel.placeholder = @"填写个数";
    _teswView.shuRulabel.tag = 100;
    _teswView.shuRulabel.textAlignment = UITextAlignmentRight;
    _teswView.shuRulabel.keyboardType =  UIKeyboardTypeNumberPad;

    [self addSubview:_teswView];
    //中部
    CGRect frMidee = CGRectMake(LL_TEXT_XPoiT, CGRectGetMaxY(frAse)+LL_JianGe_Hight,kkViewWidth-LL_TEXT_XPoiT*2, LLTEXTHight);
    _midView = [[LJHShuRuView alloc] initWithFrame:frMidee];
    _midView.shuRulabel.delegate = self;
    _midView.cheHulabel.text = @"总金额:";
    _midView.danWeilabel.text = @"元";
    _midView.shuRulabel.placeholder = @"填写金额";
    _midView.shuRulabel.tag = 101;
    _midView.shuRulabel.textAlignment = UITextAlignmentRight;
    _midView.shuRulabel.keyboardType =  UIKeyboardTypeDecimalPad;
    [self addSubview:_midView];
    //底部text
    CGRect frQwWe = CGRectMake(LL_TEXT_XPoiT, CGRectGetMaxY(frMidee)+LL_JianGe2_Hight,kkViewWidth-LL_TEXT_XPoiT*2, LLTEXTHight*2);
    _bumView = [[LJHShuRuView alloc] initWithFrame:frQwWe];
    _bumView.cheHulabel.frame = CGRectMake(7, 2, 50, 50);
    _bumView.shuRulabel.hidden = YES;
    _bumView.danWeilabel.hidden = YES;
    _bumView.textTlike.hidden = NO;
    _bumView.cheHulabel.text = @"留言:";
    _bumView.cheHulabel.font = UIFont32;
    _bumView.textTlike.delegate = self;
    [self addSubview:_bumView];
    //中间介绍
    _batre = [[UILabel alloc] initWithFrame:CGRectMake(LL_LABEL_XLABT,  CGRectGetMaxY(frMidee)+9, kkViewWidth-2*LL_TEXT_XPoiT, LL_JianGe_Hight)];
    _batre.text = @"每人可领1个,金额随机且不超过200元";
    _batre.textAlignment = NSTextAlignmentLeft;
    _batre.textColor = [UIColor whiteColor];
    _batre.font = UIFont30;
    [self addSubview:_batre];
    //底部
     _zhiFuView = [[ZhiFuErView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(frQwWe), kkViewWidth, kkViewHeight - CGRectGetMaxY(frQwWe)-64)];
    //_zhiFuView.backgroundColor = [UIColor yellowColor];
    [self addSubview:_zhiFuView];
    
}
#pragma mark textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        isGei = NO;
        [_teswView.shuRulabel resignFirstResponder];
        [_midView.shuRulabel resignFirstResponder];
        [_bumView.shuRulabel resignFirstResponder];
        [_bumView.textTlike resignFirstResponder];
    
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSLog(@"%@",textField.text);
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSLog(@"%@++++%d---%@--%d****%@",textField.text,range.length,range.location,range.length,string);
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"%@",toBeString);
    
    if (textField.tag==100) {
        if ([toBeString integerValue]>100){
           // textField.text = [toBeString substringToIndex:2];  toBeString.length > 2 && range.length!=1&&![toBeString isEqualToString:@"100"
            [LYLTools showHint:@"一次最多可发100个饺子"];
            return NO;
        }
        if(toBeString.length==1 && [string isEqualToString:@"0"]){
            
            return NO;
        
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers]invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if (!basicTest) {
            return NO;
        }
        
    }else if (textField.tag==101){
        if ([toBeString integerValue]>5000) {

            [LYLTools showHint:@"单次支付总额不可超过5000元"];
            return NO;
        }
        if ([toBeString rangeOfString:@"0"].location==0 &&[toBeString rangeOfString:@"."].length!=1 ) {
            NSUInteger nWetLoc = [textField.text rangeOfString:@"0"].location;
            if (NSNotFound != nWetLoc) {
                NSArray*  aerNum = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
                for (int i = 0;i<aerNum.count;i++) {
                    if ([string isEqualToString:aerNum[i]]) {
                        return NO;
                    }
                }
            }
        }
        if ([toBeString rangeOfString:@"."].location ==0) {
            return NO;
        }
        NSUInteger nqNittLoc = [textField.text rangeOfString:@"."].location;
        if (NSNotFound != nqNittLoc) {
            if ([string isEqualToString:@"."]) {
                return NO;
            }
        }
       
        NSCharacterSet *cs;
        NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
        if (NSNotFound == nDotLoc && 0 != range.location) {
            cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers]invertedSet];
            if ([string isEqualToString:@"."]) {
                return YES;
            }
            if (textField.text.length>=6) {  //小数点前面6位
                return NO;
            }
        }
        else {
            cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers]invertedSet];
            if (textField.text.length>=9) {
                return  NO;
            }
        }
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if (!basicTest) {
            return NO;
        }
        if (NSNotFound != nDotLoc && range.location > nDotLoc +2 ) {//小数点后面两位
            return NO;

        }
    
    }
        
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
  //  NSLog(@"%@",textField.text);
    _TextFileDblock(textField);
    
}
#pragma mark textView
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;

}
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
//
//
//}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    isGei = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
   
    _TextViewDblock(textView);
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (textView.text.length>30) {
        
       return NO;
    }else{
        return YES;
    }
    

}
- (void)textViewDidChange:(UITextView *)textView{
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 10;// 字体的行间距
//    
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:paragraphStyle
//                                 
//                                 };
//    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
//
//    NSInteger number = [textView.text length];
//    if (number > 15) {
//        [LYLTools showInfoAlert:@"字数不能超过15个哦"];
//        textView.text = [textView.text substringToIndex:15];
//        number = 15;
//        
//    }
    NSInteger number = [textView.text length];
    if (number >30) {
        
        textView.text = [textView.text substringToIndex:30];
//        [self showHint:@"饺子个数不能为空" yOffset:-100];
//     [LYLTools showInfoAlert:@"字数不能超过30个哦"];
        //只显示文字
        if (isGei==YES) {
               [LYLTools showHint:@"字数不能超过30个哦"];
        }
     

        return;
    }else{
        
    }
}





- (void)textViewDidChangeSelection:(UITextView *)textView{

}
@end
