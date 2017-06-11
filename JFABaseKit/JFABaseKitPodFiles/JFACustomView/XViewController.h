//
//  CViewController.h
//  HotelManager
//
//  Created by Tulipa on 14-5-6.
//  Copyright (c) 2014年 Tulipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XNavigationBar.h"
#import "MBProgressHUD.h"


@interface XViewController : UIViewController

@property (nonatomic, strong) XNavigationBar* ydNavigationBar;

@property (nonatomic, readonly) MBProgressHUD *hud;

@property (nonatomic, readonly) UINavigationItem *xNavigationBarButtonItem;

- (BOOL)hasYDNavigationBar;



- (CGFloat)ydNavigationBarHeight;

- (void)showLoading:(BOOL)animated;
- (void)hideLoading:(BOOL)animated;

- (void)showHint:(NSString *)hint hide:(CGFloat)delay;

@end
