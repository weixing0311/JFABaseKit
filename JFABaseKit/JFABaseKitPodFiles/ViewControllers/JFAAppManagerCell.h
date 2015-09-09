//
//  JFAAppManagerCell.h
//  JFAAppStoreHelper
//
//  Created by 魏星 on 15/9/8.
//  Copyright © 2015年 JF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFATableViewCell.h"
@interface JFAAppManagerCell : JFATableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *appicon;
@property (weak, nonatomic) IBOutlet UILabel *apptitlelabel;
@property (weak, nonatomic) IBOutlet UILabel *appinfolabel;

@end
