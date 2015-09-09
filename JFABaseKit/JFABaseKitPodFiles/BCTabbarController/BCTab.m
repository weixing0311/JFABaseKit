#import "BCTab.h"

@interface BCTab ()

@property (nonatomic, retain) UIImage *rightBorder;
@property (nonatomic, retain) UIImage *background;

@end

@implementation BCTab

@synthesize rightBorder, background, badge;
@synthesize shouldHideBadge = _shouldHideBadge;

- (id)initWithIconImageName:(NSString *)imageName {
	if (self = [super init]) {
		self.adjustsImageWhenHighlighted = NO;
		self.backgroundColor = [UIColor clearColor];
		
		NSString *selectedName = [NSString stringWithFormat:@"%@_selected@3x.%@",
								   [[imageName stringByReplacingOccurrencesOfString:@"@3x" withString:@""] stringByDeletingPathExtension],
								   [imageName pathExtension]];
        
        [self setImage:[[UIImage storeImageNamed:imageName] scaledImageFrom3x] forState:UIControlStateNormal];
        
		[self setImage:[[UIImage storeImageNamed:selectedName] scaledImageFrom3x] forState:UIControlStateSelected];
        
#if USE_CUSTOM_BUTTON_BACKGROUND
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar_item_background.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar_item_background_selected.png"] forState:UIControlStateSelected];
#endif
        
        if ((![[NSUserDefaults standardUserDefaults] boolForKey:@"showSettingRedbadge"]) && [imageName rangeOfString:@"set"].location!=NSNotFound) {
        }
        self.shouldHideBadge = FALSE;
	}
	return self;
}

- (void)setBadge:(NSInteger)aBadge
{
    if (badge == aBadge) {
        return;
    }
    badge = aBadge;
//    if (aBadge > 0) {
//        [badgeImageView setBadge:[NSString stringWithFormat:@"%ld", (long)aBadge]];
//    }
//    else {
//        [badgeImageView setBadge:@""];
//    }
    [self setNeedsLayout];
}

- (void)setHighlighted:(BOOL)aBool {
	// no highlight state
}

- (void)drawRect:(CGRect)rect {
	if (self.selected) {
//#if !USE_CUSTOM_BUTTON_BACKGROUND
//		[background drawAtPoint:CGPointMake(0, 2)];
//		[rightBorder drawAtPoint:CGPointMake(self.bounds.size.width - rightBorder.size.width, 2)];
//		CGContextRef c = UIGraphicsGetCurrentContext();
//		[RGBCOLOR(24, 24, 24) set]; 
//		CGContextFillRect(c, CGRectMake(0, self.bounds.size.height / 2, self.bounds.size.width, self.bounds.size.height / 2));
//		[RGBCOLOR(14, 14, 14) set];		
//		CGContextFillRect(c, CGRectMake(0, self.bounds.size.height / 2, 0.5, self.bounds.size.height / 2));
//		CGContextFillRect(c, CGRectMake(self.bounds.size.width - 0.5, self.bounds.size.height / 2, 0.5, self.bounds.size.height / 2));
//#endif
	}
}

- (void)setFrame:(CGRect)aFrame {
	[super setFrame:aFrame];
	[self setNeedsDisplay];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	UIEdgeInsets imageInsets = UIEdgeInsetsMake(floor((self.bounds.size.height / 2) -
												(self.imageView.image.size.height / 2)),
												floor((self.bounds.size.width / 2) -
												(self.imageView.image.size.width / 2)),
												floor((self.bounds.size.height / 2) -
												(self.imageView.image.size.height / 2)),
												floor((self.bounds.size.width / 2) -
												(self.imageView.image.size.width / 2)));
	self.imageEdgeInsets = imageInsets;
}

@end
