//
//  UIViewController+JFANavigation.m
//  Pods
//
//  Created by 魏星 on 15/9/8.
//
//

#import "UIViewController+JFANavigation.h"
#import "JFANavigationController.h"
#import "JFANavigationBar.h"
@implementation UIViewController (JFANavigation)
@dynamic jfa_navigationController;
//@dynamic JFANavigationBar;

- (JFANavigationController *)jfa_navigationController {
    
    if([self.parentViewController isKindOfClass:[JFANavigationController class]]){
        return (JFANavigationController*)self.parentViewController;
    }
    else if([self.parentViewController isKindOfClass:[UINavigationController class]] &&
            [self.parentViewController.parentViewController isKindOfClass:[JFANavigationController class]]){
        return (JFANavigationController*)[self.parentViewController parentViewController];
    }
    else if ([[[UIApplication sharedApplication].delegate window].rootViewController isKindOfClass:[JFANavigationController class]]) {
        return (JFANavigationController *)[[UIApplication sharedApplication].delegate window].rootViewController;
    }
    else{
        return nil;
    }
    
}
@end
