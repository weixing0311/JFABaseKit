//
//  AITabBarController.m
//  AppInstallerGreen
//
//  Created by liuweina on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AITabBarController.h"

#import "JFARecommonTableViewController.h"
//#import "SCNavigationBar.h"
#import "BCTab.h"
#import "BCTabBar.h"
#import "BCTabBarView.h"
#import "UIImage+Extension.h"
#import <dlfcn.h>
#import "JFAAppManagerViewController.h"
#import "JFAAppDetailViewController.h"
#import "SearchText.h"
#import "App.h"
#import "SearchManager.h"
#import "JFABaseSegmentViewController.h"
//#import "AIApplicationUtility.h"
#import "AISearchAppListViewController.h"
//#import "AIRetrieveLimitedFreeAppListService.h"
//#import "AIBaseNavigationController.h"
#import "JFAAppDelegateHelper.h"
#import <CoreData/CoreData.h>
//#import "MobClick.h"
#import "JFARankingViewController.h"
#import "UIImage+LocalImage.h"
#import "BaseSearchBarViewController.h"
#import "AISearchAppListViewController.h"
#import "JFARankingListViewController.h"
#import "JFAAppManagerListViewController.h"
@interface AITabBarController () <NSFetchedResultsControllerDelegate>
{
    BOOL pushDownLoadViewLock;
}

@property(nonatomic,strong)JFARecommonTableViewController* controller1;
@property(nonatomic,strong)JFARankingViewController* controller2;
@property(nonatomic,strong)JFAAppManagerViewController* controller3;
@property(nonatomic,strong)JFAAppManagerViewController* controller4;

@end

@implementation AITabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // make sure all settings are loaded first
        _controller1=[[JFARecommonTableViewController alloc] initWithNibName:@"JFARecommonTableViewController" bundle:nil];
        _controller1.title = @"热门";
        
        
        _controller2=[[JFARankingViewController alloc] initWithViewControllers:[self inWithRankingViewControllers] segmentViewHeight:40];
        _controller2.title = @"排行";
        
        _controller3=[[JFAAppManagerViewController alloc] initWithViewControllers:[self inWithManagerViewControllers] segmentViewHeight:40];
        _controller3.title = @"游戏";
        
        _controller4=[[JFAAppManagerViewController alloc] initWithViewControllers:[self inWithManagerViewControllers] segmentViewHeight:40];
        _controller4.title = @"软件";
        
        
        NSArray *viewControllers = @[_controller1,
                                     _controller2,
                                     _controller3,
                                     _controller4];
        [self setViewControllers:viewControllers];
        
     }
    
    return self;
}

//-(void)pushDownloadView:(NSNotification *)notification
//{
//    NSString *boolStr = notification.object;
//    if ([boolStr boolValue]) {
//        [self.jfa_navigationController popViewController];
//    }else{
//        if (!appDownloadViewController) {
//            self.appDownloadViewController = [[AppManagerViewController alloc] init];
//            appDownloadViewController.title = @"下载管理";
//            appDownloadViewController.managedObjectContext = self.managedObjectContext;
//        }
//        if (!pushDownLoadViewLock) {
//            pushDownLoadViewLock=YES;
//         
//            self.appDownloadViewController.indextype = 0;
//            [self.jfa_navigationController pushViewController:self.appDownloadViewController completion:^{
//                pushDownLoadViewLock=NO;
//                
//            }];
//        }
//    }
//
//}
-(NSArray *)inWithRankingViewControllers
{
    JFARankingListViewController *list1 = [[JFARankingListViewController alloc]initWithNibName:@"JFARankingListViewController" bundle:nil];
    JFARankingListViewController *list2 = [[JFARankingListViewController alloc]initWithNibName:@"JFARankingListViewController" bundle:nil];
    JFARankingListViewController *list3 = [[JFARankingListViewController alloc]initWithNibName:@"JFARankingListViewController" bundle:nil];
    JFARankingListViewController *list4 = [[JFARankingListViewController alloc]initWithNibName:@"JFARankingListViewController" bundle:nil];
    NSArray *arr = [NSArray arrayWithObjects:list1,list2,list3,list4, nil];
    return arr;
}
-(NSArray *)inWithManagerViewControllers
{
    JFAAppManagerListViewController *list1 = [[JFAAppManagerListViewController alloc]initWithNibName:@"JFAAppManagerListViewController" bundle:nil];
    JFAAppManagerListViewController *list2 = [[JFAAppManagerListViewController alloc]initWithNibName:@"JFAAppManagerListViewController" bundle:nil];
    JFAAppManagerListViewController *list3 = [[JFAAppManagerListViewController alloc]initWithNibName:@"JFAAppManagerListViewController" bundle:nil];
    JFAAppManagerListViewController *list4 = [[JFAAppManagerListViewController alloc]initWithNibName:@"JFAAppManagerListViewController" bundle:nil];
    NSArray *arr = [NSArray arrayWithObjects:list1,list2,list3,list4, nil];
    return arr;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorForHex:APP_COLOR_3];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setBadge:(NSInteger)badge forTabBarItemAtIndex:(NSInteger)index
{
    BCTab *tab = (BCTab *)[self.tabBar.tabs objectAtIndex:index];
    tab.badge = badge;
}

- (NSString*)tabNameOfSeartch {
    if (_controller1.view.superview) {
        return @"首页";
    }
    else {
        return @"分类";
    }
}

//- (void)receiveSystemNotification:(NSNotification *)notification {
//    NSDictionary *user = notification.userInfo;
//    
//    NSString* type  = [user valueForKey:@"type"];
//    NSString* tmpId = [user valueForKey:@"id"];
//    NSString* url = [user valueForKey:@"url"];
//    if ([type isEqualToString:@"web"] && url && (self.presentingViewController || self.presentedViewController))  {
//        return;
//    }
//    
//    if (IOS7_OR_LATER) {
//        [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    }
//    UIView* shot = [[UIApplication sharedApplication].keyWindow viewWithTag:666888];
//    [shot removeFromSuperview];
//    
//    [self.jfa_navigationController popToRootViewController];
//    
//    
//    if ([type isEqualToString:@"app"]) {
//        [self tabBar:self.tabBar didSelectTabAtIndex:0];
//        [self.presentingViewController dismissViewControllerAnimated:NO completion:^{
//        }];
//        [self.presentedViewController dismissViewControllerAnimated:NO completion:^{
//        }];
//        [_homePageViewController gotoAppDetail:tmpId];
//    }
//    else if ([type isEqualToString:@"topic"]) {
//        [self tabBar:self.tabBar didSelectTabAtIndex:0];
//        [self.presentingViewController dismissViewControllerAnimated:NO completion:^{
//        }];
//        [self.presentedViewController dismissViewControllerAnimated:NO completion:^{
//        }];
//        [_homePageViewController gotoTopicDetail:tmpId title:[user safeObjectForKey:@"title"]];
//    }
//    else if ([type isEqualToString:@"web"] && url) {
//        [self tabBar:self.tabBar didSelectTabAtIndex:0];
//        [[JFAAppDelegateHelper sharedHelper] openWebWith:url];
//    }
//    else if ([type isEqualToString:@"downloaded"])
//    {
//        [MobClick event:@"Downloaded_Enter"];
//        
//        if (!self.appDownloadViewController) {
//            self.appDownloadViewController = [[AppManagerViewController alloc] init];
//            self.appDownloadViewController.title = @"下载管理";
//            self.appDownloadViewController.managedObjectContext = [AIApplicationUtility sharedInstance].managedObjectContext;
//            [self.jfa_navigationController pushViewController:self.appDownloadViewController
//                                                   completion:^{
//                                                       [self.appDownloadViewController showDownloadedUI];
//                                                   }];
//        } else {
//            [self.jfa_navigationController pushViewController:self.appDownloadViewController
//                                                   completion:^{
//                                                       [self.appDownloadViewController showDownloadedUI];
//                                                   }];
//        }
//    }
//}

//- (void)showSettingUI {
//    [self tabBar:self.tabBar didSelectTabAtIndex:4];
//    [_settingVC showRepairUI];
//}

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    [super setSelectedViewController:selectedViewController];
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

//add for Bug 288514
- (void)tabBar:(BCTabBar *)aTabBar didSelectTabAtIndex:(NSInteger)index {
    //    [super tabBar:aTabBar didSelectTabAtIndex:index];
    
//    if (index != 0 && index != 1) {
//        [UncaughtExceptionHandler checkAndUpload];
//    }
    
    UIViewController *vc = [self.viewControllers objectAtIndex:index];
	if (self.selectedViewController == vc) {
		if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
            
            NSArray* array = [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
            
            if ([array count]&& ([[array objectAtIndex:0] isKindOfClass:[AISearchAppListViewController class]])
                &&[((UINavigationController*)vc).topViewController isKindOfClass:[BaseSearchBarViewController class]]) {
                
                BaseSearchBarViewController* baseSearchBarVC = (BaseSearchBarViewController* )((UINavigationController*)vc).topViewController;
                [baseSearchBarVC canelButtonPressAction];
            }
            
		}
	} else {
//        NSArray* vcArray = ((UINavigationController*)vc).viewControllers;
//        [MobClick event:@"Tabbar_Item_Click" label:vc.title];
		self.selectedViewController = vc;
    	}
}


@end
