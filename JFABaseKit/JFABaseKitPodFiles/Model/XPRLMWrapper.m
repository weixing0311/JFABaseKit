//
//  YDPRLMWrapper.m
//  pandaMentor
//
//  Created by Tulipa on 14/10/13.
//  Copyright (c) 2014年 com.youdao. All rights reserved.
//

#import "XPRLMWrapper.h"

@implementation XPRLMWrapper

- (instancetype)initWithScrollView:(UIScrollView *)inScrollView delegate:(id<XPRLMDelegate>)inDelegate
{
	if (self = [super init])
	{
		self.delegate = inDelegate;
		self.scrollView = inScrollView;
		self.contentOffsetNeededToTriggerPullToRefresh = 62;
		self.contentOffsetNeededToTriggerLoadMore = 62;
		self.state = XPRLMStateNormal;
	}
	return self;
}

- (void)triggerPullToRefresh
{
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
	UIEdgeInsets inset = self.scrollView.contentInset;
	inset.top += self.contentOffsetNeededToTriggerPullToRefresh + 1;
	[self.scrollView setContentInset:inset];
	
//    [self.scrollView scrollRectToVisible:CGRectMake(0, - self.scrollView.contentInset.top, 1, 1) animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setContentOffset:CGPointMake(0, - self.contentOffsetNeededToTriggerPullToRefresh - 2)];
    }completion:^(BOOL finished) {
        [self setState:XPRLMStateRefreshing];
        [self.delegate scrollView:self.scrollView didTriggerPullToRefresh:self];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (self.scrollView == scrollView)
	{
		if (self.state == XPRLMStateRefreshing)
		{
			CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
			offset = MIN(offset, self.contentOffsetNeededToTriggerPullToRefresh);
			if (scrollView.dragging)
			{
				scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
			}
			else
			{
				[UIView animateWithDuration:0.5 animations:^{
					scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
				}];
			}
		}
		else if (self.state == XPRLMStateLoadingMore)
		{
			CGFloat offset = MAX(scrollView.contentOffset.y + scrollView.height - scrollView.contentSize.height, 0);
			offset = MIN(offset, self.contentOffsetNeededToTriggerLoadMore);
			if (scrollView.dragging)
			{
				scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, offset, 0.0f);
			}
			else
			{
				[UIView animateWithDuration:0.5 animations:^{
					scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, offset, 0.0f);
				}];
			}
		}
		else if (scrollView.contentOffset.y < - self.contentOffsetNeededToTriggerPullToRefresh)
		{
			if (self.state != XPRLMStateWillTrigerPullToRefresh)
			{
				[self.delegate scrollView:scrollView willTriggerPullToRefresh:self];
			}
			
			self.state = XPRLMStateWillTrigerPullToRefresh;
		}
		else if (self.hasMore && self.scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.height + self.contentOffsetNeededToTriggerLoadMore)
		{
			if (self.state != XPRLMStateWillTriggerLoadMore)
			{
				[self.delegate scrollView:scrollView willTriggerLoadMore:self];
			}
			
			self.state = XPRLMStateWillTriggerLoadMore;
		}
		else
		{
			if (self.state == XPRLMStateWillTrigerPullToRefresh)
			{
				[self.delegate scrollView:scrollView willCancelPullToReFresh:self];
			}
			
			if (self.state == XPRLMStateWillTriggerLoadMore)
			{
				[self.delegate scrollView:scrollView willCancelLoadMore:self];
			}
			
			self.state = XPRLMStateNormal;
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (self.scrollView == scrollView)
	{
		if (self.state == XPRLMStateWillTrigerPullToRefresh)
		{
			self.state = XPRLMStateRefreshing;
			
			[self.delegate scrollView:scrollView didTriggerPullToRefresh:self];
		}
		else if (self.state == XPRLMStateWillTriggerLoadMore)
		{
			self.state = XPRLMStateLoadingMore;
			
			[self.delegate scrollView:scrollView didTriggerLoadMore:self];
		}
	}
}

- (void)didFinishRefreshing
{
	if (self.state == XPRLMStateRefreshing)
	{
        [self.scrollView setContentOffset:self.scrollView.contentOffset animated:NO];
		self.state = XPRLMStateNormal;
		UIEdgeInsets insert = self.scrollView.contentInset;
		insert.top = 0;
		[UIView animateWithDuration:0.5 animations:^{
			[self.scrollView setContentInset:insert];
		}];
	}
}

- (void)didFinishLoadMore
{
	if (self.state == XPRLMStateLoadingMore)
	{
		self.state = XPRLMStateNormal;
		UIEdgeInsets insert = self.scrollView.contentInset;
		insert.bottom = 0;
		[UIView animateWithDuration:0.5 animations:^{
			[self.scrollView setContentInset:insert];
		}];
	}
}

@end
