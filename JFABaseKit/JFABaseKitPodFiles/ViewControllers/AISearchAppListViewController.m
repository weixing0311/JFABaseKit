//
//  AISearchAppListViewController.m
//  AppInstallerGreen
//
//  Created by 杨天杰 on 14-1-21.
//
//

#import "AISearchAppListViewController.h"
//#import "AIRetrieveSearchSuggestionSearvice.h"
//#import "AISearchAppService.h"
#import "JFAAppDetailViewController.h"
#import "JFABaseTableViewController.h"
#import "AISearchHistoryCell.h"
//#import "MobClick.h"
#import "JFAAppDelegateHelper.h"


#define TEXTFILED_MAX_LENGTH 100

@interface AISearchAppListViewController ()
{
//    UITableView* _suggestTabelView;
    NSMutableArray* _suggestArray;
//    AIRetrieveSearchSuggestionSearvice* _searchSuggestion;
}

@end

@implementation AISearchAppListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.logid = @"600001";
//        self.manulReload = NO;
//        self.canSwipeBack = NO;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = nil;
//    self.navigationItem.leftItemsSupplementBackButton
    self.navigationItem.hidesBackButton = YES;
    
//    self.autoRefesh = NO;
    
//    _searchSuggestion = [[AIRetrieveSearchSuggestionSearvice alloc] init];
//    
//    _searchSuggestion.delegate = self;
//    
//    _searchSuggestion.managedObjectContext = [AIApplicationUtility sharedInstance].managedObjectContext;
//    
//    
//    
//    _suggestTabelView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    _suggestTabelView.delegate = self;
//    _suggestTabelView.dataSource = self;
//    _suggestTabelView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    _suggestTabelView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    _suggestTabelView.backgroundColor = [UIColor clearColor];
//    //    _suggestTabelView.scrollEnabled = NO;
//    
//    _suggestTabelView.backgroundColor = [UIColor whiteColor];
//    
//    [self.view addSubview:_suggestTabelView];
//    _suggestTabelView.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveChange:) name:UITextFieldTextDidChangeNotification object:nil];
    _suggestArray = [[NSMutableArray alloc] init];

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.titleView.userInteractionEnabled = NO;
    
//    self.textField.delegate = self;
    
    if (self.searchViewToNaiBar.hidden) {
        self.searchViewToNaiBar.hidden = NO;
        self.searchViewToNaiBar.alpha = 0.0;
        [UIView animateWithDuration:.0 animations:^{
            self.searchViewToNaiBar.alpha = 1.0;
        }];
    }
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

//    self.isPushing = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo  safeObjectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    
    //    DLog(@"height : %f",height);
    
    CGRect suggetTabelFrame = self.view.bounds;
    suggetTabelFrame.size.height -= height - 49;
    
    [_suggestTabelView setFrame:suggetTabelFrame];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [_suggestTabelView setFrame:self.view.bounds];
}



- (void)receiveChange:(NSNotification *)aNotification
{
    //    DLog(@"testFiled: %@", _textField.text);
//    [_searchSuggestion cancel];
//    [self hotsearchViewShow:YES];
//    if (!_textField.text || [_textField.text isEqualToString:@""]) {
//        [_suggestArray removeAllObjects];
//        
////        [_suggestTabelView reloadData];
//        _suggestTabelView.hidden = YES;
//    }
//    else{
//        DLog(@"superview : %@",_suggestTabelView.superview);
//        
//        if (_textField.markedTextRange == nil &&  [_textField.text length] > TEXTFILED_MAX_LENGTH) {
//            _textField.text = [_textField.text  substringToIndex:TEXTFILED_MAX_LENGTH];
//        }
//        if (_textField.text && [_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length){
//            [_searchSuggestion resetKeyword:_textField.text];
//            [_searchSuggestion startAsynchronous];
//            _suggestTabelView.dataSource = self;
//            _searchSuggestion.delegate = self;
//            _suggestTabelView.delegate = self;
//            _suggestTabelView.hidden = NO;
//            [_suggestTabelView reloadData];
//        }
//    }
    
}

- (void)hideKeyBoard
{
    [self.textField resignFirstResponder];
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
//        [self refreshResult:keyword];
        
    }
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (tableView == _suggestTabelView) {
//        return [_suggestArray count];
//    }
//    
////    NSInteger count = [self.data count];
//    if (self.loadingView.hidden)
//    {
//        if (count) {
//            [self setEmptyView:self.emptyView hidden:YES];
//        } else {
//            [self setEmptyView:self.emptyView hidden:NO];
//        }
//    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _suggestTabelView) {
    
        static NSString *CellIdentifier = @"AISearchHistoryCell";
        
        AISearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil){
//            cell = (AISearchHistoryCell*)[[[AIApplicationUtility xibBundle] loadNibNamed:CellIdentifier owner:nil options:nil] objectAtIndex:0];
        }
        if (indexPath.row < _suggestArray.count) {
            cell.titleLabel.text = _suggestArray[indexPath.row];
        }
        
        CGRect frame = cell.titleLabel.frame;
        frame.origin.x = 20;
        cell.titleLabel.frame = frame;
        cell.icon.hidden = YES;
        cell.deleteBtn.hidden = YES;
        cell.titleLabel.textAlignment = UITextAlignmentLeft;
        return cell;
    }
    else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _suggestTabelView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //    self.selectedIndexPath = indexPath;
        if (indexPath.row > _suggestArray.count) {
            return;
        }
        AISearchHistoryCell *cell = (AISearchHistoryCell *)[tableView cellForRowAtIndexPath:indexPath];
        NSString* keyword = cell.titleLabel.text;
//        [MobClick event:@"Search_Key_Click" label:@"Suggest"];
//        [self hotsearchViewShow:NO];
//        [self refreshResult:keyword];
    }
    else{
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

//        if (self.isPushing || ((self.navigationController && self.navigationController.view.hidden) || self.parentNavigationController.view.hidden)) {
//            return;
//        }
//        if (self.isPushing ) {
//            return;
//        }
//        
//        self.isPushing = YES;
//        App* app = [self.data objectAtIndex:indexPath.row];
//        if (app.size.longLongValue == 0) {
//            [[JFAAppDelegateHelper sharedHelper] openAppWithIdentifier:app.itunesID];
//        }
//        else {
//            JFAAppDetailViewController *detailViewController = [[JFAAppDetailViewController alloc] init];
//            detailViewController.parent = @"搜索";
////            [MobClick event:@"AppDetail_Enter" label:detailViewController.parent];
//            detailViewController.logid = [self.logid stringByAppendingFormat:@"%03d", indexPath.row];
//            detailViewController.app = app;
//            detailViewController.keyword = self.textField.text;
//            
////            detailViewController.parentServiceBaseURLKey = self.serviceBaseURLKey;
////            detailViewController.managedObjectContext = self.managedObjectContext;
//
//            [self.jfa_navigationController pushViewController:detailViewController];
//        }
//        
//        [self.textField resignFirstResponder];
//        
//        [self hideSearchBarView];
    }
    
}

#pragma mark - PopularSearchDelegate
- (void) didSearchPolularSearch:(NSString *)keyword
{
//    [self hotsearchViewShow:NO];
//    [MobClick event:@"Search_Hot" label:[NSString stringWithFormat:@"iPhone_%@",keyword]];
//    [self refreshResult:keyword];
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
        [self.textField resignFirstResponder];
    }else{
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
//
//- (void)hotsearchViewShow:(BOOL)isShow
//{
//    if (isShow ) {
//        if (_popularSearchVC.view.superview != self.view){
//            _popularSearchVC.view.frame = self.view.bounds;
//            [_popularSearchVC.view removeFromSuperview];
//            [_popularSearchVC reloadHistory];
//            [self.view addSubview:_popularSearchVC.view];
//            self.popularSearchVC.delegate = self;
//            _suggestTabelView.dataSource = self;
//            _searchSuggestion.delegate = self;
//            _suggestTabelView.delegate = self;
//            _textField.delegate = self;
//            [self.popularSearchVC setBtnEnable:YES];
//        }
//        
//        
//    }
//    else{
//        [self.popularSearchVC setBtnEnable:NO];
//        [_popularSearchVC.view removeFromSuperview];
//        
////        [_searchViewToNaiBar showCancelButton:NO animation:YES];
//        
//    }
//    
//}

- (void)textFieldTouchDown:(UITextField *)textField{
    if (![textField isFirstResponder]){
//        [self hotsearchViewShow:YES];
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

//- (void)refreshResult:(NSString*)keyword
//{
////    _reloading = YES;
//    if ([keyword length] >TEXTFILED_MAX_LENGTH) {
//        keyword = [keyword substringToIndex:TEXTFILED_MAX_LENGTH];
//    }
//    
//    self.textField.text = keyword;
//    [self changeHistoryArrayWithKey:keyword add:YES];
//    [_suggestTabelView reloadData];
//    AISearchAppService * searchService = [[AISearchAppService alloc] initWithKeyword:keyword];
//    self.listService = searchService;
//    self.listService.delegate = self;
////    [self.listService startAsynchronous];
//    
//    [self refreshApp:YES];
//    
//    [self.textField resignFirstResponder];
//    
//    [self hotsearchViewShow:NO];
//}

#pragma mark -

- (void)setEmptyView:(UIView *)emptyView hidden:(BOOL)hidden
{
    if (emptyView) {
        if (hidden) {
            
            [emptyView removeFromSuperview];
        } else if(self.errorView.hidden){
//            [self.view addSubview:emptyView];
            [self.view insertSubview:emptyView belowSubview:_suggestTabelView];
        }
    }
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
        
        AITaskEmptyView * view = [[AITaskEmptyView alloc] initWithFrame:self.view.bounds];
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

//-(void)dealloc {
//    _searchSuggestion.delegate=nil;
//    [_searchSuggestion cancel];
//    _searchViewToNaiBar.delegate = nil;
//    _searchViewToNaiBar = nil;
//    _suggestTabelView.dataSource = nil;
//    _suggestTabelView.delegate = nil;
//    _suggestTabelView = nil;
//    self.popularSearchVC = nil;
//    _textField = nil;
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

@end
