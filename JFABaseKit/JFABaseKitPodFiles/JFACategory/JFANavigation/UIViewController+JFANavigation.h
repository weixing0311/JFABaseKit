//
//  UIViewController+JFANavigation.h
//  Pods
//
//  Created by 魏星 on 15/9/8.
//
//

#import <UIKit/UIKit.h>
@class JFANavigationBar;
@class JFANavigationController;
@interface UIViewController (JFANavigation)
@property (nonatomic, strong) JFANavigationController *jfa_navigationController;
@end
