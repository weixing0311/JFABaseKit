//
//  JFAAppManagerCell.m
//  JFAAppStoreHelper
//
//  Created by 魏星 on 15/9/8.
//  Copyright © 2015年 JF. All rights reserved.
//

#import "JFAAppManagerCell.h"
#import "JFABaseServiceHeader.h"
#import "JFAAppManagerItem.h"
#import "UIImageView+AFNetworking.h"
@implementation JFAAppManagerCell
//11
- (void)awakeFromNib {
    // Initialization code
}
-(void)updateCell:(JFAAppManagerItem *)item
{
    [self.appicon setImageWithURL:[NSURL URLWithString:item.logoUrl]];
    self.apptitlelabel.text=item.softName;
    self.appinfolabel.text=item.shortBrief;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
