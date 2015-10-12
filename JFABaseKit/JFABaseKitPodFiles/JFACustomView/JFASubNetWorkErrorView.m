//
//  JFASubNetWorkErrorView.m
//  Pods
//
//  Created by 魏星 on 15/10/10.
//
//

#import "JFASubNetWorkErrorView.h"

@implementation JFASubNetWorkErrorView
-(instancetype)initWithFrame:(CGRect)frame bgimage:(UIImage *)bgimage
{
    self = [super initWithFrame:frame bgimage:bgimage];
    if (self) {
        self.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)refreshAction:(UITapGestureRecognizer*)tap
{
    if (self.delegate&& [self.delegate respondsToSelector:@selector(didRefreshInfo)]) {
        [self.delegate didRefreshInfo];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
