//
//  JFAFewCustom.m
//  Pods
//
//  Created by 魏星 on 15/9/23.
//
//

#import "JFAFewCustom.h"
@interface JFAFewCustom()
@property (nonatomic,strong)NSMutableArray *subViewsArr;

@end
@implementation JFAFewCustom
- (instancetype)initWithFrame:(CGRect)frame SubViews:(NSArray *)subViews
{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setArrWithArr:subViews];
    }
    return self;
}
-(void)setArrWithArr:(NSArray *)arr
{
    if (arr&&arr.count>0) {
        self.subViewsArr =[NSMutableArray arrayWithArray:arr];
        [self createFewViewsWithSubViews:self.subViewsArr];
    }
}
-(void)createFewViewsWithSubViews:(NSArray *)arr
{
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *dict = [arr objectAtIndex:i];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i*self.bounds.size.width/arr.count, 0, self.bounds.size.width/arr.count, self.bounds.size.height)];
        [button addTarget:self action:@selector(didClickTouch:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[dict objectForKey:@"title"]?[dict objectForKey:@"title"]:@"" forState:UIControlStateNormal];
        [button setBackgroundImage:[dict objectForKey:@"bgImg"]?[UIImage imageNamed:[dict objectForKey:@"bgImg"]]:nil forState:UIControlStateNormal];
        button.tag = 1000+i;
        [self addSubview:button];
    }
}
-(void)didClickTouch:(UIButton *)button
{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
