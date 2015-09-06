//
//  JFABaseSegmentViewController.h
//  Pods
//
//  Created by stefan on 15/9/6.
//
//

#import "JFABaseViewController.h"
#import "JFASegmentContentView.h"

@interface JFABaseSegmentViewController : JFABaseViewController

@property (nonatomic, strong, readonly) NSArray *viewControllers;
@property (nonatomic, strong) UIView *segmentView;
@property (nonatomic, strong) JFASegmentContentView *segmentContentView;

- (id)initWithViewControllers:(NSArray *)viewControllers segmentViewHeight:(CGFloat)height;
- (void)hideSegmentView;
- (void)showSegmentView;
- (void)setSelectedAt:(NSInteger)index;
-(void)setSegmentViewIndxe:(NSInteger)index;
@end
