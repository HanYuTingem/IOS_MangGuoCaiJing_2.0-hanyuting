//
//  LYLAdvertisingResultModel.h
//  LaoYiLao
//
//  Created by wzh on 16/1/8.
//  Copyright © 2016年 sunsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYLAdvertisingResultModel : NSObject


@property (nonatomic, strong) NSString *advpic;
@property (nonatomic, strong) NSString *placenum;
@property (nonatomic, strong) NSString *update_date;
+ (LYLAdvertisingResultModel *)advertisingResultModelWithDic:(NSDictionary *)dic;


@end
