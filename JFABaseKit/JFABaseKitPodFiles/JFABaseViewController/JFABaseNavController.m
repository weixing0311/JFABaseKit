//
//  JFABaseNavController.m
//  JFABaseKit
//
//  Created by stefan on 15/8/27.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import "JFABaseNavController.h"

@interface JFABaseNavController ()

@end

@implementation JFABaseNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)settitleView:(UIView *)view
{
    self.navigationItem.titleView = view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
