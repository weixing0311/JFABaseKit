//
//  JFABaseViewController.h
//  JFABaseKit
//
//  Created by stefan on 15/8/27.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFALoadingView.h"
#import "JFASubNetWorkErrorView.h"
#import "ServiceResultErrorView.h"

@interface JFABaseViewController : UIViewController<subNetWorkDelegate>

@property(nonatomic,strong)NSMutableArray* requestArray;
@property(nonatomic,strong)UIView * loadingView;
@property(nonatomic,strong)ServiceResultErrorView * errorView;
@property(nonatomic,strong)JFASubNetWorkErrorView* networkErrorView;

//-(void)initErrorViewWithType:(STErrorViewType)type
//                       frame:(CGRect)frame;
//-(void)initNetworkErrorViewWithType:(STErrorViewType)type
//                              frame:(CGRect)frame;
-(void)initLoadingView;
-(void)initLoadingViewWithFrame:(CGRect)frame;
- (void)continueAnimate;
- (void)stopAnimate;
-(void)refreshForNetworkError;
-(void)configLeftEmptyButton;
-(UIImage*)backImage;
- (void)configBackButton;
- (void)back;
- (void)configRightButtonWithTitle:(NSString*)title
                            target:(id)target
                          selector:(SEL)selector;
- (void)configRightBarButtonWithImage:(UIImage*)image
                               target:(id)target
                             selector:(SEL)selector;
- (void)configRightBarButtonWithImage:(UIImage*)image
                               target:(id)target
                             selector:(SEL)selector
                                frame:(CGRect)frame;
- (void)configLeftBarButtonWithImage:(UIImage*)image
                              target:(id)target
                            selector:(SEL)selector;
- (void)configLeftBarButtonWithImage:(UIImage*)image
                              target:(id)target
                            selector:(SEL)selector
                               frame:(CGRect)frame;
- (void)configRightBarButtonWithCustomView:(UIView*)aView;
- (void)configLeftBarButtonWithCustomView:(UIView*)aView;
- (void)configTitleWithCustomView:(UIView*)customView;
- (void)configTitleWithString:(NSString*)title;

-(CGFloat)navBarHeight;

#pragma mark-NetService
-(void)loadNewData;
-(JFANetWorkServiceItem *)getServiceItem;
-(void)startService;
-(void)startServiceWithItem:(JFANetWorkServiceItem*)item isShowLoading:(BOOL)isShowLoading;
-(void)serviceSucceededWithResult:(id)result operation:(AFHTTPRequestOperation*)operation;
-(void)serviceFailedWithError:(NSError*)error operation:(AFHTTPRequestOperation*)operation;
-(BOOL)isEqualUrl:(NSString*)url forOperation:(AFHTTPRequestOperation*)operation;
-(void)showNetworkError;
-(void)showError;

@end
