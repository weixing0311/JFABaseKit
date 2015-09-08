//
//  JFANavigationController.h
//  AppInstallerGreen
//
//  Created by bobo on 2/27/15.
//
//

#import <UIKit/UIKit.h>

typedef void (^JFANavigationControllerCompletionBlock)(void);

typedef enum {
    JFANavigationControllerPresentTransitionStyleCoverVertical = 0,
    JFANavigationControllerPresentTransitionStyleCrossDissolve
} JFANavigationControllerPresentTransitionStyle;

@interface JFANavigationController : UIViewController

@property(nonatomic, strong) NSMutableArray *viewControllers;

- (id)initWithRootViewController:(UIViewController*)rootViewController;

- (void)pushViewController:(UIViewController *)viewController;
- (void)pushViewController:(UIViewController *)viewController
                 completion:(JFANavigationControllerCompletionBlock)handler;
- (void)popViewController;
- (void)popViewControllerWithCompletion:(JFANavigationControllerCompletionBlock)handler;
- (void)popToRootViewController;
- (void)popToViewController:(UIViewController *)viewController;

- (void)presentViewController:(UIViewController *)viewController;
- (void)presentViewController:(UIViewController *)viewController
                   completion:(JFANavigationControllerCompletionBlock)handler;
- (void)presentViewController:(UIViewController *)viewController
              transitionStyle:(JFANavigationControllerPresentTransitionStyle)transitionStyle
                   completion:(JFANavigationControllerCompletionBlock)handler;
- (void)dismissViewController;
- (void)dismissViewControllerWithCompletion:(JFANavigationControllerCompletionBlock)handler;
- (void)dismissViewControllerWithTransitionStyle:(JFANavigationControllerPresentTransitionStyle)transitionStyle
                                      completion:(JFANavigationControllerCompletionBlock)handler;


@end
