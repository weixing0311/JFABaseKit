//
//  JFARecommonTableViewController.m
//  JFAAppStoreHelper
//
//  Created by 魏星 on 15/9/8.
//  Copyright © 2015年 JF. All rights reserved.
//

#import "JFARecommonTableViewController.h"
#import "JFARecommonTableViewItem.h"
#import "IIBannerView.h"

@interface JFARecommonTableViewController ()
@property(nonatomic,strong)UIView * searchView;
@end

@implementation JFARecommonTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initLoadingView];
    
    [self setMJRefresh];
    
    [self setLoadMore];
    
    [self loadNewData];
    self.title = @"热门";
    
    IIBannerView  *bannerView = [[IIBannerView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 150)];
    self.tableView.tableHeaderView = bannerView;
    
    
}
-(NSString *)iconImageName
{
    NSString * imageName = @"tabbar_home@3x.png";
    return imageName;
}

-(void)createDefaultNavigationBar
{
    [super createDefaultNavigationBar];
    self.jfa_navigationBar.title.hidden = YES;
    self.jfa_navigationBar.rightButton.hidden = NO;
    [self.jfa_navigationBar.rightButton setImage:[[UIImage storeImageNamed:@"downloadIcon@3x"] scaledImageFrom3x]
                                        forState:UIControlStateNormal];
    [self.jfa_navigationBar.rightButton addTarget:self
                                           action:@selector(tapDownloadButton)
                                 forControlEvents:UIControlEventTouchUpInside];
    
    AISearchViewToNaviBar *searchView = [[AISearchViewToNaviBar alloc]init];
    CGRect frame = searchView.frame;
    frame.size.width = AI_SCREEN_WIDTH - self.jfa_navigationBar.rightButton.frame.size.width + 12;
    searchView.frame = frame;
    searchView.searchContainer.frame=CGRectMake(10,8,searchView.frame.size.width-30, 29);
    [searchView showCancelButton:NO animation:NO completion:nil];
    if (IOS7_OR_LATER) {
        searchView.textField.tintColor = AI_MAIN_BLUECOLOR;
    }
    searchView.cancelBtn.hidden = YES;
    searchView.delegate = self;
    [self.jfa_navigationBar.contentView addSubview:searchView];
    self.searchView = searchView;

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
        JFARecommonTableViewItem* item=[[JFARecommonTableViewItem alloc] init];
        [item setupWithData:dic];
        item.selected=^(JFATableCellItem* item){
            
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
