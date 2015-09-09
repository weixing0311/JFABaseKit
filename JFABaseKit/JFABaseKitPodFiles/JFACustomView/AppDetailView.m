//
//  AppDetailView.m
//  AppInstaller
//
//  Created by liuweina on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDetailView.h"
#import "App.h"
#import "JFAAppDetailViewController.h"
#import "AIDetailBrief.h"
#import "NSDate+Utilities.h"

@interface AppDetailView () <UITextViewDelegate,DetailBriefDelegate> {
    CGFloat _shortHeight;
}
@property (nonatomic, strong) AIDetailBrief * textView;
@property (nonatomic, strong) AIDetailBrief * upgradeTextView;
@property (nonatomic, strong) App *app;
@end

@implementation AppDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = NO;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // adjust summary textView
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidFinishLoadForDetailView:)]) {
        [self.delegate textViewDidFinishLoadForDetailView:self];
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    if (self.upgradeTextView) {
        return CGSizeMake(size.width,_upgradeTextView.frame.origin.y + _upgradeTextView.frame.size.height);
    }
    return CGSizeMake(size.width,_textView.frame.origin.y + _textView.frame.size.height);
}

- (void)setApp:(App *)app
{
    _app = app;
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, 0);
    self.textView = [[AIDetailBrief alloc]init];
    [self.textView setTitle:@"内容提要"];
    self.textView.tag = 1;
    self.textView.delegate = self;
    self.textView.desLab.text = _app.textSummary;
    DLog(@"intro : %@",_app.textSummary);
    _shortHeight = [self.textView getShortHeight] < 101 ? 105 : [self.textView getShortHeight];
    self.textView.desLab.frame = CGRectMake(self.textView.desLab.frame.origin.x, self.textView.desLab.frame.origin.y, self.textView.frame.size.width - 20, _shortHeight);
    if ([self.textView getHeight] < 137) {
        frame.size.height = [self.textView getHeight];
        [self.textView setDesStr:_app.textSummary show:NO];
        [self.textView setButtonUI:NO more:NO];
    }
    else {
        [self.textView setDesStr:_app.textSummary show:YES];
        frame.size.height = 145;
        
        [self.textView setButtonUI:YES more:YES];
        DLog(@"height : %f",self.textView.desLab.frame.size.height);
    }
    
    self.textView.frame = frame;
    [self addSubview:self.textView];
    
    if (_app.updateInfo && _app.updateInfo.length > 0) {
        CGRect frame2 = CGRectMake(0, 0, self.frame.size.width, 0);
        self.upgradeTextView = [[AIDetailBrief alloc]init];
        self.upgradeTextView.tag = 0;
        self.upgradeTextView.delegate = self;
        [self.upgradeTextView setTitle:@"更新日志"];
        self.upgradeTextView.desLab.text = _app.updateInfo;
        [self.upgradeTextView setDateStr:[[self dateFromString:_app.releaseDate] stringWithFormat:@"yyyy-MM-dd"]];
        self.upgradeTextView.desLab.frame = CGRectMake(self.upgradeTextView.desLab.frame.origin.x, self.upgradeTextView.desLab.frame.origin.y, self.upgradeTextView.frame.size.width - 20, _shortHeight);
        if ([self.upgradeTextView getHeight] < 137) {
            frame2.size.height = [self.upgradeTextView getHeight];
            [self.upgradeTextView setDesStr:_app.updateInfo show:NO];
            [self.upgradeTextView setButtonUI:NO more:NO];
        }
        else {
            frame2.size.height = 145;
            [self.upgradeTextView setDesStr:_app.updateInfo show:YES];
            [self.upgradeTextView setButtonUI:YES more:YES];
        }
        [self addSubview:self.upgradeTextView];
        frame2.origin.y = frame.size.height;
        self.upgradeTextView.frame = frame2;
    }
}

- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

-(void)onDetailBriefSelectedAt:(NSInteger)viewTag more:(BOOL)more {
    if (viewTag == 0) {
        CGRect frame = self.upgradeTextView.frame;
        frame.size.width = AI_SCREEN_WIDTH;
        if (more) {
            self.upgradeTextView.desLab.numberOfLines = 0;
            self.upgradeTextView.desLab.lineBreakMode = 0;
            [self.upgradeTextView.desLab sizeToFit];
            frame.size.height = [self.upgradeTextView getHeight] + 10;
        }
        else {
            self.upgradeTextView.desLab.numberOfLines = 0;
            frame.size.height = 145;
        }
        
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.upgradeTextView.frame = frame;
            if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidFinishLoadForDetailView:)]) {
                [self.delegate textViewDidFinishLoadForDetailView:self];
                if (more) {
                    [self.delegate showMoreViewAtOffsetY:self.frame.origin.y + self.textView.frame.size.height];
                }
            }
        } completion:^(BOOL finished) {
            if (!more) {
                self.upgradeTextView.desLab.frame = CGRectMake(self.upgradeTextView.desLab.frame.origin.x, self.upgradeTextView.desLab.frame.origin.y, AI_SCREEN_WIDTH - 20, _shortHeight);
                self.upgradeTextView.desLab.numberOfLines = 0;
                self.upgradeTextView.desLab.lineBreakMode = NSLineBreakByTruncatingTail;
            }
        }];
    }
    else if (viewTag == 1) {
        CGRect frame = self.textView.frame;
        frame.size.width = AI_SCREEN_WIDTH;
        if (more) {
            self.textView.desLab.numberOfLines = 0;
            self.textView.desLab.lineBreakMode = 0;
            [self.textView.desLab sizeToFit];
            frame.size.height = [self.textView getHeight]  + 10 ;
        }
        else {
            self.upgradeTextView.desLab.numberOfLines = 0;
            frame.size.height = 145;
        }
        CGRect frame2 = self.upgradeTextView.frame ;
        frame2.origin.y = frame.size.height;
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.textView.frame = frame;
            self.upgradeTextView.frame = frame2;
            if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidFinishLoadForDetailView:)]) {
                [self.delegate textViewDidFinishLoadForDetailView:self];
                if (more) {
                    [self.delegate showMoreViewAtOffsetY:(self.frame.origin.y)];
                }
            }
        } completion:^(BOOL finished) {
            if (!more) {
                self.textView.desLab.frame = CGRectMake(self.textView.desLab.frame.origin.x, self.textView.desLab.frame.origin.y, AI_SCREEN_WIDTH - 20, _shortHeight);
                self.textView.desLab.text = _app.textSummary;
                self.textView.desLab.numberOfLines = 0;
                self.textView.desLab.lineBreakMode = NSLineBreakByTruncatingTail;
            }
        }];
    }
}

-(void)dealloc {
    self.upgradeTextView.delegate = nil;
    self.textView.delegate = nil;
}

@end