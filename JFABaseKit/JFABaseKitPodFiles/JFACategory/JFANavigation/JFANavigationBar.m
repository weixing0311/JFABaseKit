//
//  JFANavigationBar.m
//  AppInstallerGreen
//
//  Created by bobo on 2/27/15.
//
//

#import "JFANavigationBar.h"
#import "UIViewController+JFANavigation.h"
#import "JFANavigationController.h"

@interface JFANavigationBar ()

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIView *contentView;

@end
@implementation JFANavigationBar

+ (CGFloat)navigationBarHeight {
    CGFloat height = 44;
    if (IOS7_OR_LATER) {
        height += [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return height;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:self.backgroundView];
        
        DLog(@"%@",NSStringFromCGRect(frame));
        CGFloat originY = 0;
        if (IOS7_OR_LATER) {
            originY = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, frame.size.width, frame.size.height - originY)];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.contentView];
        
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftButton.frame = CGRectMake(0, 2, 60, 40);
        [self.contentView addSubview:self.leftButton];
        self.leftButton.hidden = YES;
        
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightButton.frame = CGRectMake(frame.size.width-45, 2, 45, 40);
        [self.contentView addSubview:self.rightButton];
        self.rightButton.hidden = YES;
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(65, 2, JFA_SCREEN_WIDTH - 130, 40)];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.font = [UIFont systemFontOfSize:20];
        self.title.textColor = [UIColor blackColor];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.title];
    }
    return self;
}

+ (JFANavigationBar *)baseNavigationBarWithViewController:(UIViewController *)viewController {
    CGFloat navigationBarHeight = [JFANavigationBar navigationBarHeight];
    
    JFANavigationBar *navigationBar = [[JFANavigationBar alloc] initWithFrame:CGRectMake(0, 0, viewController.view.bounds.size.width, navigationBarHeight)];
//    navigationBar.backgroundView.image = [UIImage storeImageNamed:navigationBarImage];
    DLog(@"%@",NSStringFromCGRect(navigationBar.frame));
//    navigationBar.backgroundColor = [UIColor colorForHex:@"#F7F7F7"];
    navigationBar.backgroundColor = [UIColor colorForHex:@"#ffffff"];
    
                     
    navigationBar.title.text = viewController.title;
    if (viewController.jfa_navigationController) {
        [navigationBar.leftButton addTarget:viewController.jfa_navigationController
                                     action:@selector(popViewController)
                           forControlEvents:UIControlEventTouchUpInside];
        
        if (viewController.jfa_navigationController.viewControllers.count) {
            navigationBar.leftButton.hidden = NO;
        }
    }
    navigationBar.tag = JFANavigationBarViewTag;
    return navigationBar;
}

@end
