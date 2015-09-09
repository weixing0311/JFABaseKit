//
//  AISearchBar.h
//  AppInstaller
//
//  Created by  on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat kSearchBarHeight;

@protocol AISearchBarDelegate;

@interface AISearchBar : UIView <UISearchBarDelegate, UITextFieldDelegate>

@property (nonatomic, assign) id<AISearchBarDelegate> delegate;
@property (nonatomic, readonly, retain) UISearchBar *innerSearchBar;
@property (nonatomic, assign) BOOL showsCancelButton;

@end

@protocol AISearchBarDelegate <NSObject>
@optional

- (BOOL)searchBarShouldBeginEditing:(AISearchBar *)searchBar;
- (void)searchBarTextDidBeginEditing:(AISearchBar *)searchBar;
- (void)searchBarTextDidEndEditing:(AISearchBar *)searchBar;
- (void)searchBarCancelButtonClicked:(AISearchBar *)searchBar;
- (void)searchBar:(AISearchBar *)searchBar startSearchingText:(NSString *)searchText;

@end
