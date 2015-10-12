//
//  JFAFewCustom.m
//  Pods
//
//  Created by 魏星 on 15/9/23.
//
//

#import "JFAFewCustom.h"
@interface JFAFewCustom()
{
    UIView *lineView;
}
@property (nonatomic,strong)NSMutableArray *subViewsArr;

@end
@implementation JFAFewCustom
- (instancetype)initWithFrame:(CGRect)frame SubViews:(NSArray *)subViews
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createLineViewWithFrame:CGRectMake(0, 0, frame.size.width/subViews.count, frame.size.height)];
        [self setArrWithArr:subViews];
    }
    return self;
}


-(void)createLineViewWithFrame:(CGRect)frame
{
    lineView = [[UIView alloc]initWithFrame:frame];
    lineView.backgroundColor = [UIColor colorForHex:@"#007aff"];
    lineView.layer.cornerRadius = 5;
    lineView.layer.masksToBounds = YES;

    [self addSubview:lineView];
    
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
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i*self.bounds.size.width/arr.count, 0, self.bounds.size.width/arr.count, self.bounds.size.height)];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:13 ];
     
        if (i==0) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor colorForHex:@"#007aff"] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(didClickTouch:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:arr[i] forState:UIControlStateNormal];
//        [button setBackgroundImage:[dict objectForKey:@"bgImg"]?[UIImage imageNamed:[dict objectForKey:@"bgImg"]]:nil forState:UIControlStateNormal];
        button.tag = 1000+i;
        [self addSubview:button];
    }
    
    
}
-(void)didClickTouch:(UIButton *)button
{

    [self didChangeBtnColor:(button.tag-1000)];
}

-(void)didChangeBtnColor:(NSInteger)a
{
    [UIView animateWithDuration:.5 animations:^{
        lineView.frame = CGRectMake(lineView.frame.size.width*a, 0, lineView.frame.size.width, lineView.frame.size.height);
    }];
    UIButton *superBtn = (UIButton *)[self viewWithTag:a+1000];
    [UIView animateWithDuration:1 animations:^{
        for (int i =0; i<self.subViewsArr.count; i++) {
            UIButton *btn =(UIButton *)[self viewWithTag:1000+i];
            if (btn.tag==superBtn.tag) {
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else  {
                [btn setTitleColor:[UIColor colorForHex:@"#007aff"] forState:UIControlStateNormal];
            }
        }
    }];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"KDIDCLICKSEGMENTBUTTONWITHBUTTONTAG" object:@(a)];
 
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
