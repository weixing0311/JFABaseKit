//
//  PopularSearchViewController.m
//  AppInstallerGreen
//
//  Created by 杨天杰 on 14-1-10.
//                 
//

#import "PopularSearchViewController.h"
//#import "AIRetrievePopularSearchesService.h"
//#import "AIApplicationUtility.h"
#import "UIImage+Extension.h"
//#import "AISearchAppService.h"
//#import "AIAppListViewController.h"
#import "AISearchHistoryCell.h"
//#import "MobClick.h"
//#import "AILogCenter.h"
//
#define BUTTONITEM_HEIGHT 24
#define BUTTONITEM_UP_SPACE 0
#define BUTTONITEM_DOWN_SPACE 12
#define BUTTONITEM_LEFT_SPACE 0
#define BUTTONITEM_RIGHT_SPACE 11

#define BUTTONITEM_FONT_LEFT 10
#define BUTTONITEM_FONT_RIGHT 10
#define BUTTONITEM_FONT_SIZE 14.0f


#define POPULAR_KEY_MIN_COUNT  12

@interface PopularSearchViewController ()<UITableViewDataSource,UITableViewDelegate,SearchHistoryCellDelegate>
{
    NSMutableArray * _popularArray;
    NSArray * _historyArray;
    NSInteger _menuIndex;
    NSUInteger _currentPage;

    BOOL _history;
    
    
    NSInteger _popularSearchBGIndex;
    
    CGFloat offSetY;
}
@end

@implementation PopularSearchViewController
@synthesize pageCount=_pageCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    _popularArray =
    
    
    
    NSMutableArray* tmpArray = [[NSUserDefaults standardUserDefaults] objectForKey:SearchHotKey];
    _popularArray = [NSMutableArray arrayWithCapacity:50];
    if (tmpArray && tmpArray.count > 0) {
        for (NSInteger i = 0 ; i < tmpArray.count ; i ++) {
            NSString* key = [tmpArray objectAtIndex:i];
            if (i < 50) {
                [_popularArray addObject:key];
            }
        }
    }
    else {
 
    }
   
    _popularSearchBGIndex = 0;
//    self.menuLine.backgroundColor = [UIColor colorForHex:@"#007aff"];
    self.menuView.layer.borderWidth = 1;
    self.menuView.layer.borderColor = [UIColor colorForHex:@"#007aff"].CGColor;
    self.menuView.backgroundColor = [UIColor whiteColor];
    self.menuView.layer.masksToBounds = YES;
    self.menuView.layer.cornerRadius = 3;
    DLog(@"size.width : %f",AI_SCREEN_WIDTH);
    self.resultView.contentSize = CGSizeMake(AI_SCREEN_WIDTH * 2, self.view.frame.size.height);
    [self.showResultView removeFromSuperview];
    [self.getMoreButton removeFromSuperview];
    [self.resultTableView removeFromSuperview];

    self.resultTableView.frame = CGRectMake(AI_SCREEN_WIDTH+self.resultTableView.frame.origin.x,
                                            40,
                                            [UIScreen mainScreen].bounds.size.width,
                                            [UIScreen mainScreen].bounds.size.height - 40-64);
    DLog(@"y = %f,h = %f",self.resultTableView.frame.origin.y,self.resultTableView.frame.size.height);
    [self.resultView addSubview:self.showResultView];
    [self.resultView addSubview:self.getMoreButton];
    [self.resultView addSubview:self.resultTableView];
    
    [self.resultView setDelegate:self];
    [self.resultView setPagingEnabled:YES];
    [self.resultView setBounces:NO];
    [self.resultView setShowsHorizontalScrollIndicator:NO];
    [self.resultView setShowsVerticalScrollIndicator:NO];
    self.resultView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _currentPage = 0;
    [self setPageCount:2];
    
    [self.resultView addObserver:self forKeyPath:@"frame" options:0 context:NULL];
    self.resultView.scrollsToTop = NO;

    
    _history = YES;
    [self menuButtonAction:self.hotButton];
    
    [_getMoreButton setBackgroundImage:[UIImage storeImageNamed:@"change_pouplarkey_button_normal.png"] forState:UIControlStateNormal];
    
    [_getMoreButton setBackgroundImage:[UIImage storeImageNamed:@"change_pouplarkey_button_press.png"] forState:UIControlStateHighlighted];
    
    
    
    //    [_popularSearchesService startAsynchronous];
    
    self.getMoreButton.hidden = NO;
    self.showResultView.hidden = NO;
    self.resultTableView.scrollsToTop = NO;
    self.resultView.scrollsToTop = NO;
    
    [self showButtonItem];
    self.resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}



- (IBAction)getMoreButtonAction:(id)sender {
    
    if ([_popularArray count] < POPULAR_KEY_MIN_COUNT) {
        //        self.getMoreButton.hidden = YES;
        self.getMoreButton.enabled = NO;
    }
    else{
        [self showButtonItem];
    }
    [_textField resignFirstResponder];
    
}

#pragma mark - private method
- (void) showButtonItem
{
    //    DLog(@"%f,%f. %f, %f",self.showResultView.frame.size.width, self.showResultView.frame.size.height,(self.showResultView.frame.size.height + BUTTONITEM_DOWN_SPACE)/(BUTTONITEM_HEIGHT + BUTTONITEM_DOWN_SPACE), floor((self.showResultView.frame.size.height + BUTTONITEM_DOWN_SPACE)/(BUTTONITEM_HEIGHT + BUTTONITEM_DOWN_SPACE)));
    
    
    for(UIView *subview in [self.showResultView subviews]) {
        [subview removeFromSuperview];
    }
    if (_popularArray.count <= 0) {
        return;
    }
    
    
    NSInteger deleteIndex = _menuIndex;
    
    CGFloat widthRemainder = self.showResultView.frame.size.width;  //横向剩余
    //    CGFloat heightRemainder = self.showResultView.frame.size.height; //纵向剩余
    
    NSInteger itemCount = 0;
    for (NSInteger heightNum = 0; heightNum < (self.showResultView.frame.size.height + BUTTONITEM_DOWN_SPACE)/(BUTTONITEM_HEIGHT + BUTTONITEM_DOWN_SPACE) - 1; heightNum++) {
        //        DLog(@"zzz %d, _popularArray: %@", heightNum, _popularArray[popluarIndex++]);
        
        CGFloat originX = 0;
        widthRemainder = self.showResultView.frame.size.width;
        
        while (true) {
            
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.titleLabel.font = [UIFont systemFontOfSize:BUTTONITEM_FONT_SIZE];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [button setTitle:_popularArray[deleteIndex % [_popularArray count]] forState:UIControlStateNormal];
            [button setFrame:CGRectMake(originX, heightNum*(BUTTONITEM_HEIGHT + BUTTONITEM_DOWN_SPACE), 100, BUTTONITEM_HEIGHT)];
            
            
            
            CGSize textSize = [button.titleLabel.text sizeWithFont:button.titleLabel.font
                                                 constrainedToSize:CGSizeMake(CGFLOAT_MAX, 26)];
            
            CGRect frame = button.frame;
            CGFloat width = textSize.width + BUTTONITEM_FONT_LEFT + BUTTONITEM_FONT_RIGHT;
            CGFloat nextWidth = [_popularArray[(deleteIndex + 1) % [_popularArray count]] sizeWithFont:button.titleLabel.font
                                                                                     constrainedToSize:CGSizeMake(CGFLOAT_MAX, 26)].width + BUTTONITEM_FONT_LEFT + BUTTONITEM_FONT_RIGHT;
            frame.size.width = width > 90 || (originX == (90 + BUTTONITEM_RIGHT_SPACE) && nextWidth > 90)? 180 +  BUTTONITEM_RIGHT_SPACE: 90;
            
            button.frame = frame;
            
            UIImage* backImage = [UIImage storeImageNamed:@"change_pouplarkey_button_normal.png"];
            UIImage* pressImage = [UIImage storeImageNamed:@"change_pouplarkey_button_press.png"];
            
            [button setBackgroundImage:[backImage stretchableImageWithLeftCapWidth:4 topCapHeight:4]forState:UIControlStateNormal];
            [button setBackgroundImage:[pressImage stretchableImageWithLeftCapWidth:4 topCapHeight:4]forState:UIControlStateHighlighted];
            [button setBackgroundImage:[pressImage stretchableImageWithLeftCapWidth:4 topCapHeight:4]forState:UIControlStateSelected];
            
            if (frame.size.width <= widthRemainder ) {
                [self.showResultView addSubview:button];
                
                widthRemainder = widthRemainder - frame.size.width - BUTTONITEM_RIGHT_SPACE;
                
                originX += frame.size.width + BUTTONITEM_RIGHT_SPACE;
                
                deleteIndex++;
                
                [button addTarget:self action:@selector(buttonPushAction:) forControlEvents:UIControlEventTouchUpInside];
                itemCount ++;
                _popularSearchBGIndex++;
                _popularSearchBGIndex %=9;
                
            }
            else{
                break;
            }
        }
    }
    _menuIndex = deleteIndex % [_popularArray count];
    
    
}

- (void) buttonPushAction:(id)sender
{
    NSString* keyword = ((UIButton*)sender).titleLabel.text;


    if ([keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(didSearchPolularSearch:)]) {
            [self.delegate didSearchPolularSearch:keyword];
        }
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _historyArray = [self getSearchHistoryArray];
    [self.resultTableView reloadData];
//    [_popularArray removeAllObjects];
//
//    [_popularSearchesService startAsynchronous];
        [self getMoreButtonAction:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadHistory {
    _history = YES;
    [self menuButtonAction:self.hotButton];
}

- (IBAction)menuButtonAction:(UIButton*)button {
    [self menuButtonPressed:button fromButton:YES];
}

-(void) menuButtonPressed:(UIButton*)button fromButton:(BOOL)fromBtn{
    [_textField resignFirstResponder];
    
    if (button.tag == 1) {
        if (!_history) {
            return;
        }
        _history = NO;
        self.hotButton.backgroundColor = [UIColor colorForHex:@"#007aff"];
        [self.hotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.historyButton.backgroundColor = [UIColor whiteColor];
        [self.historyButton setTitleColor:[UIColor colorForHex:@"#007aff"] forState:UIControlStateNormal];
        if (fromBtn) {
            [self.resultView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
    }
    else{
        if (_history) {
            return;
        }
        _history = YES;
        _historyArray = [self getSearchHistoryArray];
        //        [self.resultTableView reloadData];
        self.historyButton.backgroundColor = [UIColor colorForHex:@"#007aff"];
        [self.historyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.hotButton.backgroundColor = [UIColor whiteColor];
        [self.hotButton setTitleColor:[UIColor colorForHex:@"#007aff"] forState:UIControlStateNormal];
        if (fromBtn) {
            [self.resultView setContentOffset:CGPointMake(AI_SCREEN_WIDTH, 0) animated:YES];
        }
        
    }
    [self.resultTableView reloadData];
    self.resultTableView.contentOffset = CGPointZero;
}

- (void)setBtnEnable:(BOOL)enable {
    self.hotButton.enabled = enable;
    self.historyButton.enabled = enable;
}

#pragma mark - UIScrollViewDelegate
-(void)setSegmentWithPage:(NSInteger)page
{
    UIButton* emptyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    emptyBtn.tag=page+1;
    [self menuButtonPressed:emptyBtn fromButton:NO];
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSUInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (page != _currentPage){
        _currentPage = page;
        [self setSegmentWithPage:_currentPage];
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    offSetY = scrollView.contentOffset.y;

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    DLog(@"%d %d %f %f %f",page,_currentPage,scrollView.contentOffset.x,scrollView.contentOffset.y,offSetY);
    if (offSetY == scrollView.contentOffset.y) {
        if (page != _currentPage){
            _currentPage = page;
            [self setSegmentWithPage:_currentPage];
        }
    }

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![keyPath isEqualToString:@"frame"])
        return;
    [self setPageCount:_pageCount];
    DLog(@"%d",_pageCount);
}
- (void)setPageCount:(NSUInteger)count{
    [self.resultView setContentSize:(CGSize){count * AI_SCREEN_WIDTH, self.view.frame.size.height}];
    _pageCount = count;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_textField resignFirstResponder];
}
#pragma mark = AINetworkServiceDelegate

//- (void)service:(AINetworkService *)service succeededWithResult:(NSArray *)result
//{
//    NSMutableArray* hots = [[NSMutableArray alloc] init];
//    for (NSDictionary* dict in result) {
//        [_popularArray addObject:[dict  safeObjectForKey:@"key"]];
//        [hots addObject:[dict  safeObjectForKey:@"key"]];
//    }
//    [[NSUserDefaults standardUserDefaults] setObject:hots forKey:SearchHotKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    if (self.showResultView.subviews.count == 0) {
//        [self showButtonItem];
//    }
//}
//
//- (void)service:(AINetworkService *)service failedWithError:(NSError *)error
//{
//
//    AICustomizedMBProgressHud *hud = [AICustomizedMBProgressHud showHUDAddedTo:self.view type:AI_HudType_Warning animated:YES];
//    hud.removeFromSuperViewOnHide = YES;
//    [hud setLabelText:@"请检查您的网络"];
//    [hud hide:YES afterDelay:3];
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textField resignFirstResponder];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _historyArray.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AISearchHistoryCell";
    
    AISearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[AISearchHistoryCell alloc]init];
    }
    BOOL end = indexPath.row == _historyArray.count;
    if ((indexPath.row < _historyArray.count)){//(indexPath.row < _popularArray.count && !_history) ||
        cell.titleLabel.text = _historyArray[indexPath.row];//_history ? _historyArray[indexPath.row] : _popularArray[indexPath.row];
    }
    else if (end) { //&& _history
        if (_historyArray.count == 0) {
            cell.titleLabel.text = @"无搜索记录";
        }
        else {
            cell.titleLabel.text = @"清除搜索记录";
        }
        
    }
//    if (!_history) {
//        CGRect frame = cell.titleLabel.frame;
//        frame.origin.x = 20;
//        cell.titleLabel.frame = frame;
//    }
//    else {
    CGRect frame = cell.titleLabel.frame;
    frame.origin.x = 40;
    frame.size.width=AI_SCREEN_WIDTH-80;
    cell.titleLabel.frame = frame;
//    }
    cell.icon.hidden = end;//(end && _history) || !_history;
    cell.deleteBtn.hidden = end;//(end && _history) || !_history;
    cell.titleLabel.textAlignment = end  ? UITextAlignmentCenter : UITextAlignmentLeft;//&& _history
    cell.deleteDelegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_history && indexPath.row == _historyArray.count) {
        _historyArray = [self changeHistoryArrayWithKey:nil add:NO];
        [self.resultTableView reloadData];
        return;
    }
    //    self.selectedIndexPath = indexPath;
    if ((indexPath.row > _popularArray.count && !_history) ||(indexPath.row > _historyArray.count && _history)) {
        return;
    }
    AISearchHistoryCell *cell = (AISearchHistoryCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString* keyword = cell.titleLabel.text;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSearchPolularSearch:)]) {
        [self.delegate didSearchPolularSearch:keyword];
    }
    
}

-(void)onDeleteItemWithKey:(NSString *)key {
    _historyArray = [self changeHistoryArrayWithKey:key add:NO];
    [self.resultTableView reloadData];
}

-(NSArray*)changeHistoryArrayWithKey:(NSString*)key add:(BOOL)add {
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
    return tmp;
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
    return 40;
}

-(void)dealloc {
    self.resultTableView.dataSource = nil;
    self.resultTableView.delegate = nil;
    self.resultTableView = nil;
    [self.resultView removeObserver:self forKeyPath:@"frame"];
    self.resultView=nil;
    self.textField = nil;
}

@end
