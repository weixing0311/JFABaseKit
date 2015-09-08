//
//  JFANavigationController.m
//  AppInstallerGreen
//
//  Created by bobo on 2/27/15.
//
//

#import "JFANavigationController.h"
#import <QuartzCore/QuartzCore.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

static const CGFloat kAnimationDuration = 0.3f;
static const CGFloat kAnimationDelay = 0.0f;
//static const CGFloat kMaxBlackMaskAlpha = 0.8f;

typedef enum {
    PanDirectionNone = 0,
    PanDirectionLeft = 1,
    PanDirectionRight = 2
} PanDirection;

@interface JFANavigationController ()<UIGestureRecognizerDelegate>

//@property (nonatomic, strong) NSMutableArray *gestures;
//@property (nonatomic, strong) UIView *blackMask;
@property (nonatomic, assign) CGPoint panOrigin;
@property (nonatomic, assign) BOOL animationInProgress;
@property (nonatomic, assign) CGFloat percentageOffsetFromLeft;

@end

@implementation JFANavigationController

- (id) initWithRootViewController:(UIViewController*)rootViewController {
    if (self = [super init]) {
        DLog(@"rootvc = %@",rootViewController);
        self.viewControllers = [NSMutableArray arrayWithObject:rootViewController];
    }
    return self;
}

- (void) dealloc {
    [self.viewControllers removeAllObjects];
    self.viewControllers = nil;
}

- (void) loadView {
    [super loadView];
    CGRect viewRect = [self viewBoundsWithOrientation:self.interfaceOrientation];
    viewRect.size.width = [UIScreen mainScreen].bounds.size.height;
    viewRect.size.height = [UIScreen mainScreen].bounds.size.width;
    self.view.frame = viewRect;
    UIViewController *rootViewController = [self.viewControllers objectAtIndex:0];
//    [rootViewController willMoveToParentViewController:self];
    [self addChildViewController:rootViewController];
    
    UIView * rootView = rootViewController.view;
//    if (![AIApplicationUtility isiPadDevice]) {
        rootView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    }
    rootView.frame = viewRect;
    [self.view addSubview:rootView];
    [rootViewController didMoveToParentViewController:self];
//    _blackMask = [[UIView alloc] initWithFrame:viewRect];
//    _blackMask.backgroundColor = [UIColor blackColor];
//    _blackMask.alpha = 0.0;
//    _blackMask.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    [self.view insertSubview:_blackMask atIndex:0];
    
//    if (![AIApplicationUtility isiPadDevice]) {
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    }
}

#pragma mark - Public 

- (void) pushViewController:(UIViewController *)viewController completion:(JFANavigationControllerCompletionBlock)handler {
    _animationInProgress = YES;
    viewController.view.frame = CGRectOffset(self.view.bounds, self.view.bounds.size.width, 0);
    viewController.view.autoresizingMask =  UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    _blackMask.alpha = 0.0;
//    [viewController willMoveToParentViewController:self];
    [self addChildViewController:viewController];
//    [self.view bringSubviewToFront:_blackMask];
    [self.view addSubview:viewController.view];
    
    [UIView animateWithDuration:kAnimationDuration delay:kAnimationDelay options:0 animations:^{
//        CGAffineTransform transf = CGAffineTransformIdentity;
//        [self currentViewController].view.transform = CGAffineTransformScale(transf, 0.9f, 0.9f);
        [self currentViewController].view.frame = CGRectOffset([self currentViewController].view.frame, -self.view.bounds.size.width/4, 0);
        viewController.view.frame = self.view.bounds;
//        _blackMask.alpha = kMaxBlackMaskAlpha;
    }   completion:^(BOOL finished) {
        if (finished) {
            [self.viewControllers addObject:viewController];
            [viewController didMoveToParentViewController:self];
            _animationInProgress = NO;
//            _gestures = [[NSMutableArray alloc] init];
            [self addPanGestureToView:[self currentViewController].view];
            handler();
        }
    }];
}

- (void) pushViewController:(UIViewController *)viewController {
    [self pushViewController:viewController completion:^{}];
}

- (void)presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController completion:^{}];
}

- (void)presentViewController:(UIViewController *)viewController
                   completion:(JFANavigationControllerCompletionBlock)handler {
    [self presentViewController:viewController
                transitionStyle:JFANavigationControllerPresentTransitionStyleCoverVertical
                     completion:handler];
}

- (void)presentViewController:(UIViewController *)viewController
              transitionStyle:(JFANavigationControllerPresentTransitionStyle)transitionStyle
                   completion:(JFANavigationControllerCompletionBlock)handler {
    _animationInProgress = YES;
    
    if (transitionStyle == JFANavigationControllerPresentTransitionStyleCoverVertical) {
        viewController.view.frame = CGRectOffset(self.view.bounds, 0, self.view.bounds.size.height);
    } else if (transitionStyle == JFANavigationControllerPresentTransitionStyleCrossDissolve) {
        viewController.view.frame = self.view.bounds;
        viewController.view.alpha = 0.0;
    }
    
    viewController.view.autoresizingMask =  UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    
    [UIView animateWithDuration:kAnimationDuration delay:kAnimationDelay options:0 animations:^{
        if (transitionStyle == JFANavigationControllerPresentTransitionStyleCoverVertical) {
            viewController.view.frame = self.view.bounds;
        } else if (transitionStyle == JFANavigationControllerPresentTransitionStyleCrossDissolve) {
            viewController.view.alpha = 1.0;
        }
    }   completion:^(BOOL finished) {
        if (finished) {
            [self.viewControllers addObject:viewController];
            [viewController didMoveToParentViewController:self];
            _animationInProgress = NO;
            handler();
        }
    }];
}

- (void)dismissViewController {
    [self dismissViewControllerWithCompletion:^{}];
}

- (void)dismissViewControllerWithCompletion:(JFANavigationControllerCompletionBlock)handler {
    [self dismissViewControllerWithTransitionStyle:JFANavigationControllerPresentTransitionStyleCoverVertical
                                        completion:handler];
}

- (void)dismissViewControllerWithTransitionStyle:(JFANavigationControllerPresentTransitionStyle)transitionStyle
                                      completion:(JFANavigationControllerCompletionBlock)handler {
    if (self.viewControllers.count < 2) {
        return;
    }
    _animationInProgress = YES;
    
    UIViewController *currentVC = [self currentViewController];
    UIViewController *previousVC = [self previousViewController];
    [previousVC viewWillAppear:NO];
    [UIView animateWithDuration:kAnimationDuration delay:kAnimationDelay options:0 animations:^{
        if (transitionStyle == JFANavigationControllerPresentTransitionStyleCoverVertical) {
            currentVC.view.frame = CGRectOffset(self.view.bounds, 0, self.view.bounds.size.height);
        } else if (transitionStyle == JFANavigationControllerPresentTransitionStyleCrossDissolve) {
            currentVC.view.alpha = 0.0;
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [currentVC.view removeFromSuperview];
            [currentVC willMoveToParentViewController:nil];
            [self.view bringSubviewToFront:[self previousViewController].view];
            [currentVC removeFromParentViewController];
            [self.viewControllers removeObject:currentVC];
            _animationInProgress = NO;
            [previousVC viewDidAppear:NO];
            handler();
        }
    }];
}

- (void) popViewControllerWithCompletion:(JFANavigationControllerCompletionBlock)handler {    
    if (self.viewControllers.count < 2) {
        return;
    }
    _animationInProgress = YES;
    
    UIViewController *currentVC = [self currentViewController];
    UIViewController *previousVC = [self previousViewController];
    [previousVC viewWillAppear:NO];
    [UIView animateWithDuration:kAnimationDuration delay:kAnimationDelay options:0 animations:^{
        currentVC.view.frame = CGRectOffset(self.view.bounds, self.view.bounds.size.width, 0);
//        CGAffineTransform transf = CGAffineTransformIdentity;
//        previousVC.view.transform = CGAffineTransformScale(transf, 1.0, 1.0);
        previousVC.view.frame = self.view.bounds;
//        _blackMask.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [currentVC.view removeFromSuperview];
            [currentVC willMoveToParentViewController:nil];
            [self.view bringSubviewToFront:[self previousViewController].view];
            [currentVC removeFromParentViewController];
//            [currentVC didMoveToParentViewController:nil];
            [self.viewControllers removeObject:currentVC];
            _animationInProgress = NO;
            [previousVC viewDidAppear:NO];
            handler();
        }
    }];
    
}

- (void) popViewController {
    [self popViewControllerWithCompletion:^{}];
}

- (void)popToRootViewController {
    [self popToViewController:self.viewControllers.firstObject];
}

- (void)popToViewController:(UIViewController *)viewController {    
    while ([self previousViewController] && [self previousViewController] != viewController) {
        UIViewController *previousVC = [self previousViewController];
        [previousVC.view removeFromSuperview];
        [previousVC willMoveToParentViewController:nil];
        [previousVC removeFromParentViewController];
        [self.viewControllers removeObject:previousVC];
    }
    [self popViewController];
}

#pragma mark - Private 

- (void) rollBackViewController {
    _animationInProgress = YES;
    
    UIViewController * vc = [self currentViewController];
    UIViewController * nvc = [self previousViewController];
    
    [UIView animateWithDuration:0.3 delay:kAnimationDelay options:0 animations:^{
//        CGAffineTransform transf = CGAffineTransformIdentity;
//        nvc.view.transform = CGAffineTransformScale(transf, 0.9f, 0.9f);
        nvc.view.frame = CGRectOffset(self.view.bounds, -self.view.bounds.size.width/4, 0);
        vc.view.frame = self.view.bounds;
//        _blackMask.alpha = kMaxBlackMaskAlpha;
    }   completion:^(BOOL finished) {
        if (finished) {
            _animationInProgress = NO;
        }
    }];
}


- (UIViewController *)currentViewController {
    UIViewController *result = nil;
    if ([self.viewControllers count]>0) {
        result = [self.viewControllers lastObject];
    }
    return result;
}

- (UIViewController *)previousViewController {
    UIViewController *result = nil;
    if ([self.viewControllers count]>1) {
        result = [self.viewControllers objectAtIndex:self.viewControllers.count - 2];
    }
    return result;
}

- (void) addPanGestureToView:(UIView*)view
{
//    NSLog(@"ADD PAN GESTURE $$### %i",[_gestures count]);
//    if (![AIApplicationUtility isiPadDevice]) {
        UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(gestureRecognizerDidPan:)];
        panGesture.cancelsTouchesInView = YES;
        panGesture.delegate = self;
        [view addGestureRecognizer:panGesture];
//    }

//    [_gestures addObject:panGesture];
}

- (void) transformAtPercentage:(CGFloat)percentage {
//    CGAffineTransform transf = CGAffineTransformIdentity;
//    CGFloat newTransformValue =  1 - (percentage*10)/100;
//    [self previousViewController].view.transform = CGAffineTransformScale(transf,newTransformValue,newTransformValue);
//    CGFloat newAlphaValue = percentage* kMaxBlackMaskAlpha;
//    _blackMask.alpha = newAlphaValue;
    [self previousViewController].view.frame = CGRectOffset(self.view.bounds, -self.view.bounds.size.width/4 * percentage, 0);
}

- (void) completeSlidingAnimationWithDirection:(PanDirection)direction {
    if(direction==PanDirectionRight){
        [self popViewController];
    }else {
        [self rollBackViewController];
    }
}

- (void) completeSlidingAnimationWithOffset:(CGFloat)offset{
    
    if(offset<[self viewBoundsWithOrientation:self.interfaceOrientation].size.width/2) {
        [self popViewController];
    }else {
        [self rollBackViewController];
    }
}

- (CGRect) getSlidingRectWithPercentageOffset:(CGFloat)percentage orientation:(UIInterfaceOrientation)orientation {
    CGRect viewRect = [self viewBoundsWithOrientation:orientation];
    CGRect rectToReturn = CGRectZero;
    UIViewController * vc;
    vc = [self currentViewController];
    rectToReturn.size = viewRect.size;
    rectToReturn.origin = CGPointMake(MAX(0,(1-percentage)*viewRect.size.width), 0.0);
    return rectToReturn;
}

- (CGRect) viewBoundsWithOrientation:(UIInterfaceOrientation)orientation{
    CGRect bounds = [UIScreen mainScreen].bounds;
    if([[UIApplication sharedApplication]isStatusBarHidden]){
        return bounds;
    } else if(UIInterfaceOrientationIsLandscape(orientation)){
        CGFloat width = bounds.size.width;
        bounds.size.width = bounds.size.height;
        if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))  {
            bounds.size.height = width - 20;
        }else {
            bounds.size.height = width;
        }
        return bounds;
    }else{
        if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))  {
            bounds.size.height-=20;
        }
        return bounds;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint translation = [panGestureRecognizer translationInView:self.view];
    return fabs(translation.x) > fabs(translation.y) ;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    UIViewController * vc =  [self.viewControllers lastObject];
    _panOrigin = vc.view.frame.origin;
    gestureRecognizer.enabled = YES;
    return !_animationInProgress;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

#pragma mark - Selector

- (void) gestureRecognizerDidPan:(UIPanGestureRecognizer*)panGesture {
    if(_animationInProgress) return;
    
    CGPoint currentPoint = [panGesture translationInView:self.view];
    CGFloat x = currentPoint.x + _panOrigin.x;
    
    PanDirection panDirection = PanDirectionNone;
    CGPoint vel = [panGesture velocityInView:self.view];
    
    if (vel.x > 0) {
        panDirection = PanDirectionRight;
    } else {
        panDirection = PanDirectionLeft;
    }
    
    CGFloat offset = 0;
    
    UIViewController * vc ;
    vc = [self currentViewController];
    offset = CGRectGetWidth(vc.view.frame) - x;
    
    _percentageOffsetFromLeft = offset/[self viewBoundsWithOrientation:self.interfaceOrientation].size.width;
    vc.view.frame = [self getSlidingRectWithPercentageOffset:_percentageOffsetFromLeft orientation:self.interfaceOrientation];
    [self transformAtPercentage:_percentageOffsetFromLeft];
    
    if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled) {
        // If velocity is greater than 100 the Execute the Completion base on pan direction
        if(fabs(vel.x) > 100) {
            [self completeSlidingAnimationWithDirection:panDirection];
        }else {
            [self completeSlidingAnimationWithOffset:offset];
        }
    }
}

@end

