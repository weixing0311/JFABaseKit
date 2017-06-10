//
//  YDNavigationController.m
//  common
//
//  Created by Tulipa on 14-7-11.
//  Copyright (c) 2014年  com.7ulipa. All rights reserved.
//

#import "XNavigationController.h"
#import "XNavigationBar.h"
#import "XNavigationBarButton.h"

@interface XNavigationController () <UINavigationControllerDelegate>
{
    XNavigationBarStyle currentNavigationBarStyle;
}
@end

@implementation XNavigationController

- (instancetype)init
{
	if (self = [super init])
	{
		[self setDelegate:self];
        currentNavigationBarStyle = XNavigationBarStyleGreen;
	}
	return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	[super pushViewController:viewController animated:animated];
	
	[self setNavigationBarHidden:[viewController hideNavigationBar]];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
	NSInteger count = self.viewControllers.count;
	
	UIViewController* vc = nil;
	
	if (count > 1)
	{
		vc = [self.viewControllers objectAtIndex:count - 2];
	}
	
	UIViewController* result = [super popViewControllerAnimated:animated];
	
	if (vc)
	{
		[self setNavigationBarHidden:[vc hideNavigationBar]];
	}
	
	return result;
}

- (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^)(void))completion
{
	if (YDAvalibleOS(8) && ! flag)
	{
		__block BOOL wait = YES;
		[super dismissViewControllerAnimated:flag completion:^{
			if (completion)
			{
				completion();
			}
			wait = NO;
		}];
		while (wait)
		{
			[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
		}
	}
	else
	{
		[super dismissViewControllerAnimated:flag completion:completion];
	}
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
	[super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated
{
	[super presentModalViewController:modalViewController animated:animated];
}

#pragma mark - navigation controller delegates

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	[self.view.gestureRecognizers enumerateObjectsUsingBlock:^(UIGestureRecognizer *rec, NSUInteger idx, BOOL *stop) {
        [rec setEnabled:[viewController enableDragBack]];
    }];
}

@end
