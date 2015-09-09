//
//  AISearchAppListViewController.h
//  AppInstallerGreen
//
//  Created by 杨天杰 on 14-1-21.
//
//

#import "JFABaseTableViewController.h"
#import "AITaskEmptyView.h"
#import "AISearchViewToNaviBar.h"
//#import "AIRetrieveSearchSuggestionSearvice.h"
#import "PopularSearchViewController.h"

@interface AISearchAppListViewController : JFABaseTableViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate,AISearchViewToNaviBarDelegate,PopularSearchDelegate>

@property (nonatomic, strong) AITaskEmptyView * emptyView;

@property (nonatomic, strong) UITextField* textField;

@property (nonatomic, strong) AISearchViewToNaviBar* searchViewToNaiBar;
//@property (nonatomic, strong) AIRetrieveSearchSuggestionSearvice* searchSuggestion;
@property (nonatomic, strong) PopularSearchViewController* popularSearchVC;
@property (nonatomic, strong) UITableView* suggestTabelView;
@end
