//
//  JFANavigationBar.h
//  AppInstallerGreen
//
//  Created by bobo on 2/27/15.
//
//

#import <UIKit/UIKit.h>

#define JFANavigationBarViewTag 10000

@interface JFANavigationBar : UIView

@property (nonatomic, strong, readonly) UIButton *leftButton; // same with back button
@property (nonatomic, strong, readonly) UIButton *rightButton;
@property (nonatomic, strong, readonly) UILabel *title;
@property (nonatomic, strong, readonly) UIImageView *backgroundView;
@property (nonatomic, strong, readonly) UIView *contentView; // add custom view to contentView
@property (nonatomic, strong) UILabel *line;


+ (JFANavigationBar *)baseNavigationBarWithViewController:(UIViewController *)viewController;
+ (CGFloat)navigationBarHeight;

@end
