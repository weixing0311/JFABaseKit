//
//  IIRecommendTableHeaderView.h
//  IIAppleHD
//
//  Created by puxin on 14-5-7.
//  Copyright (c) 2014年 iiapple. All rights reserved.
//

#import "JFATableViewCell.h"

@protocol IIBannerViewDelegate;

@interface IIBannerView : UIView <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView * sv;
@property (strong, nonatomic) UIPageControl * pc;
@property (assign, nonatomic) NSTimer * timer;
@property (assign, nonatomic) int svPageWidth;
@property (assign, nonatomic) int svPageHeight;
@property (strong, nonatomic) NSMutableArray * arrayPage;

@property (nonatomic, assign) id <IIBannerViewDelegate> delegate;
@property (nonatomic, assign) BOOL isShot;
@property (nonatomic, assign) BOOL isBiger;

-(void) addPage:(UIImageView *) image;
-(void) clearPage;
-(void) start;
-(void) stop;
-(void) reloadLoaout;
-(CGFloat) currentContentOffsetX;
-(void) setCurrentIndex:(NSInteger)index;
-(void) reloadImages;
@end

@protocol IIBannerViewDelegate <NSObject>

@optional

- (void)bannerView:(IIBannerView *)bannerView didSelectIndex:(int)index;


@end
