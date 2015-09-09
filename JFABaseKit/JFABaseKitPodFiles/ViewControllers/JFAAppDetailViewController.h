//
//  JFAAppDetailViewController.h
//  JFAAppStoreHelper
//
//  Created by 魏星 on 15/9/8.
//  Copyright © 2015年 JF. All rights reserved.
//

#import "ViewControllerWithCustomNavigationBar.h"
#import "AppDetailView.h"
#import "App.h"

@interface JFAAppDetailViewController : ViewControllerWithCustomNavigationBar
{
    UIScrollView *scrollView;
    AppDetailView *detailView;
//    AppCommentsView *commentsView;
}
@property (nonatomic, strong) NSString *parentServiceBaseURLKey;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) App *app;
@property (nonatomic, retain) NSString *sourceID;
@property (nonatomic, assign) BOOL isUpdatingApp;
@property (nonatomic, assign) BOOL fromDownload;
@property (nonatomic, assign) JFAAppDetailViewController* rootDetailVC;
@property (nonatomic, strong) NSString *logid;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString* parent;
@property (nonatomic, assign) BOOL isTopController;
@property (nonatomic, strong) UIButton * downloadBtn;
@property (nonatomic, assign) BOOL isOffical;

@end
