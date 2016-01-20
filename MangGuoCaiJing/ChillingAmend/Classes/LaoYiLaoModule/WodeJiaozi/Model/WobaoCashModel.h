//
//  WobaoCashModel.h
//  LaoYiLao
//
//  Created by sunsu on 15/12/19.
//  Copyright © 2015年 sunsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WobaoCashResultModel.h"
@interface WobaoCashModel : NSObject
@property (nonatomic, strong) NSString * put_price;//我包现金
@property (nonatomic, strong) NSString * number_price;//现金饺子个数（小锅个数）
@property (nonatomic, strong)NSMutableArray * cashResultArray;
+ (WobaoCashModel *)getWobaoCashModelWithDic:(NSDictionary *)dic;
@end
