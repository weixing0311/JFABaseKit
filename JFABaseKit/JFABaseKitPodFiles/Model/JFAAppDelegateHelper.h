//
//  JFAAppDelegateHelper.h
//  Pods
//
//  Created by bobo on 3/25/15.
//
//

#import <Foundation/Foundation.h>
#import "JFANavigationController.h"
#import "AITabBarController.h"

@interface JFAAppDelegateHelper : NSObject

+ (instancetype)sharedHelper;
- (void)openAppWithIdentifier:(NSString *)appId;
- (void)openWebWith:(NSString *)url;
- (JFANavigationController *)rootViewController;
- (AITabBarController *)tabBarController;

@end
