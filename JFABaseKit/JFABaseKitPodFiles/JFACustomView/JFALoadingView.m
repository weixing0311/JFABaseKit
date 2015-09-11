//
//  JFALoadingView.m
//  JFABaseKit
//
//  Created by stefan on 15/8/28.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import "JFALoadingView.h"

@interface JFALoadingView ()
{
    UIImageView* loadingIcon;
    UIView* contentView;
    UILabel* label;
}
@end

@implementation JFALoadingView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        contentView = [[UIView alloc] initWithFrame:self.bounds];
        contentView.tag=998;
        [self addSubview:contentView];
        
        // create the loading icon
        UIImage *loadIcon = [self loadingImage];
        loadingIcon = [[UIImageView alloc] initWithImage:loadIcon];
        loadingIcon.frame = CGRectMake(0, 0, loadIcon.size.width, loadIcon.size.height);
        [contentView addSubview:loadingIcon];
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setBackgroundColor:[UIColor clearColor]];
        [label sizeToFit];
        [contentView addSubview:label];
        
        [self resetSubViews];
    }
    return self;
}
+ (UIView *)createLoadingServiceViewWithFrame:(CGRect)frame autoLayout:(BOOL)autoLayout
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
//    if ([AIApplicationUtility isiPadDevice]) {
//        loadIcon = [UIImage storeImageNamed:@"loading_view_icon_pad"];
//    }else{
        loadIcon = [UIImage storeImageNamed:@"loading_view_icon_pad"];
//    }
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
//    if ([AIApplicationUtility isiPadDevice]) {
//        label.frame=CGRectMake(0, loadIcon.size.height + 22, 0, 0);
//    }
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
-(void)resetSubViews
{
    label.text = NSLocalizedString(@"正在加载", @"");
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15.0];
    
    CGFloat contentViewWidth = loadingIcon.frame.size.width > label.frame.size.width ? loadingIcon.frame.size.width : label.frame.size.width;
    CGFloat contentViewHeight = label.frame.origin.y + label.frame.size.height;
    CGFloat x = self.frame.size.width / 2.0 - contentViewWidth / 2.0;
    
    CGFloat offset = 0;
    
    CGFloat y = self.frame.size.height / 2.0 - contentViewHeight / 2.0 - offset;
    contentView.frame = CGRectMake(x, y, contentViewWidth, contentViewHeight);
    
    CGRect rect = loadingIcon.frame;
    rect.origin.y = 0;
    rect.origin.x = contentViewWidth / 2.0 - loadingIcon.frame.size.width / 2.0;
    loadingIcon.frame = rect;
    
    rect = label.frame;
    rect.origin.y = loadingIcon.frame.origin.y + loadingIcon.frame.size.height + 22;
    rect.origin.x = contentViewWidth / 2.0 - label.frame.size.width / 2.0;
    label.frame = rect;
    
    loadingIcon.tag = 200001;
    
    [loadingIcon continueRotateAnimation];


}

-(UIImage*)loadingImage
{
    return [UIImage imageNamed:@"loading"];
}

-(void)stoploading
{
    self.hidden=YES;
//    [loadingIcon stopRotateAnimation];
}

-(void)startloading
{
    self.hidden=NO;
//    [loadingIcon continueRotateAnimation];
}

@end
