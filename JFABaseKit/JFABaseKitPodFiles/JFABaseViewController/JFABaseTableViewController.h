//
//  JFABaseTableViewController.h
//  JFABaseKit
//
//  Created by stefan on 15/8/27.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import "JFABaseViewController.h"
#import "JFATableCellItem.h"
#import "JFATableViewCell.h"

@interface JFABaseTableViewController : JFABaseViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSMutableArray* tbDataArray;

@property(nonatomic,assign)BOOL isReloading;
@property(nonatomic,assign)int currentPage;
@property(nonatomic,assign)BOOL isTableLoading;//tableview加载数据锁，默认为NO

-(NSString*)getTableRequestUrl;
-(BOOL)isSelectionStyleNone;

-(void)setMJRefresh;
-(void)loadNewData;
-(void)setLoadMore;
-(void)loadMoreData;
-(void)continueAnimate;
-(void)stopAnimate;
-(void)reloadTableViewWithIndex:(NSInteger)index;
-(void)refreshTableViewWithDataArray:(NSArray*)dataArray;
-(void)serviceWithResult:(NSArray *)result operation:(AFHTTPRequestOperation *)operation;
//解析listView 组装tbDataArray
-(NSArray*)getDataArrayWithResult:(id)result;
-(void)reloadTableViewData;

-(NSInteger)getPageSize;
-(CGFloat)getBottomViewHeight;
-(UIColor*)getViewBackColor;

-(void)presentInViewLikeNavigationBarWithTitle:(NSString *)title isWhite:(BOOL)iswhite;


@end
