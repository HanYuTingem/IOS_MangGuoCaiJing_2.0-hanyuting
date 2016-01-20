//
//  playerObject.h
//  playerSDK
//
//  Created by nsstring on 15/8/11.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface playerObject : NSObject

@property (nonatomic, assign) CGFloat playerHeight;
@property (nonatomic, assign) CGFloat playerWidth;
@property (nonatomic, assign) CGFloat playerX;
@property (nonatomic, assign) CGFloat playerY;

//单例
+ (id)Instence;

@end
