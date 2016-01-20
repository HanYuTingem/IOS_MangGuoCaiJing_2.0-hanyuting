//
//  TicketModal.m
//  fanxiaoqi
//
//  Created by 李敏 on 15/9/16.
//  Copyright (c) 2015年 sinoglobal. All rights reserved.
//

#import "LMTicketModal.h"

@implementation LMTicketModal

- (void)setXssl:(NSString *)xssl {
    if ([xssl isKindOfClass:[NSNumber class]]) {
        _xssl = [NSString stringWithFormat:@"%@", xssl];
    } else {
        _xssl = xssl;
    }
}
-(void)setSysl:(NSString *)sysl
{
    if ([sysl isKindOfClass:[NSNumber class]])
    {
        _sysl = [NSString stringWithFormat:@"%@",sysl];
        
    }else
    {
        _sysl = sysl;
    }
}
-(void)setIsMark:(NSString *)isMark{
    if ([isMark isKindOfClass:[NSNumber class]])
    {
        _isMark = [NSString stringWithFormat:@"%@",isMark];
        
    }else
    {
        _isMark = isMark;
    }
}
@end
