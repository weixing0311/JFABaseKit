//
//  JFANetworkErrorView.m
//  Pods
//
//  Created by stefan on 15/8/31.
//
//

#import "JFANetworkErrorView.h"

@interface JFANetworkErrorView ()
{
    UIImageView* errorImageView;
    UIView* errorView;
    UILabel* errorLabel;
}
@end

@implementation JFANetworkErrorView

-(instancetype)initWithFrame:(CGRect)frame bgimage:(UIImage*)bgimage
{
    self=[super initWithFrame:frame];
    if (self) {
        if (bgimage) {
            [self initErrorView];
            
            [self initErrorImageView];
            
            [self initTapGesture];
        }
    }
    return self;
}

-(void)initErrorView
{
    errorView=[[UIView alloc] initWithFrame:CGRectZero];
    errorView.backgroundColor=[UIColor clearColor];
    [self addSubview:errorView];
}

-(void)initErrorImageView
{
    errorImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,0,0)];
    errorImageView.backgroundColor=[UIColor clearColor];
    [errorView addSubview:errorImageView];
    
    errorLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    errorLabel.backgroundColor=[UIColor clearColor];
    errorLabel.textColor=[UIColor blackColor];
    errorLabel.font=[UIFont systemFontOfSize:16];
    errorLabel.numberOfLines=0;
    errorLabel.textAlignment=NSTextAlignmentCenter;
    errorLabel.text=@"没有网络，请点击重新加载";
    [errorView addSubview:errorLabel];
}

-(void)initTapGesture
{
    UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshAction:)];
    [self addGestureRecognizer:tap];
}

-(void)refreshAction:(UITapGestureRecognizer*)tap
{
    
}

@end
