//
//  AISearchViewToNaviBar.h
//  AppInstallerGreen
//
//  Created by 杨天杰 on 14-1-17.
//
//

#import <UIKit/UIKit.h>

@protocol AISearchViewToNaviBarDelegate <NSObject>

@optional

- (void) canelButtonPressAction;
- (void) searchButtonPressAction;

@end


@interface AISearchViewToNaviBar : UIView {
    BOOL _cancelClick;
}

+ (id)viewFromNib;

@property (nonatomic, assign) id <AISearchViewToNaviBarDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIView *textbg;
@property (strong, nonatomic) IBOutlet UIView *searchContainer;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;

@property (strong, nonatomic) IBOutlet UIImageView *searchIconImageview;


- (IBAction)cancelButtonAction:(id)sender;
- (IBAction)searchButtonPressAction:(id)sender;
- (void)showCancelButton:(BOOL)isShow animation:(BOOL)animation completion:(void (^)(BOOL finished))completion;
@end
