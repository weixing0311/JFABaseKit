//
//  ViewControllerWithCustomBackButton.h
//  AppInstaller
//
//  Created by  on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBarTitleView.h"
#import "JFABaseViewController.h"


@class JFANavigationBar;

@interface ViewControllerWithCustomNavigationBar : JFABaseViewController
{
//    UISwipeGestureRecognizer *_swipeGesture;
//    BOOL _padShowBack;
}

//@property (nonatomic, readonly, retain) NavigationBarTitleView *titleView;
//@property (nonatomic, retain) UINavigationController *parentNavigationController;
//@property (nonatomic, assign) BOOL canSwipeBack;
@property (nonatomic, strong) NSString *modelId;
@property (nonatomic, strong) NSString *logid;
@property (nonatomic, assign) BOOL isFromAppDetail;
//@property (nonatomic, assign) BOOL hidesNavigationBarWhenPushed;
//@property (nonatomic, assign) BOOL isBaseNav;
- (void)navigationBack:(id)sender;
//- (void)onActionSearchButtonClick:(id)sender;
//
//- (void)onActionSettingsButtonClick:(id)sender;
@property (nonatomic, assign) BOOL isFromDownload;

@property (nonatomic, strong) JFANavigationBar *jfa_navigationBar;

- (void)createDefaultNavigationBar;

-(void)initBackNavLeftBar;
@end
