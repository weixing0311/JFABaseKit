//
//  AITabBarController.h
//  AppInstallerGreen
//
//  Created by liuweina on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BCTabBarController.h"

@interface AITabBarController : BCTabBarController

- (void)setBadge:(NSInteger)badge forTabBarItemAtIndex:(NSInteger)index;
- (NSString*)tabNameOfSeartch;
- (void)showSettingUI;
@end
