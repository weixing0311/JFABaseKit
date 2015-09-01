//
//  JFALoadingView.m
//  JFABaseKit
//
//  Created by stefan on 15/8/28.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import "JFALoadingView.h"

@interface JFALoadingView ()
{
    UIImageView* loadingIcon;
    UIView* contentView;
    UILabel* label;
}
@end

@implementation JFALoadingView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[self initWithFrame:frame];
    if (self) {
        contentView = [[UIView alloc] initWithFrame:self.bounds];
        contentView.tag=998;
        [self addSubview:contentView];
        
        // create the loading icon
        UIImage *loadIcon = [self loadingImage];
        loadingIcon = [[UIImageView alloc] initWithImage:loadIcon];
        loadingIcon.frame = CGRectMake(0, 0, loadIcon.size.width, loadIcon.size.height);
        [contentView addSubview:loadingIcon];
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setBackgroundColor:[UIColor clearColor]];
        [label sizeToFit];
        [contentView addSubview:label];
        
        [self resetSubViews];
    }
    return self;
}

-(void)resetSubViews
{
    label.text = NSLocalizedString(@"正在加载", @"");
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15.0];
    
    CGFloat contentViewWidth = loadingIcon.frame.size.width > label.frame.size.width ? loadingIcon.frame.size.width : label.frame.size.width;
    CGFloat contentViewHeight = label.frame.origin.y + label.frame.size.height;
    CGFloat x = self.frame.size.width / 2.0 - contentViewWidth / 2.0;
    
    CGFloat offset = 0;
    
    CGFloat y = self.frame.size.height / 2.0 - contentViewHeight / 2.0 - offset;
    contentView.frame = CGRectMake(x, y, contentViewWidth, contentViewHeight);
    
    CGRect rect = loadingIcon.frame;
    rect.origin.y = 0;
    rect.origin.x = contentViewWidth / 2.0 - loadingIcon.frame.size.width / 2.0;
    loadingIcon.frame = rect;
    
    rect = label.frame;
    rect.origin.y = loadingIcon.frame.origin.y + loadingIcon.frame.size.height + 22;
    rect.origin.x = contentViewWidth / 2.0 - label.frame.size.width / 2.0;
    label.frame = rect;
    
    loadingIcon.tag = 200001;
    
    [loadingIcon continueRotateAnimation];


}

-(UIImage*)loadingImage
{
    return [UIImage imageNamed:@"loading"];
}

-(void)stoploading
{
    self.hidden=YES;
    [loadingIcon stopRotateAnimation];
}

-(void)startloading
{
    self.hidden=NO;
    [loadingIcon continueRotateAnimation];
}

@end
