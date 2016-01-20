//
//  UIPlaceHolderTextView.h
//  qqqq
//
//  Created by eleven on 15/3/16.
//  Copyright (c) 2015年 eleven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView{
    NSString *placeholder;
    UIColor *placeholderColor;
    
@private
    UILabel *placeHolderLabel;
}

@property(nonatomic, retain) UILabel *placeHolderLabel;
@property(nonatomic, retain) NSString *placeholder;
@property(nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end

