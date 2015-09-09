//
//  AppDetailView.h
//  AppInstaller
//
//  Created by liuweina on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppStarView.h"
//#import "App.h"
//#import "LocalApp.h"
//#import "UIView+AIDownloadAnimation.h"

@class AppDetailView;
@protocol AppDetailViewDelegate <NSObject>

- (void)textViewDidFinishLoadForDetailView:(AppDetailView *)detailView;
- (void)showMoreViewAtOffsetY:(CGFloat)offsetY;
@end

@interface AppDetailView : UIView<NSURLConnectionDataDelegate>

//@property (nonatomic, strong) App *app;
@property (nonatomic, assign) BOOL isUpdatingApp;
@property (nonatomic, assign) id<AppDetailViewDelegate> delegate;

@end
