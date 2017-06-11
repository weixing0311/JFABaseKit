//
//  JFANetWorkService.h
//  JFABaseKit
//
//  Created by stefan on 15/8/27.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLRequestSerialization.h"
@interface JFANetWorkService : NSObject

+ (instancetype)sharedManager;

-(NSString*)JFADomin;

-(id)getPostResponseSerSerializer;

-(id)getPostRequestSerializer;

-(NSURLSessionTask*)post:(NSString*)url
                     paramters:(NSDictionary*)paramters
                       success:(void (^)(NSURLSessionTask *operation, id responseObject))success
                       failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure;

-(id)getGetResponseSerSerializer;

-(id)getGetRequestSerializer;

-(NSURLSessionTask*)get:(NSString*)url
                    paramters:(NSDictionary*)paramters
                      success:(void (^)(NSURLSessionTask *operation, id responseObject))success
                      failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure;
@end
