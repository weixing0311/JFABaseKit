//
//  JFABaseTableViewPlainViewController.m
//  Pods
//
//  Created by 魏星 on 15/9/9.
//
//

#import "JFABaseTableViewPlainViewController.h"

@interface JFABaseTableViewPlainViewController ()

@end

@implementation JFABaseTableViewPlainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLoadingView];
    
    [self setMJRefresh];
    
    [self setLoadMore];
    
    [self loadNewData];
    // Do any additional setup after loading the view.
}
-(NSString*)getTableRequestUrl
{
    return nil;
}

-(JFANetWorkServiceItem*)getServiceItem
{
    return nil;
}

-(NSArray*)getDataArrayWithResult:(id)result
{
    return nil;
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
