//
//  IIRecommendTableHeaderView.m
//  IIAppleHD
//
//  Created by puxin on 14-5-7.
//  Copyright (c) 2014年 iiapple. All rights reserved.
//

#import "IIBannerView.h"
//#import "AIApplicationUtility.h"

@interface IIBannerView () {
    
}

@property (nonatomic, strong) UIView *contentView;

@end

@implementation IIBannerView


//static BOOL _dealloc = NO;

@synthesize sv;
@synthesize pc;
@synthesize timer;
@synthesize svPageWidth;
@synthesize svPageHeight;
@synthesize arrayPage;

- (void)dealloc{
//    _dealloc = YES;
    _delegate = nil;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.sv = nil;
    self.pc = nil;
    
    [self.arrayPage removeAllObjects];
    self.arrayPage = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        _dealloc = NO;
        self.arrayPage = [NSMutableArray array];
        svPageWidth = self.frame.size.width - RECOMMEND_HEADER_PADDING * 2;
        svPageHeight = self.frame.size.height - RECOMMEND_HEADER_PADDING * 2;
        self.sv = [[UIScrollView alloc] initWithFrame:CGRectMake(RECOMMEND_HEADER_PADDING, RECOMMEND_HEADER_PADDING, svPageWidth, svPageHeight)];
        self.sv.pagingEnabled = YES;
        self.sv.showsHorizontalScrollIndicator = NO;
        self.sv.showsVerticalScrollIndicator = NO;
        self.sv.delegate = self;
        self.sv.bounces = YES;
        self.sv.autoresizesSubviews = YES;
        self.sv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:sv];
       
        pc = [[UIPageControl alloc] initWithFrame:CGRectZero];
        [pc addTarget:self action:@selector(onPageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:pc];
        
        
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        
        [self start];
//        self.contentView = [[UIView alloc] initWithFrame:self.bounds];
//        [self addSubview:_contentView];
        
    }
    return self;
}



-(void)reloadImages {
}

-(void) addPage:(UIImageView *) iv
{
    CGFloat width = 0;
    if (self.isShot) {
        self.layer.cornerRadius = 0;
        self.layer.masksToBounds = YES;
        self.sv.pagingEnabled = NO;
        width = 439 + PAD_APP_IMAGE_SPACE;
        [iv setFrame:(CGRect){{width * self.arrayPage.count, 15}, 439,330}];
        [self.sv addSubview:iv];
    }
    else {
        width = self.frame.size.width - RECOMMEND_HEADER_PADDING * 2;
        [iv setFrame:(CGRect){{width * self.arrayPage.count, 0}, self.sv.frame.size}];
    }
    iv.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    iv.userInteractionEnabled = YES;
    [self.arrayPage addObject:iv];
    self.sv.contentSize = CGSizeMake(width * self.arrayPage.count, svPageHeight);
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=iv.bounds;
    [button addTarget:self action:@selector(didSelectPage:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = iv.tag;
    [iv addSubview:button];
    if (!self.isShot) {
        self.pc.numberOfPages = self.arrayPage.count > 1 ? self.arrayPage.count : 0 ;
        self.pc.currentPage = 0;
        if (self.isBiger) {
            iv.userInteractionEnabled = NO;
            [self.sv addSubview:iv];
            self.sv.contentSize = CGSizeMake(width * self.arrayPage.count, self.sv.frame.size.height);
            self.pc.frame = CGRectMake((self.frame.size.width - self.arrayPage.count * RECOMMEND_HEADER_PAGECONTROL_DOT_WIDTH - RECOMMEND_HEADER_PADDING)/2.0f, self.frame.size.height - RECOMMEND_HEADER_PAGECONTROL_HEIGHT- RECOMMEND_HEADER_PADDING, self.arrayPage.count * RECOMMEND_HEADER_PAGECONTROL_DOT_WIDTH, RECOMMEND_HEADER_PAGECONTROL_HEIGHT);
            if (!IOS6_EARLY) {
                self.pc.pageIndicatorTintColor = [UIColor whiteColor];
                self.pc.currentPageIndicatorTintColor = AI_MAIN_BLUECOLOR;
            }
        }
        else {
            self.sv.contentSize = CGSizeMake(width * (self.arrayPage.count > 3 ? 3 : self.arrayPage.count), svPageHeight);
            self.pc.frame = CGRectMake(self.frame.size.width - self.arrayPage.count * RECOMMEND_HEADER_PAGECONTROL_DOT_WIDTH - RECOMMEND_HEADER_PADDING, self.frame.size.height - RECOMMEND_HEADER_PAGECONTROL_HEIGHT- RECOMMEND_HEADER_PADDING, self.arrayPage.count * RECOMMEND_HEADER_PAGECONTROL_DOT_WIDTH, RECOMMEND_HEADER_PAGECONTROL_HEIGHT);
            [self reloadImageViews:self.pc.currentPage];
        }
    }
    
}

-(void)reloadLoaout {
    CGFloat imageWidth = 0;
    for (NSInteger i = 0 ; i < self.arrayPage.count; i ++) {
        UIImageView *iv = [self.arrayPage objectAtIndex:i];
        if (self.arrayPage.count > 1) {
            iv.frame = CGRectMake(imageWidth + i * PAD_APP_IMAGE_SPACE, iv.frame.origin.y, iv.frame.size.width, iv.frame.size.height);
        }
        else {
            iv.frame = CGRectMake((self.frame.size.width - iv.frame.size.width)/2.0f, iv.frame.origin.y, iv.frame.size.width, iv.frame.size.height);
        }
        imageWidth += iv.frame.size.width;
    }
    self.sv.contentSize = CGSizeMake(imageWidth + (self.arrayPage.count - 1)*PAD_APP_IMAGE_SPACE, svPageHeight);
}

-(CGFloat)currentContentOffsetX {
    return self.sv.contentOffset.x;
}

-(void) setCurrentIndex:(NSInteger)index {
    self.sv.contentOffset = CGPointMake(index*self.sv.frame.size.width, 0);
    self.pc.currentPage = index;
}

-(void)clearPage {
    for (UIImageView *iv in self.arrayPage) {
        NSArray* array = iv.gestureRecognizers;
        for (UIGestureRecognizer* g in array) {
            [iv removeGestureRecognizer:g];
        }
        [iv removeFromSuperview];
    }
    [self.arrayPage removeAllObjects];
}

-(void) start
{
    if (self.arrayPage.count > 2) {
        [self.timer invalidate];
        self.timer = nil;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(timerArrived) userInfo:nil repeats:YES];
    }
    
//    [self.timer setFireDate:[NSDate distantPast]];
}

-(void) stop
{
    [self.timer invalidate];
    self.timer = nil;
//    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stop];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.arrayPage.count > 2) {
        if (self.isBiger) {
            CGPoint pt = self.sv.contentOffset;
            int nCurPage = svPageWidth > 0 ? (int)(pt.x / svPageWidth) : 0;
            self.pc.currentPage = nCurPage;
            return;
        }
        CGPoint pt = self.sv.contentOffset;
        int nCurPage = svPageWidth > 0 ?  ((self.pc.currentPage + (int)(pt.x / svPageWidth) - 1 + self.arrayPage.count) % self.arrayPage.count) : 0;
        self.pc.currentPage = nCurPage;
        if (!self.isShot && !self.isBiger && self.arrayPage.count > 2) {
            [self start];
            [self reloadImageViews:self.pc.currentPage];
        }
    }
    else {
        self.pc.currentPage = (NSInteger)(scrollView.contentOffset.x/self.sv.frame.size.width);
    }
    
    
}

-(void) onPageControlValueChanged:(id) sendor
{
    
//    [self gotoNextPage];
}

-(void) timerArrived
{
    if (self.sv.isDecelerating || self.sv.isDragging || self.sv.isZoomBouncing) {
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    if (self.arrayPage.count>0) {
        
        [self gotoNextPage];

    }
    
}

-(void) gotoNextPage
{
    self.pc.currentPage = (self.pc.currentPage + 1 + self.arrayPage.count) % self.arrayPage.count;
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.sv.contentOffset = CGPointMake(self.sv.frame.size.width * 2, 0);
    } completion:^(BOOL finished) {
//        if (_dealloc) {
//            return;
//        }
        [self reloadImageViews:self.pc.currentPage];
    }];
}

- (void)didSelectPage:(UIButton *)imageV{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didSelectIndex:)]){
        [self.delegate bannerView:self didSelectIndex:(int)imageV.tag];
    }
}

-(void)reloadImageViews:(NSInteger)index {
    NSInteger arrCount = self.arrayPage.count;
    for (int i = 0; i < (arrCount > 3 ? 3 : arrCount); i ++) {
        NSInteger indexTmp = (index + i - 1 + arrCount) % arrCount;
        UIImageView* imageV = [self.arrayPage objectAtIndex:indexTmp];
        NSInteger width = self.frame.size.width - RECOMMEND_HEADER_PADDING * 2;
        [imageV setFrame:(CGRect){{width * i, 0}, self.sv.frame.size}];
        if (!imageV.superview) {
            [self.sv addSubview:imageV];
        }
    }
    if (self.arrayPage.count <= 1) {
        return;
    }
    for (int i = 0; i < arrCount; i ++) {
        if (i != (index - 1 + arrCount) % arrCount && i != index && i != (index + 1 + arrCount) % arrCount) {
            UIImageView* imageV = [self.arrayPage objectAtIndex:i];
            if (imageV.superview) {
                [imageV removeFromSuperview];
            }
        }
    }
    if (self.arrayPage.count > 2) {
        self.sv.contentOffset = CGPointMake(self.sv.frame.size.width,0);
    }
}

@end
