//
//  JFARecommonTableViewCell.m
//  JFAAppStoreHelper
//
//  Created by stefan on 15/9/6.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import "JFARecommonTableViewCell.h"
#import "JFARecommonTableViewItem.h"
#import "UIImageView+AFNetworking.h"

@implementation JFARecommonTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateCell:(JFARecommonTableViewItem *)item
{
    [self.appIcon setImageWithURL:[NSURL URLWithString:item.logoUrl]];
    self.appTitleLabel.text=item.softName;
    self.appInfoLabel.text=item.shortBrief;
}

- (IBAction)downLoad:(id)sender {
}
@end
