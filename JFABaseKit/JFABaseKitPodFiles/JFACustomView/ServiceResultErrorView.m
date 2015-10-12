//
//  ServiceResultErrorView.m
//  AppInstaller
//
//  Created by liuweina on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ServiceResultErrorView.h"

@interface ServiceResultErrorView()

@property (nonatomic, strong) UIImageView * errorImageView;
@end

@implementation ServiceResultErrorView

@synthesize refreshButton = _refreshButton;
@synthesize error = _error;
@synthesize errorLabel = _errorLabel;
@synthesize errorView =_errorView;
@synthesize control =_control;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.control=[[UIButton alloc]initWithFrame:self.bounds];
        
        
        UIImage * errorImage = [UIImage storeImageNamed:@"bg_network_error_new"];
        self.errorImageView = [[UIImageView alloc] initWithImage:errorImage];
        
        
        _errorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _errorLabel.textColor = [UIColor colorForHex:@"#868686"];
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.font = [UIFont systemFontOfSize:15.0];
        _errorLabel.textColor = AI_STORE_TEXT_MAINCOLOR;
        
        UIImage *image = nil;
        UIImage *imagePressed = nil;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            image = [UIImage storeImageNamed:@"btn_refresh_normal_pad.png"];
            imagePressed = [UIImage storeImageNamed:@"btn_refresh_pressed_pad.png"];
        }
        else {
//            image = [UIImage storeImageNamed:@"btn_refresh_normal_pad.png"];
//            imagePressed = [UIImage storeImageNamed:@"btn_refresh_normal_pad.png"];
        }
        _refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [_refreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_refreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_refreshButton setBackgroundImage:image forState:UIControlStateNormal];
        [_refreshButton setBackgroundImage:imagePressed forState:UIControlStateHighlighted];
        
//        [_refreshButton setTitle:NSLocalizedString(@"刷新试试", @"") forState:UIControlStateNormal];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.control.backgroundColor = [UIColor colorForHex:@"#eaedf1"];
        }
        [self addSubview:_control];
        [self addSubview:self.errorImageView];
        [self addSubview:_errorLabel];
        [self addSubview:_refreshButton];
        
    }
    return self;
}

- (void)setError:(NSError *)error
{
    _error = error;
    NSString *emsg = nil;
    if ([_error code] == -1001) {
        emsg = @"请求超时，请点此刷新";
    }
    
    if (emsg == nil) {
        emsg = @"加载失败,请重新尝试";
    }
    
    _errorLabel.text = emsg;
    [self setNeedsLayout];
}

- (void)setErrorText:(NSString *)errorText
{
    _errorLabel.text = @"加载失败,请重新尝试";
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.errorImageView.frame;
//    rect.origin.y = AI_STORE_IS_IPHONE5 ? 85 : 40;
    rect.origin.y = self.control.frame.size.height*1/4.0 - 20;
    rect.size.width = AI_SCREEN_WIDTH*3/5.0;
    rect.origin.x = AI_SCREEN_WIDTH/2 - rect.size.width/2;
    rect.size.height = AI_SCREEN_WIDTH*3/5.0+10;
    self.errorImageView.frame = rect;
    
    CGRect frame = self.errorLabel.frame;
    CGSize labelSize = [self.errorLabel sizeThatFits:self.bounds.size];
    frame.size.width = labelSize.width;
    frame.size.height = labelSize.height;
    frame.origin.x = (self.bounds.size.width - labelSize.width) / 2;
    frame.origin.y = self.errorImageView.frame.origin.y + self.errorImageView.frame.size.height + 25;
    self.errorLabel.frame = frame;
    
    CGRect buttonFrame = self.refreshButton.frame;
    buttonFrame.origin.x = self.bounds.size.width/2 - buttonFrame.size.width/2;
    buttonFrame.origin.y = self.errorLabel.frame.origin.y + self.errorLabel.frame.size.height + 30;
    self.refreshButton.frame = buttonFrame;
    self.control.frame = self.bounds;

}

@end
