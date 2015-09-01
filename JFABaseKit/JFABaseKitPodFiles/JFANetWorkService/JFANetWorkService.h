//
//  JFANetWorkService.h
//  JFABaseKit
//
//  Created by stefan on 15/8/27.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFANetWorkService : NSObject

+ (instancetype)sharedManager;

-(NSString*)JFADomin;

-(id)getPostResponseSerSerializer;

-(id)getPostRequestSerializer;

-(AFHTTPRequestOperation*)post:(NSString*)url
                     paramters:(NSDictionary*)paramters
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(id)getGetResponseSerSerializer;

-(id)getGetRequestSerializer;

-(AFHTTPRequestOperation*)get:(NSString*)url
                    paramters:(NSDictionary*)paramters
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
