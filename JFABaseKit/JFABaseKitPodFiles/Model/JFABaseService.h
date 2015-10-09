//
//  JFABaseService.h
//  Pods
//
//  Created by 魏星 on 15/9/24.
//
//

#import <Foundation/Foundation.h>

@interface JFABaseService : NSObject
+ (NSString *)udidString;
+ (NSString *)udidString2;
+ (BOOL)isAppStoreLock;   //判断是否是上线时用
@end
