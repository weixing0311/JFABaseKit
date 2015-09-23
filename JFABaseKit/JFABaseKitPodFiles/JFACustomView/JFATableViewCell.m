//
//  JFATableViewCell.m
//  Pods
//
//  Created by stefan on 15/8/31.
//
//

#import "JFATableViewCell.h"

@implementation JFATableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)createTagViewWithArr:(NSArray *)arr
{
    float width = self.appTitleLabel.frame.origin.x;
    if (!arr||arr.count<1) {
        return;
    }
    
    for (int i = 0;i<arr.count; i++) {
        NSDictionary *dic = [arr objectAtIndex:i];
        
        NSString * tag_name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"tag_name"]];
        float strSizeWidth = [self widthFortext:tag_name];
        
        UIView * tagView = [[UIView alloc] initWithFrame:CGRectMake(width, self.appTitleLabel.frame.origin.y + self.appTitleLabel.frame.size.height, strSizeWidth+2, 15)];
        tagView.backgroundColor = [UIColor clearColor];
        tagView.layer.borderWidth = 1;
        tagView.tag = 1024 + i;
        
        tagView.layer.borderColor = [UIColor colorForHex:[dic objectForKey:@"frame_color"]].CGColor;
        tagView.layer.cornerRadius = 2;
        UILabel * tagLabel = [[UILabel alloc] initWithFrame:tagView.bounds];
        tagLabel.backgroundColor = [UIColor clearColor];
        tagLabel.text = [dic objectForKey:@"tag_name"];
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.textColor = [UIColor colorForHex:[dic objectForKey:@"frame_color"]];
        tagLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:10];
        tagLabel.adjustsFontSizeToFitWidth = YES;
        [tagView addSubview:tagLabel];
        width +=strSizeWidth+4;
        [self addSubview:tagView];
    }
    
    
}
-(CGFloat)widthFortext:(NSString *)str
{
    if (IOS7_OR_LATER) {
        NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};
        return [str boundingRectWithSize:CGSizeMake(0, 15) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.width;
    }else{
        return [str sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(100, 15)  lineBreakMode:NSLineBreakByWordWrapping].width;
        
    }
}
-(void)updateCell:(JFATableCellItem*)item
{
    
}
@end
