#import "BCTabBarController.h"
#import "BCTabBar.h"
#import "BCTab.h"
#import "UIViewController+iconImage.h"
#import "BCTabBarView.h"

@interface BCTabBarController () <BCTabBarDelegate>

- (void)loadTabs;

@property (nonatomic, retain) UIImageView *selectedTab;
@property (nonatomic, readwrite) BOOL visible;

@end


@implementation BCTabBarController
@synthesize viewControllers, tabBar, selectedTab, selectedViewController, tabBarView, visible;

- (void)setTabBarView:(BCTabBarView *)_tabBarView
{
    tabBarView = _tabBarView;
}

- (void)loadView {
	self.tabBarView = [[BCTabBarView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.view = self.tabBarView;

	CGFloat tabBarHeight = 49;
    
#if SHOW_TABBAR_ARROW
    CGFloat tabBarHeight = 49 + 6; // tabbar + arrow
#endif
    
	CGFloat adjust = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 0 : 0;
	self.tabBar = [[BCTabBar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - tabBarHeight, self.view.bounds.size.width, tabBarHeight + adjust)];
    [self.tabBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
	self.tabBar.delegate = self;
    self.tabBar.backgroundColor=[UIColor clearColor];
	
	self.tabBarView.tabBar = self.tabBar;
	[self loadTabs];
	
	UIViewController *tmp = selectedViewController;
	selectedViewController = nil;
	[self setSelectedViewController:tmp];
}

//-(void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    CGFloat tabBarHeight = 49;
//    
//#if SHOW_TABBAR_ARROW
//    CGFloat tabBarHeight = 49 + 6; // tabbar + arrow
//#endif
//    CGFloat height=[[UIScreen mainScreen] applicationFrame].size.height;
//    DLog(@"%f",height);
//    if (![UIApplication sharedApplication].statusBarHidden) {
//        height+=[UIApplication sharedApplication].statusBarFrame.size.height;
//    }
//    
//    self.tabBar.frame=CGRectMake(0, height- tabBarHeight, [[UIScreen mainScreen] applicationFrame].size.width, tabBarHeight);
//    [self.tabBar layoutSubviews];
//}

- (void)tabBar:(BCTabBar *)aTabBar didSelectTabAtIndex:(NSInteger)index {
	UIViewController *vc = [self.viewControllers objectAtIndex:index];
	if (self.selectedViewController == vc) {
		if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
			[(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
		}
	} else {
		self.selectedViewController = vc;
	}
	
}

- (void)setSelectedViewController:(UIViewController *)vc {
	UIViewController *oldVC = selectedViewController;
	if (selectedViewController != vc) {
		selectedViewController = vc;
        if (!self.childViewControllers && visible) {
            [oldVC viewWillDisappear:NO];
			[selectedViewController viewWillAppear:NO];
		}
        
        [oldVC.view removeFromSuperview];
        if ([self.tabBarView.subviews indexOfObject:vc.view]==NSNotFound) {
            [self.tabBarView insertSubview:vc.view belowSubview:self.tabBar];
        }
        [self.tabBarView setContentViewFrame:vc.view];

        if (!self.childViewControllers && visible) {
			[oldVC viewDidDisappear:NO];
			[selectedViewController viewDidAppear:NO];
		}
		
		[self.tabBar setSelectedTab:[self.tabBar.tabs objectAtIndex:self.selectedIndex] animated:(oldVC != nil)];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    if (!self.childViewControllers)
        [self.selectedViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
    if (!self.childViewControllers)
        [self.selectedViewController viewDidAppear:animated];
    
	visible = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
    if (!self.childViewControllers)
        [self.selectedViewController viewWillDisappear:animated];	
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    
    if (![self respondsToSelector:@selector(addChildViewController:)])
        [self.selectedViewController viewDidDisappear:animated];
	visible = NO;
}

- (NSUInteger)selectedIndex {
	return [self.viewControllers indexOfObject:self.selectedViewController];
}

- (void)setSelectedIndex:(NSUInteger)aSelectedIndex {
	if (self.viewControllers.count > aSelectedIndex)
		self.selectedViewController = [self.viewControllers objectAtIndex:aSelectedIndex];
}

- (void)loadTabs {
	NSMutableArray *tabs = [NSMutableArray arrayWithCapacity:self.viewControllers.count];
	for (UIViewController *vc in self.viewControllers) {
		[tabs addObject:[[BCTab alloc] initWithIconImageName:[vc iconImageName]]];
	}
	self.tabBar.tabs = tabs;
	[self.tabBar setSelectedTab:[self.tabBar.tabs objectAtIndex:self.selectedIndex] animated:NO];
}

- (void)viewDidUnload {
	self.tabBar = nil;
	self.selectedTab = nil;
}

- (void)setViewControllers:(NSArray *)array {
	if (array != viewControllers) {
		viewControllers = array;
		
		if (viewControllers != nil) {
			[self loadTabs];
		}
	}
    
	self.selectedIndex = 0;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return [self.selectedViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
}

- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self.selectedViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    [self.tabBarView setTabBarHidden:hidden animated:animated];
}

@end
