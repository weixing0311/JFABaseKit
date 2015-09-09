//
//  PopularSearchViewController.h
//  AppInstallerGreen
//
//  Created by 杨天杰 on 14-1-10.
//
//

#import <UIKit/UIKit.h>


@protocol PopularSearchDelegate <NSObject>

@optional

- (void) didSearchPolularSearch:(NSString *)keyword;

@end


@interface PopularSearchViewController : UIViewController

@property (nonatomic, assign) id <PopularSearchDelegate> delegate;
@property (nonatomic, assign) NSUInteger pageCount;

@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UIButton *hotButton;
@property (strong, nonatomic) IBOutlet UIButton *historyButton;
@property (strong, nonatomic) IBOutlet UIView *menuLine;
@property (strong, nonatomic) IBOutlet UIView *showResultView;
@property (strong, nonatomic) IBOutlet UIButton *getMoreButton;
@property (strong, nonatomic) IBOutlet UITableView *resultTableView;
@property (strong, nonatomic) IBOutlet UIScrollView *resultView;
@property (nonatomic, strong) UITextField *textField;

- (IBAction)menuButtonAction:(UIButton*)button;
- (void)setBtnEnable:(BOOL)enable;
-(void)reloadHistory;

@end
