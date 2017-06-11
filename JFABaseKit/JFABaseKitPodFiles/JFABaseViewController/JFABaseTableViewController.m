
//
//  JFABaseTableViewController.m
//  JFABaseKit
//
//  Created by stefan on 15/8/27.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import "JFABaseTableViewController.h"
#import "MBProgressHUD.h"
@interface JFABaseTableViewController ()

@end

@implementation JFABaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTableView];
    
    self.view.backgroundColor=[self getViewBackColor];
    
    self.tbDataArray=[[NSMutableArray alloc] initWithCapacity:0];
    
}
#pragma mark-PropertyForSubViews

-(NSInteger)getPageSize
{
    return 15;
}

-(CGFloat)getBottomViewHeight
{
    return 49;
}

-(UIColor*)getViewBackColor
{
    return [UIColor colorForHex:@""];
}
#pragma mark-initSubViews

-(void)initLoadingView
{
    [self initLoadingViewWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT-[self getBottomViewHeight]-self.navBarHeight)];
}

-(void)initTableView
{
    if (!self.tableView) {
        self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT-self.getBottomViewHeight-self.navBarHeight) style:UITableViewStylePlain];
        DLog(@"%f",self.tableView.frame.size.height);
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator=NO;
        _tableView.showsVerticalScrollIndicator=NO;
        [self setExtraCellLineHidden:_tableView];
    }
    
    [self.view addSubview:_tableView];
}

#pragma mark-
-(void)initErrorViewWithFrame:(CGRect)frame
{
    if (!self.errorView) {
        self.errorView=[[ServiceResultErrorView alloc] initWithFrame:frame];
    }
    
    [self.view insertSubview:self.errorView belowSubview:self.tableView];
}

- (void)continueAnimate{
    [super continueAnimate];
    self.tableView.hidden=YES;
}

- (void)stopAnimate{
    [super stopAnimate];
    self.isReloading=NO;
    self.tableView.hidden=NO;
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark-MJRefresh
-(void)setMJRefresh
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader* header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden=YES;
    self.tableView.mj_header = header;
}

-(NSString*)getTableRequestUrl
{
    return nil;
}

-(void)loadNewData
{
    if (!self.isTableLoading&&[self getTableRequestUrl]) {
        self.currentPage=1;
        [self continueAnimate];
        self.isReloading=YES;
        self.isTableLoading=YES;
        self.tableView.mj_footer.hidden = NO;
        DLog(@"开始刷新");
        [self startService];
    }else{
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }
}

#pragma mark-LoadMore

-(void)setLoadMore
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.hidden=YES;
}

-(void)loadMoreData
{
    _currentPage++;
    [self startService];
}

#pragma mark-tableViewDelegate
-(BOOL)isSelectionStyleNone
{
    return NO;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tbDataArray count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JFATableCellItem* item=[_tbDataArray objectAtIndex:indexPath.row];
    return [item cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JFATableCellItem* item=[_tbDataArray objectAtIndex:indexPath.row];
    
    NSString* cellIdentification=[item cellXibName]?[item cellXibName]:[item cellClassName];
    
    JFATableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellIdentification];
    
    if (!cell&&[item cellXibName]) {
        cell=[[[NSBundle mainBundle] loadNibNamed:[item cellXibName] owner:self options:0] objectAtIndex:0];
    }
    
    if (!cell&&[item cellClassName]) {
        cell=[[NSClassFromString(cellIdentification) alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentification];
    }

    if ([self isSelectionStyleNone]) {
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if ([item isKindOfClass:[JFATableCellItem class]]) {
        [cell updateCell:item];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JFATableCellItem* item=[_tbDataArray objectAtIndex:indexPath.row];
    [self hidesBottomBarWhenPushed];
    if (item.selected) {
        item.selected(item);
        
    }
}

-(void)reloadTableViewWithIndex:(NSInteger)index
{
    NSIndexPath* indexPath=[NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark-NetworkService
//解析listView 组装tbDataArray
-(NSArray*)getDataArrayWithResult:(id)result
{
    return nil;
}

-(void)updateTableViewDataSourceWithData:(id)data operation:(NSURLSessionTask *)operation

{
    NSArray* dataArray=[self getDataArrayWithResult:data];
    [self serviceWithResult:dataArray operation:operation];
}

-(void)serviceSucceededWithResult:(id)result operation:(NSURLSessionTask *)operation
{
    DLog(@"%@",result);
    if ([self isEqualUrl:[self getServiceItem].url forOperation:operation]) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSArray* listArray=[result objectForKey:@"list"];
            if (listArray) {
                [self updateTableViewDataSourceWithData:listArray operation:operation];
                return;
            }
        }
        [self updateTableViewDataSourceWithData:result operation:operation];
    }
}

-(void)serviceFailedWithError:(NSError *)error operation:(NSURLSessionTask *)operation
{
    if ([self isEqualUrl:[self getTableRequestUrl] forOperation:operation]) {
        if (!self.isReloading) {
            self.currentPage--;
        }
    }
    [self serviceWithResult:nil operation:operation];
}

- (void)serviceWithResult:(NSArray *)result operation:(NSURLSessionTask *)operation
{
    if (result) {
        self.tableView.mj_footer.hidden=[result count]<[self getPageSize]?YES:NO;
        self.tableView.mj_footer.hidden = YES;
        if ([result count]<=0) {
            [self showError];
        }else{
            [self refreshTableViewWithDataArray:result];
        }
    }else{
        [self showNetworkError];
    }
    if ([self isEqualUrl:[self getTableRequestUrl] forOperation:operation]) {
        _isTableLoading=NO;
    }
}
-(void)reloadTableViewData
{
    if (self.isReloading) {
        [self.tbDataArray removeAllObjects];
    }
    [self.tableView reloadData];
}
-(void)refreshTableViewWithDataArray:(NSArray*)dataArray
{
    self.networkErrorView.hidden=YES;
    self.errorView.hidden=YES;
    self.tableView.hidden=NO;
    if (self.isReloading) {
        [self.tbDataArray removeAllObjects];
    }
    [self.tbDataArray addObjectsFromArray:dataArray];
    [self.tableView reloadData];
    [self stopAnimate];
}

-(void)showNetworkError
{
    [self reloadTableViewData];
    if (_tbDataArray.count) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view
                                                  animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"加载失败";
        [hud hide:YES afterDelay:1];

    }else{
    [super showNetworkError];
    self.tableView.hidden=YES;
    }
}

-(void)refreshForNetworkError
{
    [self loadNewData];
}

-(void)showError
{
    [self reloadTableViewData];
    [super showError];
    if ([self.tbDataArray count]>0) {
        self.errorView.hidden=YES;
        self.networkErrorView.hidden=YES;
    }
}

-(void)presentInViewLikeNavigationBarWithTitle:(NSString *)title isWhite:(BOOL)iswhite
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,JFA_SCREEN_WIDTH,  IOS7_OR_LATER?64:44)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, IOS7_OR_LATER?27:7, 50, 30)];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:iswhite?[UIColor whiteColor]:[UIColor colorForHex:@"#007aff"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissSuperViewController) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, IOS7_OR_LATER?27:7, 150, 30)];
    titleLabel.center = CGPointMake(view.center.x, titleLabel.center.y);
    titleLabel.text = title;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, IOS7_OR_LATER?63.5f:43.5f,JFA_SCREEN_WIDTH,  0.5f)];
    
    lineView.backgroundColor = [UIColor blackColor];
    [view addSubview:lineView];
    [self.view addSubview:view];
}
-(void)dismissSuperViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
-(void)BrokenNetworkReconnection
{
    [super BrokenNetworkReconnection];
    [self loadNewData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
