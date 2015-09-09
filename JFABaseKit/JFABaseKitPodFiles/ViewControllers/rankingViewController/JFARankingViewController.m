//
//  JFARankingViewController.m
//  JFAAppStoreHelper
//
//  Created by 魏星 on 15/9/8.
//  Copyright © 2015年 JF. All rights reserved.
//

#import "JFARankingViewController.h"
#import "JFAAppDetailViewController.h"

@interface JFARankingViewController ()

@end

@implementation JFARankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"排行";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(asdfas:) name:@"123" object:nil];
    
    for (int i = 0; i<self.viewControllers.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(JFA_SCREEN_WIDTH/self.viewControllers.count*(i), 0, JFA_SCREEN_WIDTH/self.viewControllers.count, 40)];
        [button addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        [button setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        [self.segmentView addSubview:button];
    }
    
}
-(NSString *)iconImageName
{
    NSString * imageName = @"tabbar_free@3x.png";
    return imageName;
}
-(void)asdfas:(NSNotification *)no
{
    JFAAppDetailViewController *appdetail = [[JFAAppDetailViewController alloc]init];
    [self.navigationController pushViewController:appdetail animated:YES];

}

-(void)changePage:(UIButton *)sender
{
    [self setSelectedAt:sender.tag-100];
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
