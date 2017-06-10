//
//  CViewController.m
//  HotelManager
//
//  Created by Tulipa on 14-5-6.
//  Copyright (c) 2014年 Tulipa. All rights reserved.
//

#import "XViewController.h"

@interface _YDNavigationBarLabel : UILabel

@end

@implementation _YDNavigationBarLabel

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	if ([self superview])
	{
		[self setCenterY:self.superview.height / 2.0f];
	}
}

@end

@interface _YDNavigationBarItem : UINavigationItem

@end

@implementation _YDNavigationBarItem

@end

@interface XViewController ()
{
	_YDNavigationBarItem *navigationBarItem;
    _YDNavigationBarItem *xNavigationBarItem;
}
@end

@implementation XViewController

- (UINavigationItem *)navigationItem
{
	if (! navigationBarItem)
	{
		navigationBarItem = [[_YDNavigationBarItem alloc] init];
		if (self.title.length)
		{
			[navigationBarItem setTitle:self.title];
		}
	}
	return navigationBarItem;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if ([self autoGenerateBackBarButtonItem])
    {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [backButton sizeToFit];
        if ([self hasYDNavigationBar])
        {
            self.xNavigationBarButtonItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        }
        else
        {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        }
    }
    
	if ([self hasYDNavigationBar])
	{
		self.ydNavigationBar = [[XNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, [self ydNavigationBarHeight])];
		[self.view addSubview:self.ydNavigationBar];
		[self.ydNavigationBar pushNavigationItem:self.xNavigationBarButtonItem animated:NO];
	}
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.ydNavigationBar setFrame:CGRectMake(0, 0, self.view.width, [self ydNavigationBarHeight])];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.view bringSubviewToFront:self.ydNavigationBar];
}

- (CGFloat)ydNavigationBarHeight
{
    return YDAvalibleOS(7) ? 64 : 44;
}

- (BOOL)hasYDNavigationBar
{
	return NO;
}

- (UINavigationItem *)xNavigationBarButtonItem
{
    if (! xNavigationBarItem)
    {
        xNavigationBarItem = [[_YDNavigationBarItem alloc] init];
        if (self.title.length)
        {
            [xNavigationBarItem setTitle:self.title];
        }
    }
    return xNavigationBarItem;
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



- (void)showHint:(NSString *)hint hide:(CGFloat)delay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setDetailsLabelFont:XFont(14)];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud setMode:MBProgressHUDModeText];
    [hud setDetailsLabelText:hint];
    [hud hide:YES afterDelay:delay];
}

- (void)showLoading:(BOOL)animated
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:animated];
    
    [hud setRemoveFromSuperViewOnHide:YES];
    
    [hud setMode:MBProgressHUDModeIndeterminate];
    
}

- (void)hideLoading:(BOOL)animated
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


@end
