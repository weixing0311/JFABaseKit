//
//  ViewControllerWithCustomBackButton.m
//  AppInstaller
//
//  Created by  on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewControllerWithCustomNavigationBar.h"
#import "AIViewFactory.h"
#import "JFANavigationController.h"
#import "JFANavigationBar.h"
#import "UIViewController+JFANavigation.h"
#import "UIImage+LocalImage.h"

@interface ViewControllerWithCustomNavigationBar () {
    
}



@end

@implementation ViewControllerWithCustomNavigationBar

//@synthesize titleView = _titleView;
//@synthesize canSwipeBack = _canSwipeBack;
//@synthesize parentNavigationController = _parentNavigationController;
//@synthesize isBaseNav=_isBaseNav;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]){
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
//        self.canSwipeBack = YES;
//        self.hidesNavigationBarWhenPushed = YES;

    }
    
    return self;
}
-(void)initBackNavLeftBar
{
    self.jfa_navigationBar = [JFANavigationBar baseNavigationBarWithViewController:self];
    [self.jfa_navigationBar.leftButton setImage:[[UIImage storeImageNamed:@"back_button@3x.png"] scaledImageFrom3x] forState:UIControlStateNormal];
    if (!self.isFromDownload) {
        CGRect frame = self.jfa_navigationBar.frame;
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, frame.size.height, frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithWhite:0.929 alpha:1.000];
        [self.jfa_navigationBar addSubview:line];
    }

    self.jfa_navigationBar.leftButton.exclusiveTouch = YES;
    
    self.jfa_navigationBar.title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.jfa_navigationBar.title.font = [UIFont boldSystemFontOfSize:20.0];
    
    [self.view addSubview:self.jfa_navigationBar];
}

- (void)createDefaultNavigationBar {
    [self initBackNavLeftBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [NSThread detachNewThreadSelector:@selector(addTime:) toTarget:[AILogCenter defaultCenter] withObject:self.modelId];
    NSString *logID = [[NSString alloc] init];
    if (self.logid) {
        logID = [NSString stringWithFormat:@"%@",self.logid];
        if (self.isFromAppDetail) {
            logID = [NSString stringWithFormat:@"%@30",self.logid];
        }
        DLog(@"logid = %@",logID);
        self.isFromAppDetail = NO;
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}



- (void)navigationBack:(id)sender
{
    [self.jfa_navigationController popViewController];
}

- (void)didSwipe:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        
        [self navigationBack:self];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
//    _titleView = nil;
//    [self.view removeGestureRecognizer:_swipeGesture];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
