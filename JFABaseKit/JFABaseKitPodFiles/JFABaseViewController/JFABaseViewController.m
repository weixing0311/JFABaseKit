//
//  JFABaseViewController.m
//  JFABaseKit
//
//  Created by stefan on 15/8/27.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import "JFABaseViewController.h"

@interface JFABaseViewController ()

@end

@implementation JFABaseViewController
@synthesize requestArray=_requestArray;
@synthesize loadingView=_loadingView;
@synthesize errorView=_errorView;
@synthesize networkErrorView=_networkErrorView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.edgesForExtendedLayout= UIRectEdgeNone;
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorForHex:@"E82356"]];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    if (!self.requestArray) {
        self.requestArray=[[NSMutableArray alloc] initWithCapacity:0];
    }
}


-(void)dealloc
{
    for (AFHTTPRequestOperation* operation in self.requestArray) {
        if ([operation isKindOfClass:[AFHTTPRequestOperation class]]) {
            [operation cancel];
        }
    }
}

#pragma mark-CustomView
//-(void)initNetworkErrorViewWithType:(STErrorViewType)type frame:(CGRect)frame
//{
//    STNetworkErrorView* errorView=[[STNetworkErrorView alloc] initWithFrame:frame type:type];
//    errorView.delegate=self;
//    errorView.backgroundColor=self.view.backgroundColor;
//    self.networkErrorView=errorView;
//    [self.view addSubview:_networkErrorView];
//}
//

-(void)refreshForNetworkError
{
    [self startService];
}

//-(void)initErrorViewWithType:(STErrorViewType)type frame:(CGRect)frame
//{
//    STErrorView* errorView=[[STErrorView alloc] initWithFrame:frame type:type];
//    errorView.backgroundColor=self.view.backgroundColor;
//    self.errorView=errorView;
//    [self.view addSubview:_errorView];
//}

-(void)initLoadingView
{
    [self initLoadingViewWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT-49-self.navBarHeight)];
}

-(void)initLoadingViewWithFrame:(CGRect)frame
{
    if (!self.loadingView) {
        self.loadingView=[[JFALoadingView alloc] initWithFrame:frame];
    }
    self.loadingView.backgroundColor=self.view.backgroundColor;
    [self.view addSubview:_loadingView];
}

- (void)continueAnimate{
    if(_loadingView){
        [_loadingView startloading];
    }
    if (_errorView) {
        self.errorView.hidden=YES;
    }
    if (_networkErrorView) {
        self.networkErrorView.hidden=YES;
    }
}

- (void)stopAnimate{
    if(_loadingView){
        [_loadingView stoploading];
    }
}

#pragma mark - Config Top Bar Button

-(void)configLeftEmptyButton
{
    UIView* view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    view.backgroundColor=[UIColor clearColor];
    self.navigationItem.leftBarButtonItems= @[[[UIBarButtonItem alloc] initWithCustomView:view]];
}


-(UIImage*)backImage
{
    return [UIImage imageNamed:@"return"];
}

- (void)configBackButton
{
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[self backImage] forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 17, 25);
    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)configRightButtonWithTitle:(NSString*)title
                            target:(id)target
                          selector:(SEL)selector
{
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.frame=CGRectMake(0, 0, 60, 32);
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:button];
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configRightBarButtonWithImage:(UIImage*)image
                               target:(id)target
                             selector:(SEL)selector
{
    
    [self configRightBarButtonWithImage:image
                                 target:target
                               selector:selector
                                  frame:CGRectMake(0, 0, 32, 32)];
}

- (void)configRightBarButtonWithImage:(UIImage*)image
                               target:(id)target
                             selector:(SEL)selector
                                frame:(CGRect)frame
{
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target
               action:selector
     forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    button.frame=frame;
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)configLeftBarButtonWithImage:(UIImage*)image
                              target:(id)target
                            selector:(SEL)selector
{
    [self configLeftBarButtonWithImage:image
                                target:target
                              selector:selector
                                 frame:CGRectMake(0, 0, 32, 32)];
}

- (void)configLeftBarButtonWithImage:(UIImage*)image
                              target:(id)target
                            selector:(SEL)selector
                               frame:(CGRect)frame
{
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target
               action:selector
     forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image
            forState:UIControlStateNormal];
    button.frame=frame;
    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:button];
}



- (void)configRightBarButtonWithCustomView:(UIView*)aView
{
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:aView];
}

- (void)configLeftBarButtonWithCustomView:(UIView*)aView
{
    
    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:aView];
}

#pragma mark - Config Title
- (void)configTitleWithCustomView:(UIView*)customView
{
    self.navigationItem.titleView = customView;
}

- (void)configTitleWithString:(NSString*)title
{
    CGFloat width=[title widthForLabelWithHeight:30 isTextFont:18];
    
    UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width+10, 30)];
    view.backgroundColor=[UIColor clearColor];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, width, 30)];
    titleLabel.font=[UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=title;
    [view addSubview:titleLabel];
    self.navigationItem.titleView = view;
}

-(CGFloat)navBarHeight
{
    return 44+20;
}

#pragma mark-NetService

-(void)loadNewData
{
    [self continueAnimate];
    [self startService];
}

-(JFANetWorkServiceItem*)getServiceItem
{
    return nil;
}

-(void)startService
{
    [self startServiceWithItem:[self getServiceItem] isShowLoading:NO];
}

-(void)startServiceWithItem:(JFANetWorkServiceItem*)item isShowLoading:(BOOL)isShowLoading
{
    
    if (item) {
        AFHTTPRequestOperation* req=nil;
        if ([item.method isEqualToString:@"POST"]) {
            req=[[JFANetWorkService sharedManager] post:item.url paramters:item.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }else{
            req=[[JFANetWorkService sharedManager] get:item.url paramters:item.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
        
        [self.requestArray addObject:req];
    }
}

-(void)serviceSucceededWithResult:(id)result operation:(AFHTTPRequestOperation*)operation
{
    [self stopAnimate];
}

-(void)serviceFailedWithError:(NSError*)error operation:(AFHTTPRequestOperation*)operation
{
    [self showNetworkError];
}

-(BOOL)isEqualUrl:(NSString*)url forOperation:(AFHTTPRequestOperation*)operation
{
    NSString* operationUrl = [operation.request.URL absoluteString];
    NSString* eUrl=[NSString stringWithFormat:@"%@%@",[JFANetWorkService sharedManager].JFADomin,url];
    DLog(@"eUrl==%@  operationUrl==%@",eUrl,operationUrl);
    return [eUrl isEqualToString:operationUrl];
}

-(void)showNetworkError
{
    [self stopAnimate];
    self.errorView.hidden=YES;
    self.networkErrorView.hidden=NO;
}

-(void)showError
{
    [self stopAnimate];
    if (_errorView) {
        self.errorView.hidden=NO;
        self.networkErrorView.hidden=YES;
    }
}

@end
