//
//  JFASegmentContentView.m
//  Pods
//
//  Created by stefan on 15/9/6.
//
//

#import "JFASegmentContentView.h"

@interface JFASegmentContentView ()<UIScrollViewDelegate>{
    NSUInteger _currentPage;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation JFASegmentContentView

- (void)dealloc{
    [_scrollView removeObserver:self forKeyPath:@"frame"];
    _scrollView = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_scrollView setDelegate:self];
        [_scrollView setPagingEnabled:YES];
        [self addSubview:_scrollView];
        [_scrollView setBounces:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _currentPage = 0;
        
        [_scrollView addObserver:self forKeyPath:@"frame" options:0 context:NULL];
        _scrollView.scrollsToTop = NO;
    }
    return self;
}

- (void)setPageCount:(NSUInteger)count{
    [self.scrollView setContentSize:(CGSize){count * self.frame.size.width, self.frame.size.height}];
    _pageCount = count;
}


- (NSUInteger)selectPage{
    return _currentPage;
}

- (void)setSelectPage:(NSUInteger)page{
    if (_currentPage == page){
        return;
    }
    [self.scrollView setContentOffset:(CGPoint){page * self.frame.size.width, 0} animated:YES];
}


- (void)addView:(UIView *)view
         atPage:(NSUInteger)page{
    CGRect frame = view.frame;
    frame.origin.x = page * _scrollView.frame.size.width;
    frame.origin.y = 0;
    frame.size = self.frame.size;
    [view setFrame:frame];
    [_scrollView addSubview:view];
}

- (void)clearViews{
    for (UIView *view in [_scrollView subviews]){
        [view removeFromSuperview];
    }
}

- (void)setViews:(NSArray *)views{
    _views = views;
    
    [self clearViews];
    for (int i = 0; i < [views count]; i++){
        [self addView:[views objectAtIndex:i] atPage:i];
    }
    [self setPageCount:[views count]];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSUInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (page != _currentPage){
        if ([_delegate respondsToSelector:@selector(segmentContentView:selectPage:)]){
            [_delegate segmentContentView:self selectPage:page];
        }
        _currentPage = page;
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (page != _currentPage){
        if ([_delegate respondsToSelector:@selector(segmentContentView:selectPage:)]){
            [_delegate segmentContentView:self selectPage:page];
        }
        _currentPage = page;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![keyPath isEqualToString:@"frame"])
        return;
    [self setPageCount:_pageCount];
}


@end
