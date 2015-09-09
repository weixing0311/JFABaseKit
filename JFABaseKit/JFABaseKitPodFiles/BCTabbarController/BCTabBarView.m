#import "BCTabBarView.h"
#import "BCTabBar.h"
#import "BCTab.h"

@implementation BCTabBarView
@synthesize tabBar, contentView;

- (void)setTabBar:(BCTabBar *)aTabBar {
    if (tabBar != aTabBar) {
        [tabBar removeFromSuperview];
        tabBar = aTabBar;
        [self addSubview:tabBar];
    }
}

- (void)setContentViewFrame:(UIView *)view {

    DLog(@"%@",NSStringFromCGRect(view.frame));
    
    self.contentView=view;
    
	contentView.frame = CGRectMake(0, 0, self.bounds.size.width, self.tabBar.frame.origin.y);

}

- (void)layoutSubviews {
	[super layoutSubviews];
    
	CGRect f = contentView.frame;
	f.size.height = self.tabBar.frame.origin.y;
	contentView.frame = f;
	[contentView layoutSubviews];
}

//- (void)drawRect:(CGRect)rect {
//	CGContextRef c = UIGraphicsGetCurrentContext();
//	[RGBCOLOR(230, 230, 230) set];
//	CGContextFillRect(c, self.bounds);
//}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    CGFloat tabbarHeight = self.tabBar.frame.size.height;
    CGRect tabbarFrame = self.tabBar.frame;
    CGRect contentFrame = self.contentView.frame;
    
    BOOL changed = NO;
    if (tabbarFrame.origin.y >= self.frame.size.height) {
        if (!hidden) {
            tabbarFrame.origin.y -= tabbarHeight;
            contentFrame.size.height -= tabbarHeight;
            changed = YES;
        }
    } else {
        if (hidden) {
            tabbarFrame.origin.y += tabbarHeight;
            contentFrame.size.height += tabbarHeight;
            changed = YES;
        }
    }
    
    if (changed) {
        if (animated) {
            [UIView animateWithDuration:0.5 animations:^{
                self.tabBar.frame = tabbarFrame;
                self.contentView.frame = contentFrame;
            }];
        } else {
            self.tabBar.frame = tabbarFrame;
            self.contentView.frame = contentFrame;
        }
        
        for (BCTab *tab in self.tabBar.tabs) {
            if (tab.badge > 0) {
                tab.shouldHideBadge = hidden;
            }
        }
    }
}

@end
