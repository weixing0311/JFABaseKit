//
//  JFASegmentContentView.h
//  Pods
//
//  Created by stefan on 15/9/6.
//
//

#import <UIKit/UIKit.h>
@class JFASegmentContentView;
@protocol JFASegmentContentViewDelegate <NSObject>


- (void)segmentContentView:(JFASegmentContentView *)segmentContentView
                selectPage:(NSUInteger)page;

@end

@interface JFASegmentContentView : UIView

@property (nonatomic, assign) NSUInteger pageCount;
@property (nonatomic, strong) NSArray *views;
@property (nonatomic, assign) id <STSegmentContentViewDelegate> delegate;
@property (nonatomic, assign) NSUInteger selectPage;

/**
 *	@brief	添加一个视图到某一页
 *
 *	@param 	view 	单个视图
 *	@param 	page 	指定要插入的页码
 */
- (void)addView:(UIView *)view
         atPage:(NSUInteger)page;
@end
