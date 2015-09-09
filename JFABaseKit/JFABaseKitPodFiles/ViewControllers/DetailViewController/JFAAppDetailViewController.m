//
//  JFAAppDetailViewController.m
//  JFAAppStoreHelper
//
//  Created by 魏星 on 15/9/8.
//  Copyright © 2015年 JF. All rights reserved.
//

#import "JFAAppDetailViewController.h"
#import "AIMPMoviePlayerViewController.h"
#define IMAGE_WALL_SIZE CGSizeMake(296, 356)
#define BOTTOM_VIEW_HEIGHT 44
//#define FOOTER_VIEW_HEIGHT 66
#define LEFT_MARGIN 12.5
#define TOP_MARGIN 5
#define HEAD_HEIGHT 10

@interface JFAAppDetailViewController ()



@end

@implementation JFAAppDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.title = NSLocalizedString(@"应用详情", @"");
    [super viewDidLoad];
    
        [self createDefaultNavigationBar];
        [self.view setBackgroundColor:[UIColor colorForHex:@"#ffffff"]];
    
        self.errorView.frame = CGRectMake(0, SEGMENTED_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - SEGMENTED_BAR_HEIGHT);
        
        [self initLoadingView];
        
//        [self tempInit];
    
    

}


- (void)createDefaultNavigationBar {
    [super createDefaultNavigationBar];
    
    [self.jfa_navigationBar.leftButton removeTarget:self.jfa_navigationController
                                             action:@selector(popViewController)
                                   forControlEvents:UIControlEventTouchUpInside];
    [self.jfa_navigationBar.leftButton addTarget:self
                                          action:@selector(navigationBack:)
                                forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
