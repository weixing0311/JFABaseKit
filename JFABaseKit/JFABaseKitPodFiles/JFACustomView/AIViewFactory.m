//
//  AIViewFactory.m
//  AppInstaller
//
//  Created by  on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AIViewFactory.h"
#import "UIImage+Extension.h"
#import "UIImage+LocalImage.h"

#define SEARCH_LEFT_MARGIN 7
#define SEARCH_TOP_MARGIN 7
#define SEARCH_WIDTH 270
#define SEARCH_HEIGHT 30
#define SEARCH_VIEW_TAG 10000

@interface AIViewFactory ()

@end

@implementation AIViewFactory

+ (NavigationBarTitleView *)createTitleViewForViewController:(UIViewController *)viewController
{
    
//    NavigationBarTitleView *view = [[NavigationBarTitleView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    NavigationBarTitleView *view = [[NavigationBarTitleView alloc] initWithFrame:CGRectMake(0, 0, 170, 40)];
    view.titleLabel.text = viewController.title;
    
    
    
    
    return view;
}



+ (AISearchBar *)createSearchBarForView:(UIView *)view
{    
    AISearchBar *searchBar = [[AISearchBar alloc] initWithFrame:CGRectMake(0, 0, AI_SCREEN_WIDTH, kSearchBarHeight)];
    return searchBar;
}

+ (UISearchBar *)createCustomizedSystemSearchBarWithFrame:(CGRect)frame
{
    
    UISearchBar *result = [[UISearchBar alloc] initWithFrame:frame];
    result.backgroundImage = [[UIImage storeImageNamed:@"search_bar_background.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:24];
    result.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    for (UIView *subview in result.subviews) {
//        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
//            [subview removeFromSuperview];
//        }
//    }
    
    
    return result;
}

+ (UIButton *)createButton
{
    UIButton *result = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 72, 28)];
    [self changeButtonToOurCustomStyleGreenButton:result];
    return result;
}

+ (void)changeButtonToOurCustomStyleGreenButton:(UIButton *)button
{
    UIImage *image = [[UIImage storeImageNamed:@"download_btn.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    UIImage *disabledImage = [[UIImage storeImageNamed:@"download_button_disable.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    UIImage *pressedImage = [[UIImage storeImageNamed:@"download_btn_pressed.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];

    button.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    button.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorForHex:APP_COLOR_2] forState:UIControlStateDisabled];
    [button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:pressedImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:pressedImage forState:UIControlStateSelected];
    [button setBackgroundImage:disabledImage forState:UIControlStateDisabled];
}

+ (void)changeButtonToOurCustomStyle:(UIButton *)button
{
    
    UIImage *image = [UIImage storeImageNamed:@"button_background.png"];
    UIImage *disabledImage = [[UIImage storeImageNamed:@"button_background_disabled.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [button setTitleColor:[UIColor colorForHex:APP_COLOR_5] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorForHex:APP_COLOR_2] forState:UIControlStateDisabled];
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:disabledImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:disabledImage forState:UIControlStateDisabled];
    
}

+ (void)changeButtonToOurCustomStyleBlueButton:(UIButton *)button
{
    
    UIImage *image = [[UIImage storeImageNamed:@"download_btn.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    UIImage *pressedImage = [[UIImage storeImageNamed:@"download_btn_pressed.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
//    button.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:pressedImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:pressedImage forState:UIControlStateDisabled];
    
}

+ (UIButton *)createButtonForTitle:(NSString *)title
{
    
    UIButton *result = [self createButton];
    [result setTitle:title forState:UIControlStateNormal];
    [result sizeToFit];
    
    CGRect buttonFrame = result.frame;
    buttonFrame.size.width += 10;
    result.frame = buttonFrame;
    
    
    return result;
}

+ (UIBarButtonItem *)createBackBarButtonItemForTarget:(id)target action:(SEL)action
{
    
    UIButton *backButton = [self createButtonForTitle:@"  返回"];
    
    UIImage *image2 = [UIImage storeImageNamed:@"back_button@3x.png"];
    CGFloat top = 0; // 顶端盖高度
    CGFloat bottom = 0 ; // 底端盖高度
    CGFloat left = 15; // 左端盖宽度
    CGFloat right = 15; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    image2 = [image2 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];

    
    UIImage *backImage = [image2 scaledImageFrom3x];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
//    [backButton setBackgroundImage:[UIImage storeImageNamed:@"back_button_pressed.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    
    [backButton setTitleColor:[UIColor colorForHex:@"464646"] forState:UIControlStateNormal];
    
    UIBarButtonItem *result = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    return result;
}

+ (UIView *)createLoadingServiceViewWithFrame:(CGRect)frame autoLayout:(BOOL)autoLayout;
{
    DLog(@"%@",NSStringFromCGRect(frame));
    
//    frame = [UIScreen mainScreen].bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorForHex:APP_COLOR_3];
    UIView *contentView = [[UIView alloc] initWithFrame:view.bounds];
    contentView.tag=998;
    [view addSubview:contentView];
    
    
    
    
//    UIWebView *loadIconView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, loadIcon.size.width, loadIcon.size.height)];
//    NSString* gif = @"Preloader_2.gif";
//    NSMutableString* htmlStr = [NSMutableString string];
//    [htmlStr appendString:@"Hello Honey"];
//    [htmlStr appendString:@"<p><img src=\""];
//    [htmlStr appendFormat:@"%@",gif];
//    [htmlStr appendString:@"\" alt=\"picture\"/>"];
////    [loadIconView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//    
//    [loadIconView loadHTMLString:htmlStr baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
//    [contentView addSubview:loadIconView];
    
    // create the loading icon

    UIImage *loadIcon = nil;
          loadIcon = [UIImage storeImageNamed:@"loading_view_icon_pad"];
#pragma mark ----创建播放GIF
    NSArray *paths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString * str = [documentPath stringByAppendingPathComponent:@"loading"];
    if (autoLayout) {
        str = [documentPath stringByAppendingPathComponent:@"refresh"];
    }
    NSFileManager* fm=[NSFileManager defaultManager];
    if(![fm fileExistsAtPath:str]){
        //下面是对该文件进行制定路径的保存
        [fm createDirectoryAtPath:str withIntermediateDirectories:YES attributes:nil error:nil];
        //取得一个目录下得所有文件名
    }
    NSArray *files = [fm subpathsAtPath: str ];
     files = [files sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray * imgArr = [NSMutableArray array];
//    string = [string substringToIndex:7];
    if (files &&[files count]>0) {
        for (int i = 0;i<files.count; i++) {
            UIImage *img = [UIImage imageWithContentsOfFile:[[[str componentsSeparatedByString:@"@"]objectAtIndex:0] stringByAppendingPathComponent:files[i]]];
            [imgArr addObject:img];
        }
    }else{
        if (autoLayout) {
            for (int i = 0; i < 8; i++) {
                UIImage *localRefreshImage = [UIImage storeImageNamed:[NSString stringWithFormat:@"refresh%d",i+1]];
                [imgArr addObject:localRefreshImage];
            }
        }else{
            for (int i = 0; i < 15; i++) {
                UIImage *localImage = [UIImage storeImageNamed:[NSString stringWithFormat:@"loading%d",i+1]];
                [imgArr addObject:localImage];
            }
        }
    }
    
    __weak UIImage*img = imgArr[0];
    UIImageView* animView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width/3, img.size.height/3)];

    animView.animationImages = imgArr;
    animView.center = CGPointMake(frame.size.width/2 , frame.size.height/2 + (autoLayout?0:frame.origin.y));
    float bigTime = [[[NSUserDefaults standardUserDefaults]objectForKey:@"LoadingBigSpeed"] floatValue];
    float smallTime =[[[NSUserDefaults standardUserDefaults]objectForKey:@"LoadingSmallSpeed"] floatValue];

    if (autoLayout)
    {
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"LoadingBigSpeed"]) {
            animView.animationDuration = bigTime;
        }else{
            animView.animationDuration = .5f;
        }
    }else{
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"LoadingBigSpeed"]) {
            animView.animationDuration = smallTime;
        }else{
            animView.animationDuration = .8f;
        }
    }
    animView.animationRepeatCount = 0;
    animView.tag = 1024;
    [animView startAnimating];
    [contentView addSubview:animView];
  
 
//    UIImageView *loadIconView = [[UIImageView alloc] initWithImage:loadIcon];
//    loadIconView.frame = CGRectMake(0, 0, loadIcon.size.width, loadIcon.size.height);
//    [contentView addSubview:loadIconView];
//
    // create the label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];

    label.text = NSLocalizedString(@"  正在载入...", @"");
    label.textColor = AI_STORE_TEXT_DETAILCOLOR;
    label.font = [UIFont systemFontOfSize:15.0];
    [label setBackgroundColor:[UIColor clearColor]];
    [label sizeToFit];
    if (!autoLayout) {
        [contentView addSubview:label];

    }
    
//
//    CGFloat contentViewWidth = loadIconView.frame.size.width > label.frame.size.width ? loadIconView.frame.size.width : label.frame.size.width;
//    CGFloat contentViewHeight = label.frame.origin.y + label.frame.size.height;
//    CGFloat x = frame.size.width / 2.0 - contentViewWidth / 2.0;
//    
//    CGFloat offset = 0;
//    //    CGFloat offset = 96;
//    
//    CGFloat y = frame.size.height / 2.0 - contentViewHeight / 2.0 - offset;
//    contentView.frame = CGRectMake(x, y, contentViewWidth, contentViewHeight);
//    
//    CGRect rect = loadIconView.frame;
//    rect.origin.y = 0;
//    rect.origin.x = contentViewWidth / 2.0 - loadIconView.frame.size.width / 2.0;
//    loadIconView.frame = rect;
//    
//    rect = label.frame;
//    rect.origin.y = loadIconView.frame.origin.y + loadIconView.frame.size.height + 22;
//    rect.origin.x = contentViewWidth / 2.0 - label.frame.size.width / 2.0;
//    label.frame = rect;
    
    CGFloat contentViewWidth = animView.frame.size.width > label.frame.size.width ? animView.frame.size.width : label.frame.size.width;
      CGRect rect;
      rect = label.frame;
      rect.origin.y = animView.frame.origin.y + animView.frame.size.height + 22;
      rect.origin.x = contentViewWidth / 2.0 - label.frame.size.width / 2.0;
      label.frame = rect;
    label.center = CGPointMake(contentView.center.x, label.center.y);
//    
//    loadIconView.tag = 200001;
    
//    [loadIconView continueRotateAnimation];
    
    return view;
}

+ (UIView *)createDetailDefaultViewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    view.backgroundColor = [UIColor colorForHex:APP_COLOR_3];
    
#pragma mark ----创建播放GIFloading
    NSArray *paths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString * str = [documentPath stringByAppendingPathComponent:@"loading"];
     NSFileManager* fm=[NSFileManager defaultManager];
    if(![fm fileExistsAtPath:str]){
        //下面是对该文件进行制定路径的保存
        [fm createDirectoryAtPath:str withIntermediateDirectories:YES attributes:nil error:nil];
        //取得一个目录下得所有文件名
    }
    NSArray *files = [fm subpathsAtPath: str ];
    files = [files sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray * imgArr = [NSMutableArray array];
    
    if (files &&[files count]>0) {
        for (int i = 0;i<files.count; i++) {
            UIImage *img = [UIImage imageWithContentsOfFile:[str stringByAppendingPathComponent:files[i]]];
            [imgArr addObject:img];
        }
    }else{
        for (int i = 0; i < 15; i++) {
            UIImage *localImage = [UIImage storeImageNamed:[NSString stringWithFormat:@"loading%d",i+1]];
            [imgArr addObject:localImage];
        }
    }
    
    __weak UIImage*img = imgArr[0];
    UIImageView* animView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    
    animView.animationImages = imgArr;
    animView.center = CGPointMake(frame.size.width/2 , frame.size.height/2 + frame.origin.y);
    animView.animationDuration = .5f;
    animView.animationRepeatCount = 0;
    animView.tag = 1024;
    [animView startAnimating];
    [view addSubview:animView];
    // create the loading icon
    
//    UIImageView *loadIconView = [[UIImageView alloc] initWithImage:loadIcon];
//    loadIconView.frame = CGRectMake(0, 0, loadIcon.size.width, loadIcon.size.height);
//    loadIconView.center = CGPointMake(view.bounds.size.width/2 , view.bounds.size.height/2);
//    [view addSubview:loadIconView];
//    [loadIconView continueRotateAnimation];
    
    
    
    return view;
}


+ (UIBarButtonItem *)createRightButtonItemForTarget:(id)target action:(SEL)action
{
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];

    UIImage *backImage = [[UIImage storeImageNamed:@"search_bar_icon@3x.png"] scaledImageFrom3x];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton setBackgroundImage:[[UIImage storeImageNamed:@"search_bar_icon@3x.png"] scaledImageFrom3x] forState:UIControlStateHighlighted];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    
    UIBarButtonItem *result = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    return result;
}

+ (UIBarButtonItem *)createRightButtonItemForTarget:(id)target action:(SEL)action title:(NSString*)titleStr leftSpace:(CGFloat)left
{
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
//    UIImage *backImage = [UIImage storeImageNamed:@"search_bar_icon.png"];
    [backButton setTitle:titleStr forState:UIControlStateNormal];
    [backButton setTitle:titleStr  forState:UIControlStateHighlighted];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, left, 0, 0)];
    backButton.frame = CGRectMake(0, 0, 60, 30);
    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *result = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    return result;
}

+ (UIBarButtonItem *)createBackBarButtonItemForGreenTarget:(id)target action:(SEL)action
{
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *backTitle = NSLocalizedString(@"Back", @"the title for the back butotn of view controllers");
    backTitle = [NSString stringWithFormat:@"   %@", backTitle];
    [backButton setTitle:backTitle forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIImage *backImage = [[UIImage storeImageNamed:@"back_button@3x.png"] scaledImageFrom3x];
    [backButton setImage:backImage forState:UIControlStateNormal];
    UIImage *image2 = [UIImage storeImageNamed:@"back_button@3x.png"];
    CGFloat top = 0; // 顶端盖高度
    CGFloat bottom = 0 ; // 底端盖高度
    CGFloat left = 15; // 左端盖宽度
    CGFloat right = 15; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    image2 = [image2 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];

    [backButton setImage:[image2 scaledImageFrom3x] forState:UIControlStateHighlighted];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    
    backButton.exclusiveTouch = YES;
    
    UIBarButtonItem *result = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    return result;
}

+ (UIBarButtonItem *)createBackBarButtonItemForGreenTarget:(id)target action:(SEL)action image:(NSString*)imageName selectedImage:(NSString*)selectedImgName {
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *backImage = [UIImage storeImageNamed:imageName];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton setImage:[UIImage storeImageNamed:selectedImgName] forState:UIControlStateHighlighted];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 59, 0, 0)];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 2, 30, 30);
    
    backButton.exclusiveTouch = YES;
    
    UIBarButtonItem *result = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    return result;
}

+ (UIBarButtonItem *)createBarButtonItemForGreenTarget:(id)target action:(SEL)action image:(NSString*)imageName selectedImage:(NSString*)selectedImgName {
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *backImage = [UIImage storeImageNamed:imageName];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton setImage:[UIImage storeImageNamed:selectedImgName] forState:UIControlStateHighlighted];
    if ([imageName isEqualToString:@"myGift.png"]) {
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
        [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [backButton setTitle:@"我的礼包" forState:UIControlStateNormal];
        backButton.titleLabel.font = [UIFont systemFontOfSize:14];
        backButton.frame = CGRectMake(0, 2, 80, 30);
    }
    else {
        backButton.frame = CGRectMake(0, 2, 50, 30);
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 21)];
    }
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    
    backButton.exclusiveTouch = YES;
    
    UIBarButtonItem *result = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    return result;
}

+ (UIButton *)createButtonForTarget:(id)target action:(SEL)action image:(NSString*)imageName selectedImage:(NSString*)selectedImgName {
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *backTitle = @"返回";
    backTitle = [NSString stringWithFormat:@"   %@", backTitle];
    [backButton setTitle:backTitle forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0);
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIImage *backImage = [UIImage storeImageNamed:imageName];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage storeImageNamed:selectedImgName] forState:UIControlStateHighlighted];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(10, 2, backImage.size.width, backImage.size.height);
    
    backButton.exclusiveTouch = YES;
    
    
    return backButton;
}


+ (UIBarButtonItem *)createUpdateAllItemForTarget:(id)target action:(SEL)action
{
    
    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
//    UIImage *updateImage = [UIImage storeImageNamed:@"updateall_normal.png"];
    
//    [updateButton setBackgroundImage:updateImage forState:UIControlStateNormal];
    [updateButton setTitle:@"全部更新" forState:UIControlStateNormal];
    //e0effd
    [updateButton setTitleColor:[UIColor colorForHex:@"#007aff"] forState:UIControlStateNormal];
    
    //#bfdefb
    [updateButton setTitleColor:[UIColor colorForHex:@"#007aff"] forState:UIControlStateHighlighted];
    [updateButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 0)];
//    [updateButton setBackgroundColor:[UIColor redColor]];
//    [updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [updateButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [updateButton setBackgroundImage:[UIImage storeImageNamed:@"updateall_down.png"] forState:UIControlStateHighlighted];
//    [updateButton setBackgroundImage:[UIImage storeImageNamed:@"updateall_disabled.png"] forState:UIControlStateDisabled];
    [updateButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    updateButton.frame = CGRectMake(0, 10, 60, 44);
    
    UIBarButtonItem *result = [[UIBarButtonItem alloc] initWithCustomView:updateButton];
    
    
    return result;
}

+ (UIView*)createPadHeaderView:(NSString*)title width:(CGFloat)width{
    UIView* headerView = [[UIView alloc]initWithFrame: CGRectMake(0,0, 1024, SEGMENTED_BAR_HEIGHT)];
//    headerView.autoresizingMask = headerView.autoresizingMask | UIViewAutoresizingFlexibleWidth;
    UILabel* titleLab = [[UILabel alloc] initWithFrame:CGRectMake((1024-420)/2.0,0, 420, SEGMENTED_BAR_HEIGHT)];
    [headerView addSubview:titleLab];
    titleLab.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    titleLab.textAlignment = UITextAlignmentCenter;
    titleLab.font = [UIFont boldSystemFontOfSize:20];
    titleLab.textColor = [UIColor darkGrayColor];
    titleLab.text = title;
    titleLab.backgroundColor = [UIColor clearColor];
    headerView.backgroundColor =[UIColor colorForHex:@"#eaedf1"];
    return headerView;
}


@end
