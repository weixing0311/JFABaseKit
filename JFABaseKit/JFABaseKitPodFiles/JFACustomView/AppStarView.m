//
//  AppStarImageView.m
//  AppInstaller
//
//  Created by liuweina on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppStarView.h"
#import "UIImage+Extension.h"
#import "UIImage+LocalImage.h"


#define APPSTAT_IMAGE_ORIGIN 3.0
#define DEFALUT_APPSTAR_TOTAL 5
#define DEFALUT_OFFSET_BETWEENSTARS 0

const CGFloat kAppStarViewHeight = 9.0f;
const CGFloat kAppStartViewWidth = 9.0f;

@implementation AppStarView
@synthesize appStar = _appStar;
@synthesize appStarViewWidth = _appStarViewWidth;
@synthesize starSize = _starSize;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _starSize = kAppStartViewWidth;
        
        UIImage *image = [UIImage storeImageNamed:@"star-off.png"];
        for (int i = 0; i < DEFALUT_APPSTAR_TOTAL; i ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * (self.starSize + DEFALUT_OFFSET_BETWEENSTARS), 0, self.starSize, self.starSize)];
            imageView.image = image;
            [self addSubview:imageView];
        }
        
        _appStar = 0;
        _appStarViewWidth = DEFALUT_APPSTAR_TOTAL * self.starSize + APPSTAT_IMAGE_ORIGIN;
    }
    
    return self;
}

- (void)setstarSize:(CGFloat)starSize
{
    _starSize = starSize;
    _appStarViewWidth = DEFALUT_APPSTAR_TOTAL * self.starSize + APPSTAT_IMAGE_ORIGIN;
}

- (void)setAppStar:(NSNumber *)appStar
{   
    if (_appStar != appStar) {
        _appStar = appStar;
        
        float star = [_appStar floatValue];
        
        NSArray *currentViews = [NSArray arrayWithArray:self.subviews];
        for (UIView *view in currentViews) {
            [view removeFromSuperview];
        }
        
        for (int i = 0; i < DEFALUT_APPSTAR_TOTAL; i ++) {
            UIImage *image = [UIImage storeImageNamed:@"star-off.png"];
            if (i < star) {
                image = [UIImage storeImageNamed:@"star-on.png"];
            }
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * (self.starSize + DEFALUT_OFFSET_BETWEENSTARS), 0, self.starSize, self.starSize)];
            imageView.image = image;
            [self addSubview:imageView];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
