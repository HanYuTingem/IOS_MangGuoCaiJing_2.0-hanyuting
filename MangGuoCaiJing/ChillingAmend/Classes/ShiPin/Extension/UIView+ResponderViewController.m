//
//  UIView+ResponderViewController.m
//  ChillingAmend
//
//  Created by yc on 15/7/29.
//  Copyright (c) 2015年 SinoGlobal. All rights reserved.
//

#import "UIView+ResponderViewController.h"

@implementation UIView (ResponderViewController)

- (AppDelegate *)appDelegate {

  return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
//*通过响应者链条得到ViewController*/
- (UIViewController *)responderViewController {
  UIResponder *next = [self nextResponder];
  do {
    if ([next isKindOfClass:[UIViewController class]]) {
      return (UIViewController *)next;
    }
    next = [next nextResponder];
  } while (next != nil);
  return nil;
}

@end
