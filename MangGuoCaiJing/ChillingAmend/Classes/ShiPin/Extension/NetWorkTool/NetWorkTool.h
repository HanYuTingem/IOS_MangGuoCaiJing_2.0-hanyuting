//
//  NetWorkTool.h
//  test
//
//  Created by ZCS on 15/8/30.
//  Copyright (c) 2015年 LM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkTool : NSObject
/**
 *  访问网络请求
 *
 *  @param url        请求网址
 *  @param way        请求方式（GET/POST）
 *  @param parameters 参数列表（字典）
 *  @param finished   完成回调
 *  @param haveError  出错回调
 */
+ (void)NetRequestWithBaseURL:(NSString*)baseURL andAppendURL:(NSString*)url
                   RequestWay:(NSString*)way
                   Parameters:(id)parameters
                     finished:(void (^)(id data))finished
                      failure:(void (^)(NSError* error))failure;

- (void)NetRequestWithBaseURL:(NSString*)baseURL andAppendURL:(NSString*)url
                   RequestWay:(NSString*)way
                   Parameters:(id)parameters
                     finished:(void (^)(id data))finished
                      failure:(void (^)(NSError* error))failure;

@end
