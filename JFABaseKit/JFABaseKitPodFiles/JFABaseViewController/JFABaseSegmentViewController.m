//
//  JFABaseSegmentViewController.m
//  Pods
//
//  Created by stefan on 15/9/6.
//
//

#import "JFABaseSegmentViewController.h"
#import "JFABaseTableViewController.h"
@interface JFABaseSegmentViewController ()
{
    CGFloat _height;
}
@end

@implementation JFABaseSegmentViewController

- (id)initWithViewControllers:(NSArray *)viewControllers segmentViewHeight:(CGFloat)height {
    if (self = [super init]){
        _viewControllers = viewControllers;
        _height = height;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, _height)];
    self.segmentView.clipsToBounds = NO;
    self.segmentView.backgroundColor = [UIColor grayColor];
    self.view.clipsToBounds = YES;
    self.segmentContentView = [[JFASegmentContentView alloc] initWithFrame:(CGRect){{0,_height}, {JFA_SCREEN_WIDTH, self.view.frame.size.height - _height}}];
    [_segmentContentView setDelegate:self];
    self.segmentContentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_segmentView];

    [self.view addSubview:_segmentContentView];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    NSMutableArray *views = [NSMutableArray arrayWithCapacity:_viewControllers.count];
    
    for (NSInteger i = 0 ; i < _viewControllers.count ; i++){

        JFABaseTableViewController *vc = [_viewControllers objectAtIndex:i];
        [views addObject:vc.view];
    }
    
    [_segmentContentView setViews:views];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    for (UIViewController *vc in _viewControllers){
        [vc viewWillAppear:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.segmentContentView.selectPage < _viewControllers.count && self.segmentContentView.selectPage > 0) {
        JFABaseTableViewController *currentViewController = [_viewControllers objectAtIndex:self.segmentContentView.selectPage];
        [currentViewController viewDidAppear:animated];
    }
}

- (void)hideSegmentView {
    if (!_segmentView.hidden) {
        _segmentView.alpha = 1.0;
        [UIView animateWithDuration:.0 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _segmentView.alpha = 0;
        } completion:^(BOOL finished) {
            _segmentView.hidden = YES;
            _segmentView.alpha = 1;
        }];
    }
}

-(void)showSegmentView {
    if (_segmentView.hidden) {
        _segmentView.hidden = NO;
        _segmentView.alpha = 0.0;
        [UIView animateWithDuration:.0 animations:^{
            _segmentView.alpha = 1.0;
        }];
    }
}

- (void)setSelectedAt:(NSInteger)index {
    self.segmentContentView.selectPage = index;
}

-(void)setSegmentViewIndxe:(NSInteger)index
{
    
}

- (void)segmentContentView:(JFASegmentContentView *)segmentContentView selectPage:(NSUInteger)page{
    [self setSegmentViewIndxe:page];
}

@end
