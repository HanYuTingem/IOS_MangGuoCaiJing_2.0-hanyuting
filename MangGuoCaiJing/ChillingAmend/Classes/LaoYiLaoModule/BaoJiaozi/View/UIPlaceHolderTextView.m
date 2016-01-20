//
//  UIPlaceHolderTextView.m
//  qqqq
//
//  Created by eleven on 15/3/16.
//  Copyright (c) 2015年 eleven. All rights reserved.
//

#import "UIPlaceHolderTextView.h"

@implementation UIPlaceHolderTextView
@synthesize placeHolderLabel;
@synthesize placeholder;
@synthesize placeholderColor;


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setPlaceholder:@""];
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    if([[self text] length] == 0)
    {
        [(UIView*)[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [(UIView*)[self viewWithTag:999] setAlpha:0];
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder] length] > 0 )
    {
        if ( placeHolderLabel == nil )
        {
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            placeHolderLabel.numberOfLines = 0;
            placeHolderLabel.font = self.font;
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            placeHolderLabel.textColor = self.placeholderColor;
            placeHolderLabel.alpha = 0;
            placeHolderLabel.tag = 999;
            [self addSubview:placeHolderLabel];
        }
        
//        placeHolderLabel.text = self.placeholder;
        placeHolderLabel.attributedText = [[NSAttributedString alloc] initWithString:self.placeholder attributes:[self textViewTextLineSpacing]];
        [placeHolderLabel sizeToFit];
        [self sendSubviewToBack:placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [(UIView*)[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}
/** 行间距,字间距 */
- (NSDictionary *)textViewTextLineSpacing{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 20;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13],
                                 NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName : @(1.3f),NSForegroundColorAttributeName : [UIColor whiteColor]
                                 };
    return attributes;
}
@end


