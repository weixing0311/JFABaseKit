//
//  JFANetWorkService.m
//  JFABaseKit
//
//  Created by stefan on 15/8/27.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import "JFANetWorkService.h"

@implementation JFANetWorkService

+ (instancetype)sharedManager {
    static JFANetWorkService *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

-(NSString*)JFADomin
{
    return @"http://www.iiapple.com/";
}

-(id)getPostResponseSerSerializer
{
    return [AFHTTPResponseSerializer serializer];
}

-(id)getPostRequestSerializer
{
    return [AFHTTPRequestSerializer serializer];
}


-(NSURLSessionTask*)post:(NSString*)url
                     paramters:(NSDictionary*)paramters
                       success:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))success
                       failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure
{
    AFHTTPSessionManager* manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[self getPostResponseSerSerializer];
    manager.requestSerializer=[self getPostRequestSerializer];
    
    
    NSURLSessionTask * operation = [manager POST:[NSString stringWithFormat:@"%@%@",[self JFADomin],url] parameters:paramters constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(operation,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(operation,error);
    }];
    
    
    
    
    return operation;
}

-(id)getGetResponseSerSerializer
{
    return [AFHTTPResponseSerializer serializer];
}

-(id)getGetRequestSerializer
{
    return [AFHTTPRequestSerializer serializer];
}

-(NSURLSessionTask*)get:(NSString*)url
                    paramters:(NSDictionary*)paramters
                      success:(void (^)(NSURLSessionTask *operation, id responseObject))success
                      failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure
{
    AFHTTPSessionManager* manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[self getGetResponseSerSerializer];
    manager.requestSerializer=[self getGetRequestSerializer];
//    NSURLSessionTask* operation = [manager POST:[NSString stringWithFormat:@"%@%@",[self JFADomin],url] parameters:paramters success:^(NSURLSessionTask *operation, id responseObject) {
//        success(operation,responseObject);
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        failure(operation,error);
//    }];
    
    
    NSURLSessionTask* operation = [manager GET:[NSString stringWithFormat:@"%@%@",[self JFADomin],url] parameters:paramters success:^(NSURLSessionTask *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        failure(operation,error);
    }];
    
    return operation;
}
@end
