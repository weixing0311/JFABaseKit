//
//  JFARankingListViewController.m
//  JFAAppStoreHelper
//
//  Created by 魏星 on 15/9/8.
//  Copyright © 2015年 JF. All rights reserved.
//

#import "JFARankingListViewController.h"
#import "JFARankingItem.h"
@interface JFARankingListViewController ()

@end

@implementation JFARankingListViewController

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
        JFARankingItem* item=[[JFARankingItem alloc] init];
        [item setupWithData:dic];
        item.selected=^(JFATableCellItem* item){
          
             [[NSNotificationCenter defaultCenter]postNotificationName:@"123" object:nil];

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
