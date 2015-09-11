//
//  AIProgressView.h
//  Pods
//
//  Created by chengdengwei on 15/6/24.
//
//

#import <UIKit/UIKit.h>

@interface AIProgressView : UIView

@property (nonatomic,strong) UIView *loadingView;
@property (nonatomic,strong) UIImageView *loadingIconView;
@property (nonatomic,strong) UIProgressView *loadingProgressView;


-(id)initWithFrame:(CGRect)frame;
-(void)setProgress:(CGFloat)prog animated:(BOOL)animated;

@end
