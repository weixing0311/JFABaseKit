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


-(AFHTTPRequestOperation*)post:(NSString*)url
                     paramters:(NSDictionary*)paramters
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager* manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[self getPostResponseSerSerializer];
    manager.requestSerializer=[self getPostRequestSerializer];
    AFHTTPRequestOperation* operation = [manager POST:[NSString stringWithFormat:@"%@%@",[self JFADomin],url] parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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

-(AFHTTPRequestOperation*)get:(NSString*)url
                    paramters:(NSDictionary*)paramters
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager* manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[self getGetResponseSerSerializer];
    manager.requestSerializer=[self getGetRequestSerializer];
//    AFHTTPRequestOperation* operation = [manager POST:[NSString stringWithFormat:@"%@%@",[self JFADomin],url] parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        success(operation,responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        failure(operation,error);
//    }];
    
    
    AFHTTPRequestOperation* operation = [manager GET:[NSString stringWithFormat:@"%@%@",[self JFADomin],url] parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    
    return operation;
}
@end
