//
//  AISearchBar.m
//  AppInstaller
//
//  Created by  on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AISearchBar.h"
#import "AIViewFactory.h"
#import "UIImage+Extension.h"
#import "UIImage+LocalImage.h"

const CGFloat kSearchBarHeight = 47.0f;
const int MAX_TEXT_LEN = 40;

//static const CGFloat kMarginBetweenSourceSelectionButtonAndIndicator = 4;

@interface AISearchBar ()

@property (nonatomic, retain) UITextField *searchTextField;
@property (nonatomic, retain) UIImageView *sourceSelectionButton;
@property (nonatomic, retain) UIView *sourceListTableParentView;
@property (nonatomic, retain) UIView *hiddenBackgroundView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)showSourceList:(BOOL)show;
- (void)showHiddenBackgroundView:(BOOL)show;

@end

@implementation AISearchBar

@synthesize delegate = _delegate;
@synthesize innerSearchBar = _innerSearchBar;
@synthesize searchTextField = _searchTextField;
@synthesize sourceSelectionButton = _sourceSelectionButton;
@synthesize hiddenBackgroundView = _hiddenBackgroundView;
@synthesize sourceListTableParentView = _sourceListTableParentView;
@synthesize managedObjectContext = _managedObjectContext;

@dynamic showsCancelButton;


- (void)createInnerSearchBar:(CGRect)frame
{
    frame = CGRectMake(0, 0, frame.size.width, kSearchBarHeight);
    
    _innerSearchBar = [AIViewFactory createCustomizedSystemSearchBarWithFrame:frame];
    _innerSearchBar.delegate = self;
    
    for (UIView *subview in _innerSearchBar.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            _searchTextField = (UITextField *)subview;

            UIImage *selectorImage = [[UIImage storeImageNamed:@"search_bar_icon@3x.png"] scaledImageFrom3x];
            UIImageView *selectorView = [[UIImageView alloc] initWithImage:selectorImage];
            selectorView.frame = CGRectMake(0, 0, selectorImage.size.width, selectorImage.size.height);
            
            _searchTextField.leftView = selectorView;
            
            break;
        }
    }
    
    [self addSubview:_innerSearchBar];
}

- (void)createSourceListTableView
{
    static const CGFloat kTableViewLeftMargin = 5;
    CGRect tableFrame = CGRectMake(kTableViewLeftMargin, self.innerSearchBar.frame.origin.y + self.innerSearchBar.frame.size.height - 8, self.innerSearchBar.frame.size.width - kTableViewLeftMargin * 2, 130);
    _sourceListTableParentView = [[UIView alloc] initWithFrame:tableFrame];
    _sourceListTableParentView.backgroundColor = [UIColor colorForHex:APP_COLOR_1];
    _sourceListTableParentView.hidden = YES;
    
    tableFrame.origin.x = 1;
    tableFrame.origin.y = 1;
    tableFrame.size.width -= 2;
    tableFrame.size.height -= 2;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:tableFrame];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [_sourceListTableParentView addSubview:backgroundView];
    
    tableFrame.origin.x = 2;
    tableFrame.origin.y = 1;
    tableFrame.size.width -= 3;
    tableFrame.size.height -= 2;
    
    _hiddenBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.innerSearchBar.frame.origin.y + self.innerSearchBar.frame.size.height, self.frame.size.width, self.frame.size.height)];
    _hiddenBackgroundView.hidden = YES;
    
    [self addSubview:_hiddenBackgroundView];
    [self addSubview:_sourceListTableParentView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorForHex:APP_COLOR_3];
        
        [self createInnerSearchBar:frame];
        [self createSourceListTableView];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view == self.hiddenBackgroundView && event.type == UIEventTypeTouches) {
        [self.innerSearchBar resignFirstResponder];
        [self showHiddenBackgroundView:NO];
    }
}

- (void)onSelectSource:(id)sender
{
    [self.innerSearchBar resignFirstResponder];
    [self showSourceList:self.sourceListTableParentView.hidden];
}

- (void)showSourceList:(BOOL)show
{
    if (show) {
        self.sourceListTableParentView.hidden = NO;
        self.hiddenBackgroundView.hidden = NO;
        [self.superview bringSubviewToFront:self];
    } else {
        self.sourceListTableParentView.hidden = YES;
        self.hiddenBackgroundView.hidden = YES;
        [self.superview sendSubviewToBack:self];
    }
}

- (void)showHiddenBackgroundView:(BOOL)show
{
    if (show) {
        self.hiddenBackgroundView.hidden = NO;
        self.sourceListTableParentView.hidden = YES;
        [self.superview bringSubviewToFront:self];
    } else {
        self.hiddenBackgroundView.hidden = YES;
        self.sourceListTableParentView.hidden = YES;
        [self.superview sendSubviewToBack:self];
    }
}


#pragma mark - getter & setter
- (BOOL)showsCancelButton
{
    return self.innerSearchBar.showsCancelButton;
}

- (void)setShowsCancelButton:(BOOL)showsCancelButton
{
    self.innerSearchBar.showsCancelButton = showsCancelButton;
    if (showsCancelButton) {
        for (UIView *subview in _innerSearchBar.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
                [(UIButton *)subview setBackgroundImage:[[UIImage storeImageNamed:@"search_bar_cancel.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:0] forState:UIControlStateNormal];
                [(UIButton *)subview setBackgroundImage:[[UIImage storeImageNamed:@"search_bar_cancel_pressed.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:0] forState:UIControlStateHighlighted];
                [(UIButton *)subview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [(UIButton *)subview setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
                break;
            }
        }
    }
}


#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [self.innerSearchBar resignFirstResponder];
    [self showHiddenBackgroundView:NO];
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(searchBar:startSearchingText:)]) {
        if ([[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
            [self.delegate searchBar:self startSearchingText:searchBar.text];
        }
    }
    }

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)]) {
        [self.delegate searchBarCancelButtonClicked:self];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    BOOL should = YES;
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        should = [self.delegate searchBarShouldBeginEditing:self];
    }
    return should;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)]) {
        [self.delegate searchBarTextDidBeginEditing:self];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // show the hidden background
    [self showHiddenBackgroundView:YES];
    
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(searchBarTextDidEndEditing:)]) {
        [self.delegate searchBarTextDidEndEditing:self];
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger newLength = [searchBar.text length] + [text length] - range.length;
    
    // For strings containning Chinese characters, cut down the limit to a half.
    int maxLen = MAX_TEXT_LEN;
    if ([searchBar.text lengthOfBytesUsingEncoding:NSUTF8StringEncoding] > [searchBar.text length])
    {
        maxLen /= 2;
    }
    
    // Backspace and Search keys will also trigger this method.
    return (newLength <= maxLen || [text isEqualToString:@"\n"] || [text isEqualToString:@""]);
}
    

- (void)dealloc
{
    _innerSearchBar.delegate = nil;
    _innerSearchBar = nil;
    
    _searchTextField.delegate = nil;
    _searchTextField = nil;
}

@end
