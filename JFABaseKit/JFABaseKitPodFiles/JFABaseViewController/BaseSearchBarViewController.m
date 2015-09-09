//
//  BaseSearchBarViewController.m
//  AppInstallerGreen
//
//  Created by 杨天杰 on 14-1-9.
//
//

#import "BaseSearchBarViewController.h"
#import "JFABaseTableViewController.h"
//#import "AIRetrievePopularAppListService.h"
//#import "AIRetrieveRecommendAppListService.h"
//#import "AIRetrieveLimitedFreeAppListService.h"
//#import "AIViewFactory.h"
#import "UIImage+Extension.h"
//#import "AIThirdPartyListViewController.h"
//#import "AISearchAppService.h"
#import "PopularSearchViewController.h"
#import "AISearchViewToNaviBar.h"

//#import "AIRetrieveSearchSuggestionSearvice.h"
//#import "AIApplicationUtility.h"
//#import "MobClick.h"
#import "AISearchHistoryCell.h"
#import "JFAAppDetailViewController.h"
#import "AITaskEmptyView.h"
//#import <JFACommon/AILogCenter.h>
#import "JFAAppDelegateHelper.h"

#define SEARCH_LEFT_MARGIN 7
#define SEARCH_TOP_MARGIN 7
#define SEARCH_WIDTH 260
#define SEARCH_HEIGHT 30
#define SEARCH_VIEW_TAG 10000

#define TEXTFILED_MAX_LENGTH 100


@interface BaseSearchBarViewController ()<UITextFieldDelegate, PopularSearchDelegate, UITableViewDataSource, UITableViewDelegate,AISearchViewToNaviBarDelegate>
{
    UITextField* _textField;
    
//    AIRetrieveSearchSuggestionSearvice* _searchSuggestion;
    
    UITableView* _suggestTabelView;
    NSMutableArray* _suggestArray;
    
    AISearchViewToNaviBar* _searchViewToNaiBar;
    BOOL cancelPressed;
    BOOL _firstCome;
}
@property (nonatomic, strong) PopularSearchViewController* popularSearchVC;
@property (nonatomic, strong) AITaskEmptyView * emptyView;
@property (nonatomic, strong) UIView * searchView;
@property (nonatomic, assign) BOOL isDefaultWord;


@end

//static UINavigationController* searchNavi;

@implementation BaseSearchBarViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.modelId = @"600001";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createDefaultNavigationBar];
//    [[AILogCenter defaultCenter] sendActiveEvent:@"600001"];
    self.logid = @"601001";
    if (self.isTopSearchVC) {
        [self popularViewInit];
        _searchViewToNaiBar = [AISearchViewToNaviBar viewFromNib];
        [_searchViewToNaiBar showCancelButton:NO animation:NO completion:^(BOOL finished) {}];
        
        CGRect frame = _searchViewToNaiBar.frame;
        frame.size.width = AI_SCREEN_WIDTH;
        _searchViewToNaiBar.frame = frame;
        _searchViewToNaiBar.delegate = self;
        _textField = _searchViewToNaiBar.textField;
        _searchViewToNaiBar.searchBtn.hidden = YES;
        _textField.delegate = self;
        [self.jfa_navigationBar.contentView addSubview:_searchViewToNaiBar];
        self.popularSearchVC.textField = _textField;
        self.searchView = _searchViewToNaiBar;
    }
    if (self.isSearchVC || self.isTopSearchVC) {
        
        self.jfa_navigationBar.leftButton.hidden = YES;
    }
    
//    _searchSuggestion = [[AIRetrieveSearchSuggestionSearvice alloc] init];
//    
//    _searchSuggestion.delegate = self;
//    
//    _searchSuggestion.managedObjectContext = [AIApplicationUtility sharedInstance].managedObjectContext;
    
    CGFloat navigationBarHeight = [JFANavigationBar navigationBarHeight];
    _suggestTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationBarHeight,
                                                                      AI_SCREEN_WIDTH,
                                                                      self.view.bounds.size.height - navigationBarHeight)
                                                     style:UITableViewStylePlain];
    _suggestTabelView.delegate = self;
    _suggestTabelView.dataSource = self;
    _suggestTabelView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _suggestTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _suggestTabelView.backgroundColor = [UIColor whiteColor];
    _suggestTabelView.hidden = YES;
    _suggestTabelView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    _suggestArray = [[NSMutableArray alloc] init];
    
    //    self.titleView.userInteractionEnabled = NO;
    if (self.isTopSearchVC) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!cancelPressed && self.isTopSearchVC && !_firstCome) {
        _firstCome = YES;
        _searchViewToNaiBar.delegate = self;
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textFieldTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_textField becomeFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.searchView && self.searchView.hidden && self.isTopSearchVC) {
        self.searchView.hidden = NO;
        self.searchView.alpha = 0.0;
        [UIView animateWithDuration:.0 animations:^{
            self.searchView.alpha = 1.0;
        }];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    
    
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //    self.isPushing = NO;
}

#pragma mark - keyboard delegate

- (void)keyboardWillShow:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo  safeObjectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    CGFloat navigationBarHeight = [JFANavigationBar navigationBarHeight];
    [_suggestTabelView setFrame:CGRectMake(0, navigationBarHeight,
                                           self.view.bounds.size.width,
                                           self.view.bounds.size.height - navigationBarHeight - height)];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    CGFloat navigationBarHeight = [JFANavigationBar navigationBarHeight];
    [_suggestTabelView setFrame:CGRectMake(0, navigationBarHeight,
                                           self.view.bounds.size.width,
                                           self.view.bounds.size.height - navigationBarHeight)];
}

#pragma mark -

- (void)receiveChange:(NSNotification *)aNotification
{
    //    DLog(@"testFiled: %@", _textField.text);
//    [_searchSuggestion cancel];
    [self hotsearchViewShow:YES];
    if (!_textField.text || [_textField.text isEqualToString:@""]) {
        [_suggestArray removeAllObjects];
        
        //        [_suggestTabelView reloadData];
        _suggestTabelView.hidden = YES;
        _popularSearchVC.view.hidden = NO;
        [self.emptyView removeFromSuperview];
    }
    else{
        DLog(@"superview : %@",_suggestTabelView.superview);
        
        if (_textField.markedTextRange == nil &&  [_textField.text length] > TEXTFILED_MAX_LENGTH) {
            _textField.text = [_textField.text  substringToIndex:TEXTFILED_MAX_LENGTH];
        }
        if (_textField.text && [_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length){
//            [_searchSuggestion resetKeyword:_textField.text];
//            [_searchSuggestion startAsynchronous];
            _suggestTabelView.dataSource = self;
//            _searchSuggestion.delegate = self;
            _suggestTabelView.delegate = self;
            _suggestTabelView.hidden = NO;
            [_suggestTabelView reloadData];
        }
    }
    
}

- (void)hideKeyBoard
{
    [_textField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self receiveChange:nil];
    [_searchViewToNaiBar showCancelButton:YES animation:YES completion:^(BOOL finished) {
        
    }];
    [_textField becomeFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSString * keyword = textField.text;
    if ([keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length)
    {
//        [MobClick event:@"Search_Key_Click" label:@"Input"];
        [self refreshResult:keyword];
        
    }
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _suggestTabelView) {
        return [_suggestArray count];
    }
    
//    NSInteger count = [self.data count];
//    if (self.loadingView.hidden)
//    {
//        if (count) {
//            [self setEmptyView:self.emptyView hidden:YES];
//        } else {
//            [self setEmptyView:self.emptyView hidden:NO];
//        }
//        
//    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (tableView == _suggestTabelView) {
//        
//        static NSString *CellIdentifier = @"AISearchHistoryCell";
//        
//        AISearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        
//        if (cell == nil){
//            cell = (AISearchHistoryCell*)[[[AIApplicationUtility xibBundle] loadNibNamed:CellIdentifier owner:nil options:nil] objectAtIndex:0];
//        }
//        if (indexPath.row < _suggestArray.count) {
//            cell.titleLabel.text = _suggestArray[indexPath.row];
//        }
//        
//        CGRect frame = cell.titleLabel.frame;
//        frame.origin.x = 20;
//        cell.titleLabel.frame = frame;
//        cell.icon.hidden = YES;
//        cell.deleteBtn.hidden = YES;
//        cell.titleLabel.textAlignment = UITextAlignmentLeft;
//        return cell;
//    }
//    else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
//    }
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    self.logid = self.isDefaultWord?@"601001":@"602001";

    if (tableView == _suggestTabelView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //    self.selectedIndexPath = indexPath;
        if (indexPath.row > _suggestArray.count) {
            return;
        }
        AISearchHistoryCell *cell = (AISearchHistoryCell *)[tableView cellForRowAtIndexPath:indexPath];
        NSString* keyword = cell.titleLabel.text;
//        [MobClick event:@"Search_Key_Click" label:@"Suggest"];
//        [[AILogCenter defaultCenter] sendActiveEvent:@"602001"];
        [self hotsearchViewShow:NO];
        [self refreshResult:keyword];
    }
    else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
//        App* app = [self.data objectAtIndex:indexPath.row];
//        if (app.size.longLongValue == 0) {
//            [[JFAAppDelegateHelper sharedHelper] openAppWithIdentifier:app.itunesID];
//        }
//        else {
            JFAAppDetailViewController *detailViewController = [[JFAAppDetailViewController alloc] init];
//            [MobClick event:@"AppDetail_Enter" label:detailViewController.parent];
            DLog(@"logid = %@",self.logid);
            detailViewController.logid = [self.logid stringByAppendingFormat:@"%03d",[[NSNumber numberWithInteger:indexPath.row] intValue]];
//            detailViewController.app = app;

//            detailViewController.parentServiceBaseURLKey = self.serviceBaseURLKey;
//            detailViewController.managedObjectContext = self.managedObjectContext;
            [self.jfa_navigationController pushViewController:detailViewController];
//        }
        
        [_textField resignFirstResponder];
        
        [self hideSearchBarView];
    }
    
}

#pragma mark - PopularSearchDelegate
- (void) didSearchPolularSearch:(NSString *)keyword
{

//    [[AILogCenter defaultCenter] sendActiveEvent:@"601001"];

    DLog(@"logid = %@",self.logid);
    self.isDefaultWord = YES;
    [self hotsearchViewShow:NO];
//    [MobClick event:@"Search_Hot" label:[NSString stringWithFormat:@"iPhone_%@",keyword]];
    [self refreshResult:keyword];
}

-(void)changeHistoryArrayWithKey:(NSString*)key add:(BOOL)add {
    NSArray* local = [[NSUserDefaults standardUserDefaults] arrayForKey:SearchHistoryKey];
    NSMutableArray* tmp = nil;
    if (local) {
        tmp = [NSMutableArray arrayWithArray:local];
    }
    else {
        tmp = [NSMutableArray array];
    }
    if (key) {
        for (NSString* tmpkey in tmp) {
            if ([tmpkey isEqualToString:key]) {
                [tmp removeObject:tmpkey];
                break;
            }
        }
        if (add) {
            [tmp insertObject:key atIndex:0];
        }
    }
    else if (!add) {
        [tmp removeAllObjects];
    }
    if (tmp.count > 30) {
        NSArray* tmp2 = [NSArray arrayWithArray:tmp];
        for (NSInteger i = 30; i < tmp2.count; i ++) {
            [tmp removeObject:[tmp2 objectAtIndex:i]];
        }
    }
    [[NSUserDefaults standardUserDefaults] setValue:tmp forKey:SearchHistoryKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSArray*)getSearchHistoryArray {
    NSArray* local = [[NSUserDefaults standardUserDefaults] arrayForKey:SearchHistoryKey];
    NSMutableArray* tmp = nil;
    if (local) {
        tmp = [NSMutableArray arrayWithArray:local];
    }
    else {
        tmp = [NSMutableArray array];
    }
    return tmp;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _suggestTabelView) {
        return 40;
    }
    else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView != _suggestTabelView) {
        [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView != _suggestTabelView) {
        [super scrollViewDidScroll:scrollView];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView != _suggestTabelView) {
        [_textField resignFirstResponder];
    }
}

#pragma mark = AINetworkServiceDelegate

//- (void)service:(AINetworkService *)service succeededWithResult:(NSArray *)result
//{
//    
//    if (_searchSuggestion == service) {
//        _suggestArray = [NSMutableArray arrayWithArray:result];
//        
//        [_suggestTabelView reloadData];
//        
//        if ([_suggestArray count]) {
//            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//            
//            [_suggestTabelView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//        }
//        
//    }
//    else{
//        if (_reloading) {
//            [self.data removeAllObjects];
//            self.tableView.contentOffset = CGPointMake(0, 0);
//        }
//        [super service:service succeededWithResult:result];
//        
//    }
//    
//    
//    
//}
//
//-(void)service:(AINetworkService *)service failedWithError:(NSError *)error{
//    [self.data removeAllObjects];
//    [super service:service failedWithError:error];
//}

- (void)hotsearchViewShow:(BOOL)isShow
{
    if (isShow ) {
        if (_popularSearchVC.view.superview != self.view){
            _popularSearchVC.view.frame = _suggestTabelView.frame;
            [_popularSearchVC.view removeFromSuperview];
            [_popularSearchVC reloadHistory];
            [self.view addSubview:_popularSearchVC.view];
            [self.view addSubview:_suggestTabelView];
            self.popularSearchVC.delegate = self;
            _suggestTabelView.dataSource = self;
//            _searchSuggestion.delegate = self;
            _suggestTabelView.delegate = self;
            _textField.delegate = self;
            _popularSearchVC.view.hidden = YES;
            [self.popularSearchVC setBtnEnable:YES];
        }
        
        
    }
    else{
        [self.popularSearchVC setBtnEnable:NO];
        [_popularSearchVC.view removeFromSuperview];
        [_suggestTabelView removeFromSuperview];
        //        [_searchViewToNaiBar showCancelButton:NO animation:YES];
        
    }
    
}

- (void)textFieldTouchDown:(UITextField *)textField{
    if (![textField isFirstResponder]){
        [self hotsearchViewShow:YES];
    }
}

#pragma mark -

- (void) hideSearchBarView
{
    if (!_searchViewToNaiBar.hidden) {
        
        _searchViewToNaiBar.alpha = 1.0;
        [UIView animateWithDuration:.2 animations:^{
            
            _searchViewToNaiBar.alpha = 0.0;
        } completion:^(BOOL finished) {
            _searchViewToNaiBar.hidden = YES;
            _searchViewToNaiBar.alpha = 1.0;
        }];
    }
    
}

- (void)refreshResult:(NSString*)keyword
{
    //    _reloading = YES;
    if ([keyword length] >TEXTFILED_MAX_LENGTH) {
        keyword = [keyword substringToIndex:TEXTFILED_MAX_LENGTH];
    }
    
    _textField.text = keyword;
    [self changeHistoryArrayWithKey:keyword add:YES];
    [_suggestTabelView reloadData];
//    AISearchAppService * searchService = [[AISearchAppService alloc] initWithKeyword:keyword];
//    self.listService = searchService;
//    self.listService.delegate = self;
    //    [self.listService startAsynchronous];
    
//    [self refreshApp:YES];
    
    [_textField resignFirstResponder];
    
    [self hotsearchViewShow:NO];
}

#pragma mark -

- (void)setEmptyView:(UIView *)emptyView hidden:(BOOL)hidden
{
//    if (!_suggestTabelView.hidden) {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"enterForeground"]) {
        if (emptyView) {
            if (hidden) {
                
                [emptyView removeFromSuperview];
            } else if(self.errorView.hidden){
                //            [self.view addSubview:emptyView];
                [self.view insertSubview:emptyView belowSubview:_suggestTabelView];
            }
        }
    }
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"enterForeground"];

//    }
}

//- (void)showErrorViewForError:(NSString *)error
//{
//    if (!_emptyView.superview) {
//        self.errorView.hidden = NO;
//        [self.errorView setErrorText:error];
//    }
//    self.contentView.hidden = YES;
//}

- (UIView *)emptyView
{
    if (!_emptyView) {
        
        CGFloat navigationBarHeight = [JFANavigationBar navigationBarHeight];
        AITaskEmptyView * view = [[AITaskEmptyView alloc] initWithFrame:CGRectMake(0, navigationBarHeight,
                                                                                   self.view.bounds.size.width,
                                                                                   self.view.bounds.size.height - navigationBarHeight)];
        [view setText:NSLocalizedString(@"很抱歉，没有搜索到相关内容", @"")];
        _emptyView = view;
    }
    return _emptyView;
}

//- (void)startService:(BOOL)showLoadingView
//{
//    [super startService:showLoadingView];
//    
//    [self setEmptyView:self.emptyView hidden:YES];
//}

-(BOOL)canSwipeBack {
    return NO;
}

#pragma mark - AISearchViewToNaviBarDelegate
- (void) canelButtonPressAction
{
    [self doCanelButtonPressAction];
}
-(void)doCanelButtonPressAction {
    cancelPressed = YES;
    _textField.text = @"";
    
    [_textField resignFirstResponder];
    [_searchViewToNaiBar showCancelButton:NO animation:YES completion:^(BOOL finished) {
        
    }];
    [self hotsearchViewShow:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:HideSearchUINotification object:nil];
    //        [self.navigationController.view removeFromSuperview];
    //        searchNavi = nil;
    [self.jfa_navigationController dismissViewControllerWithTransitionStyle:JFANavigationControllerPresentTransitionStyleCrossDissolve
                                                                 completion:^{}];
    
    //    self.isPushing = NO;
    
    cancelPressed = NO;
}


#pragma mark - privatemethod
//- (UIView *)addSearchViewToNavigationController:(BOOL)isHomeSearch
//{
//
//    _searchViewToNaiBar = [AISearchViewToNaviBar viewFromNib];
//    CGRect frame = _searchViewToNaiBar.frame;
//    frame.size.width = AI_SCREEN_WIDTH;
//    _searchViewToNaiBar.frame = frame;
//    _searchViewToNaiBar.delegate = self;
//    _textField = _searchViewToNaiBar.textField;
//    _searchViewToNaiBar.searchBtn.hidden = YES;
//    _textField.delegate = self;
//    [self.jfa_navigationBar.contentView addSubview:_searchViewToNaiBar];
//    self.popularSearchVC.textField = _textField;
//
//    return _searchViewToNaiBar;
//}


- (void) popularViewInit
{
//    self.popularSearchVC = [[PopularSearchViewController alloc] initWithNibName:@"PopularSearchViewController"
//                                                                         bundle:[AIApplicationUtility xibBundle]];
//    self.popularSearchVC.delegate = self;
    
}

- (void) pushSearchVC:(NSString*)keyword
{
    
    //    if (self.isPushing) {
    //        return;
    //    }
    //    self.isPushing = YES;
    
    if ([keyword length] > TEXTFILED_MAX_LENGTH) {
        keyword = [keyword substringToIndex:TEXTFILED_MAX_LENGTH];
    }
    [self changeHistoryArrayWithKey:keyword add:YES];
    _textField.text = keyword;
    
    [_textField resignFirstResponder];
    
    [self refreshResult:keyword];
    [_searchViewToNaiBar showCancelButton:YES animation:YES completion:^(BOOL finished) {
        
    }];
    cancelPressed = NO;
}

-(void) showSearchBarView {
    if (_searchViewToNaiBar&& !_searchViewToNaiBar.hidden) {
        _searchViewToNaiBar.hidden = NO;
        _searchViewToNaiBar.alpha = 0.0;
        [UIView animateWithDuration:.4 animations:^{
            _searchViewToNaiBar.alpha = 1.0;
        }];
    }
}

-(void)dealloc {
//    _searchSuggestion.delegate=nil;
//    [_searchSuggestion cancel];
    [_searchViewToNaiBar removeFromSuperview];
    _searchViewToNaiBar.delegate = nil;
    _searchViewToNaiBar = nil;
    [_suggestTabelView removeFromSuperview];
    _suggestTabelView.dataSource = nil;
    _suggestTabelView.delegate = nil;
    _suggestTabelView = nil;
    self.popularSearchVC.delegate=nil;
    self.popularSearchVC = nil;
    [_textField removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLog(@"%d",__LINE__);
}

@end

