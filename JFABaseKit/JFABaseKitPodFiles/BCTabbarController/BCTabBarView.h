@class BCTabBar;

@interface BCTabBarView : UIView

@property (nonatomic, assign) UIView * contentView;
@property (nonatomic, assign) BCTabBar *tabBar;

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

- (void)setContentViewFrame:(UIView *)view;

@end
