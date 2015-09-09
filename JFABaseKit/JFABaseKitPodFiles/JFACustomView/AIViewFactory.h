//
//  AIViewFactory.h
//  AppInstaller
//
//  Created by  on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AISearchBar.h"
#import "NavigationBarTitleView.h"
@class AIProgressView;

@interface AIViewFactory : NSObject

+ (NavigationBarTitleView *)createTitleViewForViewController:(UIViewController *)viewController;


+ (AISearchBar *)createSearchBarForView:(UIView *)view;
+ (UISearchBar *)createCustomizedSystemSearchBarWithFrame:(CGRect)frame;

+ (UIButton *)createButton;
+ (UIButton *)createButtonForTitle:(NSString *)title;

+ (void)changeButtonToOurCustomStyle:(UIButton *)button;

+ (UIBarButtonItem *)createBackBarButtonItemForTarget:(id)target action:(SEL)action;

+ (UIView *)createLoadingServiceViewWithFrame:(CGRect)frame autoLayout:(BOOL)autoLayout;
+ (UIView *)createDetailDefaultViewWithFrame:(CGRect)frame;
+ (AIProgressView *)createNewDetailDefaultViewWithFrame:(CGRect)frame;


+ (UIBarButtonItem *)createBackBarButtonItemForGreenTarget:(id)target action:(SEL)action;
+ (UIBarButtonItem *)createBackBarButtonItemForGreenTarget:(id)target action:(SEL)action image:(NSString*)imageName selectedImage:(NSString*)selectedImgName;
+ (UIBarButtonItem *)createBarButtonItemForGreenTarget:(id)target action:(SEL)action image:(NSString*)imageName selectedImage:(NSString*)selectedImgName;
+ (UIButton *)createButtonForTarget:(id)target action:(SEL)action image:(NSString*)imageName selectedImage:(NSString*)selectedImgName;
+ (UIBarButtonItem *)createRightButtonItemForTarget:(id)target action:(SEL)action;
+ (UIBarButtonItem *)createRightButtonItemForTarget:(id)target action:(SEL)action title:(NSString*)titleStr  leftSpace:(CGFloat)left;
+ (UIBarButtonItem *)createUpdateAllItemForTarget:(id)target action:(SEL)action;
+ (UIView*)createPadHeaderView:(NSString*)title width:(CGFloat)width;
+ (void)changeButtonToOurCustomStyleBlueButton:(UIButton *)button;


@end
