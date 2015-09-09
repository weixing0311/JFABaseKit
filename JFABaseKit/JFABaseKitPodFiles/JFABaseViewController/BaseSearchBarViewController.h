//
//  BaseSearchBarViewController.h
//  AppInstallerGreen
//
//  Created by 杨天杰 on 14-1-9.
//
//

//#import "BaseNetworkServiceTableViewController.h"
#import "JFABaseTableViewController.h"

@interface BaseSearchBarViewController : JFABaseTableViewController

@property(nonatomic,assign) BOOL isSearchVC;
@property(nonatomic,assign) BOOL isTopSearchVC;

//- (UIView *)addSearchViewToNavigationController:(BOOL)isHomeSearch;
- (void) doCanelButtonPressAction;
- (void) canelButtonPressAction;
- (void) hideSearchBarView;

@end
