#import "BCTabBar.h"
#import "BCTab.h"

#if USE_CUSTOM_BUTTON_BACKGROUND
#define kTabMargin 0.0
#else
#define kTabMargin 2.0
#endif

@interface BCTabBar ()
@property (nonatomic, retain) UIImage *backgroundImage;

- (void)positionArrowAnimated:(BOOL)animated;
@end

@implementation BCTabBar
@synthesize tabs, selectedTab, backgroundImage, delegate;

#if SHOW_TABBAR_ARROW
@synthesize arrow;
#endif

- (id)initWithFrame:(CGRect)aFrame {

	if (self = [super initWithFrame:aFrame])
    {
        self.backgroundImage = [[UIImage imageNamed:@"tabbarbackground-green.png"] stretchableImageWithLeftCapWidth:160 topCapHeight:20];
        
#if SHOW_TABBAR_ARROW
        self.arrow = [[UIImageView alloc] initWithImage:[UIImage storeImageNamed:@"tab-arrow.png"]];
		CGRect r = self.arrow.frame;
		r.origin.y = - (r.size.height - 2);
		self.arrow.frame = r;
		[self addSubview:self.arrow];
#endif
        UIImageView* bg = [[UIImageView alloc] initWithFrame:aFrame];
        bg.image = self.backgroundImage;
        bg.autoresizingMask = bg.autoresizingMask | UIViewAutoresizingFlexibleWidth;
        [self addSubview:bg];
		self.userInteractionEnabled = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | 
		                        UIViewAutoresizingFlexibleTopMargin;
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	[self.backgroundImage drawAsPatternInRect:CGRectMake(0, 0, JFA_SCREEN_WIDTH, self.frame.size.height)];
}

- (void)setTabs:(NSArray *)array {
    if (tabs != array) {
        for (BCTab *tab in tabs) {
            [tab removeFromSuperview];
        }

        tabs = array;        
        
        for (BCTab *tab in tabs) {
            tab.userInteractionEnabled = YES;
            [tab addTarget:self action:@selector(tabSelected:) forControlEvents:UIControlEventTouchDown];
        }
        [self setNeedsLayout];

    }
}

- (void)setSelectedTab:(BCTab *)aTab animated:(BOOL)animated {
	if (aTab != selectedTab) {
		selectedTab = aTab;
		selectedTab.selected = YES;
		
		for (BCTab *tab in tabs) {
			if (tab == aTab) continue;
			
			tab.selected = NO;
		}
	}
	
	[self positionArrowAnimated:animated];	
}

- (void)setSelectedTab:(BCTab *)aTab {
	[self setSelectedTab:aTab animated:YES];
}

- (void)tabSelected:(BCTab *)sender {
	[self.delegate tabBar:self didSelectTabAtIndex:[self.tabs indexOfObject:sender]];
}

- (void)positionArrowAnimated:(BOOL)animated {
    
#if SHOW_TABBAR_ARROW
    
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
	}
    
	CGRect f = self.arrow.frame;
	f.origin.x = self.selectedTab.frame.origin.x + ((self.selectedTab.frame.size.width / 2) - (f.size.width / 2));
	self.arrow.frame = f;
	
	if (animated) {
		[UIView commitAnimations];
	}
    
#endif
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect f = self.bounds;
	f.size.width /= self.tabs.count;
	f.size.width -= (kTabMargin * (self.tabs.count + 1)) / self.tabs.count;
	for (BCTab *tab in self.tabs) {
		f.origin.x += kTabMargin;
		tab.frame = CGRectMake(floorf(f.origin.x), f.origin.y, floorf(f.size.width), f.size.height);
		f.origin.x += f.size.width;
        DLog(@"%@",NSStringFromCGRect(tab.frame));
		[self addSubview:tab];
	}
	
	[self positionArrowAnimated:NO];
}

- (void)setFrame:(CGRect)aFrame {
    
	[super setFrame:aFrame];
	[self setNeedsDisplay];
}


@end
