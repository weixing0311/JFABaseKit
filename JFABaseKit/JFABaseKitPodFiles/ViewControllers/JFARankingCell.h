//
//  JFARankingCell.h
//  JFAAppStoreHelper
//
//  Created by 魏星 on 15/9/8.
//  Copyright © 2015年 JF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFATableViewCell.h"
@interface JFARankingCell : JFATableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleinfolabel;

- (IBAction)didDownLoad:(id)sender;
@end
