//
//  JFAAppDelegateHelper.m
//  Pods
//
//  Created by bobo on 3/25/15.
//
//

#import "JFAAppDelegateHelper.h"
#import <StoreKit/StoreKit.h>
//#import "AIWebViewController.h"

@interface JFAAppDelegateHelper () <SKStoreProductViewControllerDelegate>

@end

@implementation JFAAppDelegateHelper

+ (instancetype)sharedHelper {
    static JFAAppDelegateHelper *sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHelper = [[JFAAppDelegateHelper alloc] init];
    });
    return sharedHelper;
}

- (JFANavigationController *)rootViewController {
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    if (window && [window.rootViewController isKindOfClass:[JFANavigationController class]]) {
        JFANavigationController *jfa_navigationController = (JFANavigationController *)window.rootViewController;
        return jfa_navigationController;
    } else {
        DLog(@"open web view fail : root view controller is not JFANavigationController");
    }
    return nil;
}

- (void)openAppWithIdentifier:(NSString *)appId {
    SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
    storeProductVC.delegate = self;
    JFANavigationController *rootViewController = [self rootViewController];
    if (rootViewController) {
        [rootViewController presentViewController:storeProductVC];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:appId forKey:SKStoreProductParameterITunesItemIdentifier];
        [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
            if (result) {
                
            }
        }];
    }
}

//- (void)openWebWith:(NSString *)url {
//    AIWebViewController* webVC = [[AIWebViewController alloc] initWithTitle:@"网页详情"];
//    webVC.showMenu = YES;
//    webVC.url = [NSURL URLWithString:url];
//    JFANavigationController *rootViewController = [self rootViewController];
//    if (rootViewController) {
//        [rootViewController presentViewController:webVC];
//    }
//}

- (AITabBarController *)tabBarController {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(tabController)]) {
        return [[UIApplication sharedApplication].delegate performSelector:@selector(tabController)];
    }
    else {
        DLog(@"app delegate don't contain tabBarController property");
    }
    return nil;
    
#pragma clang diagnostic pop
}

#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
