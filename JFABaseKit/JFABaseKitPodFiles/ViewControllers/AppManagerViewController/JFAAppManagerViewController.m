//
//  JFAAppManagerViewController.m
//  JFAAppStoreHelper
//
//  Created by 魏星 on 15/9/8.
//  Copyright © 2015年 JF. All rights reserved.
//

#import "JFAAppManagerViewController.h"

@interface JFAAppManagerViewController ()

@end

@implementation JFAAppManagerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSegmentView];
//    self.title = @"软件";
    // Do any additional setup after loading the view.
}
-(NSString *)iconImageName
{
    NSString * imageName = @"tabbar_game@3x.png";
    return imageName;
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
