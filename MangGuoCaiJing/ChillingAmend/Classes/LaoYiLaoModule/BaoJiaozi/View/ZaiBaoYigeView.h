//
//  ZaiBaoYigeView.h
//  LaoYiLao
//
//  Created by sunsu on 15/12/15.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  有缘人包好
 */
@protocol ZaiBaoYigeViewDelegate <NSObject>
-(void)ZaiBaoYige;
-(void)ShareBaoJiaozi;
@end


@interface ZaiBaoYigeView : UIView
@property(nonatomic,weak)id<ZaiBaoYigeViewDelegate>delegate;
@end
