
@class BCTabBar;
@class BCTabBarView;

@interface BCTabBarController : UIViewController

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) BCTabBar *tabBar;
@property (nonatomic, retain) UIViewController *selectedViewController;
@property (nonatomic, retain) BCTabBarView *tabBarView;
@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic, readonly) BOOL visible;

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

- (void)tabBar:(BCTabBar *)aTabBar didSelectTabAtIndex:(NSInteger)index;

@end
