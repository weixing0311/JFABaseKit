//
//  JFARecommonTableViewCell.h
//  JFAAppStoreHelper
//
//  Created by stefan on 15/9/6.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFATableViewCell.h"

@interface JFARecommonTableViewCell : JFATableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *appIcon;
@property (weak, nonatomic) IBOutlet UILabel *appTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *appInfoLabel;
- (IBAction)downLoad:(id)sender;
@end
