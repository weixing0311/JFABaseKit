//
//  NavigationBarTitleView.m
//  AppInstaller
//
//  Created by  on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NavigationBarTitleView.h"

@implementation NavigationBarTitleView

@synthesize titleLabel = _titleLabel;
@synthesize accessoryView = _accessoryView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_titleLabel setTextColor:[UIColor colorForHex:@"#3d3d3d"]];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
        [_titleLabel setTextAlignment:(NSTextAlignment)UITextAlignmentCenter];
        [self addSubview:_titleLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.accessoryView != nil) {
        CGSize accessoryViewSize = [self.accessoryView sizeThatFits:self.bounds.size];
        CGRect accessoryViewFrame = _accessoryView.frame;
        accessoryViewFrame.size = accessoryViewSize;
        
        CGRect titleFrame = _titleLabel.frame;
        CGSize titleSize = [_titleLabel sizeThatFits:self.bounds.size];
        accessoryViewFrame.origin.x = titleFrame.origin.x + titleSize.width + 3;
        accessoryViewFrame.origin.y = titleFrame.origin.y + 5;
        
        _accessoryView.frame = accessoryViewFrame;
    }
}

- (void)setAccessoryView:(UIView *)accessoryView
{
    _accessoryView = accessoryView;
    if (_accessoryView != nil) {
        [self addSubview:accessoryView];
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
