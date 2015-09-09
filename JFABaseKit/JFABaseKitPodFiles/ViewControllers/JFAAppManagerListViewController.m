//
//  JFAAppManagerListViewController.m
//  JFAAppStoreHelper
//
//  Created by 魏星 on 15/9/8.
//  Copyright © 2015年 JF. All rights reserved.
//

#import "JFAAppManagerListViewController.h"
#import "JFAAppManagerItem.h"
#import "JFAAppDetailViewController.h"
@interface JFAAppManagerListViewController ()

@end

@implementation JFAAppManagerListViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}
-(NSString*)getTableRequestUrl
{
    return JFAGetHotList;
}

-(JFANetWorkServiceItem*)getServiceItem
{
    JFANetWorkServiceItem* item=[[JFANetWorkServiceItem alloc] init];
    item.url=[self getTableRequestUrl];
    
    [item.parameters setObject:@"1" forKey:@"device"];
    [item.parameters setObject:[NSString stringWithFormat:@"%d",self.currentPage] forKey:@"page"];
    [item.parameters setObject:[NSString stringWithFormat:@"%ld",(long)[self getPageSize]] forKey:@"size"];
    return item;
}

-(NSArray*)getDataArrayWithResult:(id)result
{
    NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:result options:0 error:NULL];
    DLog(@"%@",jsonResult);
    
    NSDictionary* dataDic=[jsonResult safeObjectForKey:@"data"];
    NSArray* appInfoArray=[dataDic safeObjectForKey:@"result"];
    NSMutableArray* tempArray=[[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary* dic in appInfoArray) {
        JFAAppManagerItem* item=[[JFAAppManagerItem alloc] init];
        [item setupWithData:dic];
        item.selected=^(JFATableCellItem* item){
            JFAAppDetailViewController *appdetail = [[JFAAppDetailViewController alloc]init];
            [self.jfa_navigationController pushViewController:appdetail];
             };
        [tempArray addObject:item];
    }
    return tempArray;
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
