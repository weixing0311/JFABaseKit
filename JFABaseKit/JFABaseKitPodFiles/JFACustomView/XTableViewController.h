//
//  CTableViewController.h
//  HotelManager
//
//  Created by Tulipa on 14-5-3.
//  Copyright (c) 2014年 Tulipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDTableViewDelegate.h"
#import "XViewController.h"
#import "XTableView.h"

@interface XTableViewController : XViewController <YDTableViewDelegate>

@property (nonatomic, strong) XTableView* tableView;

@property (nonatomic, assign) BOOL enablePullRefresh;

@property (nonatomic, assign) BOOL enableLoadMore;

@property (nonatomic, assign) BOOL isRefreshing;

@property (nonatomic, assign) BOOL isLoadingMore;

@property (nonatomic, strong) UIView* emptyView;

- (Class)tableViewClass;

- (UITableViewStyle)tableViewStyle;

@end
