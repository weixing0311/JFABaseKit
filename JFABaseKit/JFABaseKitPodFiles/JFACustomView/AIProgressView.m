//
//  AIProgressView.m
//  Pods
//
//  Created by chengdengwei on 15/6/24.
//
//

#import "AIProgressView.h"


@interface AIProgressView ()


@end

@implementation AIProgressView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

-(void)createSubviews
{
    BOOL isMainHeight = NO;
    if (self.bounds.size.height == AI_SCREEN_HEIGHT) {
        isMainHeight = YES;
    }
    if (self.loadingView) {
        [self.loadingView removeFromSuperview];
    }
    self.loadingView = [[UIView alloc] initWithFrame:self.bounds];
    self.loadingView.backgroundColor = [UIColor colorForHex:APP_COLOR_9];
    
    self.loadingIconView = [[UIImageView alloc] initWithImage:[[UIImage storeImageNamed:@"loading_view_icon_new@3x.png"] scaledImageFrom3x]];
    self.loadingIconView.center = CGPointMake(self.bounds.size.width/2.0,isMainHeight ? (228+self.loadingIconView.image.size.height/2.0) : (114+self.loadingIconView.image.size.height/2.0));
    
    self.loadingProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    CGRect frame = self.loadingIconView.frame;
    frame.size = CGSizeMake(self.loadingIconView.image.size.width + 30, 20);
    self.loadingProgressView.frame = frame;
    self.loadingProgressView.center = CGPointMake(self.bounds.size.width/2.0, isMainHeight ? (228+self.loadingIconView.image.size.height + 24) : (114+self.loadingIconView.image.size.height + 18));
    self.loadingProgressView.progressTintColor = [UIColor colorForHex:@"E6EAF2"];
    self.loadingProgressView.trackImage = [[UIImage storeImageNamed:@"loading_progress_view_new@3x.png"] scaledImageFrom3x];
    self.loadingProgressView.trackTintColor = [UIColor colorForHex:APP_COLOR_9];
    
    [self.loadingView addSubview:self.loadingIconView];
    [self.loadingView addSubview:self.loadingProgressView];
    [self addSubview:self.loadingView];
    
}


-(void)setProgress:(CGFloat)prog animated:(BOOL)animated
{
    DLog(@"progress = %f",prog);
    if (prog) {
        [self.loadingProgressView setProgress:prog animated:animated];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
