//
//  AISearchHistoryCell.m
//  AppInstallerGreen
//
//  Created by feng.lipeng on 14-7-15.
//
//

#import "AISearchHistoryCell.h"

@implementation AISearchHistoryCell

- (void)awakeFromNib
{
    // Initialization code
    self.titleLabel.frame = CGRectMake(0, self.titleLabel.frame.origin.y, AI_SCREEN_WIDTH, self.titleLabel.frame.size.height);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.deleteBtn.frame = CGRectMake(AI_SCREEN_WIDTH - 40, self.deleteBtn.frame.origin.y, self.deleteBtn.frame.size.width, self.deleteBtn.frame.size.height);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    // Configure the view for the selected state
}


-(IBAction)deleteBtnPressed:(UIButton*)button {
    if (self.deleteDelegate) {
        [self.deleteDelegate onDeleteItemWithKey:self.titleLabel.text];
    }
}

@end
