//
//  JFADownLoadApp.m
//  Pods
//
//  Created by 魏星 on 15/9/28.
//
//

#import "JFADownLoadApp.h"
#import <StoreKit/StoreKit.h>
@implementation JFADownLoadApp
+ (instancetype)sharedManager {
    static JFADownLoadApp *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}
-(void)DownLoadAppWithID:(NSString *)uid
{
   [JFABaseService jumpAppStreWithAppId:uid];
}
@end
