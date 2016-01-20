//
//  HCuttingDelegate.h
//  HImageCutting
//
//  Created by 李祖浩 on 14-5-15.
//  Copyright (c) 2014年 李祖浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HCuttingDelegate <NSObject>
- (void)imagedidFinishCroppingWithImage:(UIImage *)hImage;
@end
