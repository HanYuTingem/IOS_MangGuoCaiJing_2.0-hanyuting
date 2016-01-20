
//  NetWorkTool.m
//  test
//
//  Created by ZCS on 15/8/30.
//  Copyright (c) 2015年 LM. All rights reserved.
//

#import "NetWorkTool.h"
#import "AFNetworking.h"
@class NetWorkTool;

@implementation NetWorkTool
+ (void)NetRequestWithBaseURL:(NSString*)baseURL andAppendURL:(NSString*)url
                   RequestWay:(NSString*)way
                   Parameters:(id)parameters
                     finished:(void (^)(id data))finished
                      failure:(void (^)(NSError* error))failure
{

    // 2.请求管理器
    AFHTTPRequestOperationManager* manager =
        [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    
    // 3.发起请求
    NSString* urlPath = [baseURL stringByAppendingString:url];
    // NSString *urlPath = [baseURL stringByAppendingFormat:@"%@",url];

    // 4.请求的URL
    if ([way isEqualToString:@"POST"]) {
        [manager POST:urlPath
            parameters:parameters
            success:^(AFHTTPRequestOperation* operation, id responseObject) {
                finished(responseObject);
            }
            failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                failure(error);
            }];
    }
    else if ([way isEqualToString:@"GET"]) {
        [manager GET:urlPath
            parameters:parameters
            success:^(AFHTTPRequestOperation* operation, id responseObject) {
                finished(responseObject);

            }
            failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                failure(error);
            }];
    }
}

- (void)NetRequestWithBaseURL:(NSString*)baseURL andAppendURL:(NSString*)url
                   RequestWay:(NSString*)way
                   Parameters:(id)parameters
                     finished:(void (^)(id data))finished
                      failure:(void (^)(NSError* error))failure
{
    [NetWorkTool NetRequestWithBaseURL:baseURL andAppendURL:url RequestWay:way Parameters:parameters finished:finished failure:failure];
}
@end
