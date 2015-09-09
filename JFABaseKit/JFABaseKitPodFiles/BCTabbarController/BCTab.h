

@interface BCTab : UIButton {
	UIImage *background;
	UIImage *rightBorder;
}

@property (nonatomic,assign) NSInteger badge;
@property (nonatomic) BOOL shouldHideBadge;

- (id)initWithIconImageName:(NSString *)imageName;

@end
