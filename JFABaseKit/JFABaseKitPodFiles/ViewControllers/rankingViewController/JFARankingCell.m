//
//  JFARankingCell.m
//  JFAAppStoreHelper
//
//  Created by 魏星 on 15/9/8.
//  Copyright © 2015年 JF. All rights reserved.
//

#import "JFARankingCell.h"
#import "JFARankingItem.h"
#import "UIImageView+AFNetworking.h"
@implementation JFARankingCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateCell:(JFARankingItem *)item
{
    [self.iconImageView setImageWithURL:[NSURL URLWithString:item.logoUrl]];
    self.titleLabel.text=item.softName;
    self.titleinfolabel.text=item.shortBrief;
}
- (IBAction)didDownLoad:(id)sender {
}
@end
