//
//  JFAAppDetailViewController.h
//  JFAAppStoreHelper
//
//  Created by 魏星 on 15/9/8.
//  Copyright © 2015年 JF. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface JFAAppDetailViewController : JFABaseTableViewController
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *appicon;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *apptitleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *baseScroller;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *titleView;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *imageScroller;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *contentView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *updataView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *otherInfoView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *likeAboutView;

@end
