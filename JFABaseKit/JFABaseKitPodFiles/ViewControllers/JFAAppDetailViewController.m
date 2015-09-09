//
//  JFAAppDetailViewController.m
//  JFAAppStoreHelper
//
//  Created by 魏星 on 15/9/8.
//  Copyright © 2015年 JF. All rights reserved.
//

#import "JFAAppDetailViewController.h"

@interface JFAAppDetailViewController ()
{
    //    BOOL _shotClicked;
    CGFloat _footHight;
    BOOL _registerInstalled;
    BOOL _registerDownload;
}

//@property (nonatomic, strong) JFAWebImageBrowserController *screenshotBrowser;
//@property (nonatomic, strong) JFAWebImageBrowserController *fullscreenBrowser;
@property (nonatomic, assign) BOOL fullscreenBrowserPresented;

@property (nonatomic, retain) UITapGestureRecognizer *imageInTap;
@property (nonatomic, retain) UIView * imagesContainer;
@property (nonatomic, retain) NSArray *images;
//@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UIButton * downloadBg;
//@property (nonatomic, strong) LocalApp * installedApp;
//@property (nonatomic, strong) LocalApp * downloadApp;
//@property (nonatomic, strong) AIAppDetailHeaderView * headerView;
//@property (nonatomic, strong) AIManagedImageV *imageView;
@property (nonatomic, strong) UIView * detailFooterView;
//@property (nonatomic, strong) AIRetrieveAppDetailService * getDetailService;
//@property (nonatomic, strong) AIDetailBrief * editDes;
//@property (nonatomic, strong) AIDetailAppsView * appsView;
@property (nonatomic, strong) UIView * footLine;
@property (nonatomic, strong) NSString* setupProgress;
@property (nonatomic, strong) NSString *downloadType;
@property (nonatomic, strong) NSString *safariUrl;
@property (nonatomic, assign) BOOL isShowUpdateAlert;

@end

@implementation JFAAppDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.title = NSLocalizedString(@"应用详情", @"");
    [super viewDidLoad];
    
        [self createDefaultNavigationBar];
        [self.view setBackgroundColor:[UIColor colorForHex:@"#ffffff"]];
    
        self.errorView.frame = CGRectMake(0, SEGMENTED_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - SEGMENTED_BAR_HEIGHT);
        
        [self initLoadingView];
        
//        [self tempInit];
    
    

}

-(void)setInstallProgress:(NSNotification*)not
{
    self.setupProgress=not.object;
    [self setApp:self.app];
    [self performSelectorOnMainThread:@selector(updateProgressOnMainWithProgress:) withObject:[NSString stringWithFormat:@"%@%%",not.object] waitUntilDone:YES];
}

-(void)updateProgressOnMainWithProgress:(NSString*)progress
{
    UIColor* textColor = AI_MAIN_DARK_BLUECOLOR;
    UIColor* bgColor = AI_MAIN_BLUECOLOR;
    float width = 0;
    NSUInteger location = [progress rangeOfString:@"%"].location;
    if (location != NSNotFound) {
        CGFloat percent = [progress substringToIndex:location].floatValue / 100.0f;
        width = percent * self.downloadBtn.frame.size.width;
    }
    
    self.downloadBtn.enabled = NO;
    self.downloadBtn.layer.borderColor = bgColor.CGColor;
    self.downloadBg.backgroundColor = bgColor;
    CGRect frame = self.downloadBg.frame;
    frame.size.width = width;
    self.downloadBg.frame = frame;
    [self.downloadBtn setTitle:progress forState:UIControlStateNormal];
    [self.downloadBtn setTitle:progress forState:UIControlStateDisabled];
    
    [self.downloadBtn setTitleColor:textColor forState:UIControlStateNormal];
    [self.downloadBtn setTitleColor:textColor forState:UIControlStateDisabled];
}

-(void)startInstallApp:(NSNotification*)not
{
    self.setupProgress=@"0";
    [self setApp:self.app];
    [self updateButtonState];
}

- (void)createDefaultNavigationBar {
    [super createDefaultNavigationBar];
    
    [self.jfa_navigationBar.leftButton removeTarget:self.jfa_navigationController
                                             action:@selector(popViewController)
                                   forControlEvents:UIControlEventTouchUpInside];
    [self.jfa_navigationBar.leftButton addTarget:self
                                          action:@selector(navigationBack:)
                                forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)navigationBack:(id)sender
{
    
    if (self.rootDetailVC) {
        
        [self.jfa_navigationController popToViewController:self.rootDetailVC];
    }
    else {
        
        [self.jfa_navigationController popViewController];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showHeaderView
{
    self.headerView = [[AIAppDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,88 /*(self.app.short_brief)?36:92*/)];
    self.headerView.app = self.app;
    DLog(@"appstar = %d",[self.app.star intValue]);
    self.headerView.delegate=self;
    [scrollView addSubview:self.headerView];
    if (self.app.short_brief) {
        self.editDes = [[[AIApplicationUtility xibBundle] loadNibNamed:@"AIDetailBrief" owner:nil options:nil] objectAtIndex:0];
        [self.editDes setTitle:@"小编推荐"];
        [self.editDes setDesStr:self.app.short_brief show:NO];
        [self.editDes setHeight:[self.editDes getHeight]];
        self.editDes.frame = CGRectMake(0, HEAD_HEIGHT, self.view.frame.size.width, [self.editDes getHeight]);
        
        self.editDes.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
        //        [scrollView addSubview:self.editDes];
        [self.editDes setButtonUI:NO more:NO];
        self.editDes.line.hidden = YES;
    }
}

- (void)showImages
{
    [_imagesContainer removeFromSuperview];
    _imagesContainer = nil;
    if (self.app.imageSummary.length > 0) {
        CGSize imagesViewSize = IMAGE_WALL_SIZE;
        imagesViewSize.width = AI_SCREEN_WIDTH - 24;
        DLog(@"originY : %f",HEAD_HEIGHT + [self.editDes getHeight]);
        DLog(@"edit originY : %f",self.editDes.frame.origin.y);
        _imagesContainer = [[UIView alloc] initWithFrame:CGRectMake(0.0, HEAD_HEIGHT, self.view.frame.size.width, imagesViewSize.height + 24)];
        //        _imagesContainer = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0, self.view.frame.size.width, imagesViewSize.height + 24)];
        
        [_imagesContainer setBackgroundColor:[UIColor colorForHex:@"#ffffff"]];
        [scrollView addSubview:_imagesContainer];
        UIView*line = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, .5f)];
        line.backgroundColor = [UIColor colorWithRed:0xc9 / 255.0f green:0xc9 / 255.0f blue:0xc9 / 255.0f alpha:.8];
        line.autoresizingMask = line.autoresizingMask | UIViewAutoresizingFlexibleWidth;
        [_imagesContainer addSubview:line];
        
        NSMutableArray *screenshotUrls = (NSMutableArray*)[self.app.imageSummary componentsSeparatedByString:@","];
        DLog(@"url = %@",screenshotUrls);
        
        
        NSMutableArray * secondscreenshotUrls = [NSMutableArray arrayWithArray:screenshotUrls];
        
        NSString *videoType = [[NSUserDefaults standardUserDefaults]objectForKey:AIVIDEO]?[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:AIVIDEO]]:0;
        NSString * avplayerStr = self.app.avplayerUrlStr;
        NSString * avplayerImageStr = self.app.avplayerImageStr;
        if (avplayerStr&&avplayerStr.length>0&&[videoType isEqualToString:@"1"]) {
            [screenshotUrls insertObject:avplayerImageStr?avplayerImageStr:@"" atIndex:0];
        }
        
        PSTCollectionViewFlowLayout *collectionViewLayout = [[PSTCollectionViewFlowLayout alloc] init];
        collectionViewLayout.scrollDirection = PSTCollectionViewScrollDirectionHorizontal;
        collectionViewLayout.itemSize = CGSizeMake(196.0, 356);
        collectionViewLayout.minimumInteritemSpacing = 12;
        self.screenshotBrowser = [[JFAWebImageBrowserController alloc] initWithImageUrls:screenshotUrls
                                                                    collectionViewLayout:collectionViewLayout
                                                                           pagingEnabled:NO];
        if (avplayerStr&&avplayerStr.length>0&&[videoType isEqualToString:@"1"]) {
            self.screenshotBrowser.isPlayMp4 = YES;
        }else{
            self.screenshotBrowser.isPlayMp4 = NO;
        }
        self.screenshotBrowser.delegate = self;
        self.screenshotBrowser.isFromWallPaper = NO;
        self.screenshotBrowser.view.backgroundColor = [UIColor colorForHex:@"#ffffff"];
        self.screenshotBrowser.view.frame = CGRectMake(12, 12, imagesViewSize.width , imagesViewSize.height);
        [_imagesContainer addSubview:self.screenshotBrowser.view];
        
        __weak AppDetailViewController *weakSelf = self;
        self.screenshotBrowser.imageSelectionHandler = ^(NSInteger selectionIndex, PSTCollectionView *collectionView) {
            if (weakSelf.fullscreenBrowserPresented) {
                return;
            }
            PSTCollectionViewLayoutAttributes *layoutAttributes = [collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:selectionIndex inSection:0]];
            UIImage *image = [weakSelf.screenshotBrowser imageForIndex:selectionIndex];
            
            /* UIImageView+Webcache  需添加如下代码保持详情图片方向一致
             *
             *
             *
             *  if ((wself.frame.size.width < wself.frame.size.height) && image.size.width > image.size.height) {
             wself.image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationLeft];
             }
             *
             *
             *
             *加在  - (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock  里
             */
            
            if (image.size.width > image.size.height) {
                image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationLeft];
            }
            
            
#pragma mark ----播放视频方法
            
            if (avplayerStr&&avplayerStr.length>0&&selectionIndex ==0&&[videoType isEqualToString:@"1"]) {
                [weakSelf playMoiveWithUrl:avplayerStr videoType:videoType];
                return;
            }
            if (image) {
                //                if (avplayerStr&&avplayerStr.length>0&&selectionIndex==0&&videoType&&[videoType isEqualToString:@"1"]) {
                //                    //                    [AIMediaPlayMP4 instance].PlayVC = weakSelf;
                //                    //                    [[AIMediaPlayMP4 instance]createMp4PlayerWithUrl:[NSString stringWithFormat:@"%@",avplayerStr]];
                //                    NSArray *array = [avplayerStr componentsSeparatedByString:@"mp4"];
                //
                //                    NSString * urlStr = [NSString stringWithFormat:@"%@mp4",array[0]];
                //
                //                    AIMPMoviePlayerViewController *mpv =[[ AIMPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:urlStr]];
                //                    [mpv.moviePlayer prepareToPlay];
                //
                //                    [weakSelf presentViewController:mpv animated:YES completion:^{
                //
                //                    }];
                //
                //                    [mpv.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
                //
                //                    [mpv.view setBackgroundColor:[UIColor clearColor]];
                //
                //                    [mpv.view setFrame:weakSelf.view.bounds];
                //
                //                    [[NSNotificationCenter defaultCenter] addObserver:weakSelf
                //                                                             selector:@selector(movieFinishedCallback:)
                //                                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                //                                                               object:mpv.moviePlayer];
                //                    return;
                //                }
                
                
                UIView *window = weakSelf.view.window;
                CGRect frame = [collectionView convertRect:layoutAttributes.frame toView:window];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
                imageView.image = image;
                DLog(@"w = %f, h = %f",image.size.width,image.size.height);
                [window addSubview:imageView];
                [window bringSubviewToFront:imageView];
                imageView.alpha = 0;
                weakSelf.fullscreenBrowserPresented = YES;
                [UIView animateWithDuration:0.3
                                      delay:0
                                    options:UIViewAnimationOptionAllowUserInteraction
                                 animations:^{
                                     [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
                                     imageView.alpha = 1;
                                     imageView.frame = window.bounds;
                                 } completion:^(BOOL finished) {
                                     PSTCollectionViewFlowLayout *collectionViewLayout = [[PSTCollectionViewFlowLayout alloc] init];
                                     collectionViewLayout.scrollDirection = PSTCollectionViewScrollDirectionHorizontal;
                                     collectionViewLayout.minimumLineSpacing = 0;
                                     collectionViewLayout.minimumInteritemSpacing = 0;
                                     collectionViewLayout.itemSize = window.bounds.size;
                                     weakSelf.fullscreenBrowser = [[JFAWebImageBrowserController alloc] initWithImageUrls:secondscreenshotUrls
                                                                                                     collectionViewLayout:collectionViewLayout];
                                     weakSelf.fullscreenBrowser.delegate = weakSelf;
                                     weakSelf.fullscreenBrowser.view.frame = window.bounds;
                                     [window addSubview:weakSelf.fullscreenBrowser.view];
                                     [weakSelf.fullscreenBrowser.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:avplayerStr&&[videoType isEqualToString:@"1"]?selectionIndex-1:selectionIndex inSection:0]
                                                                                       atScrollPosition:PSTCollectionViewScrollPositionCenteredHorizontally
                                                                                               animated:NO];
                                     [imageView removeFromSuperview];
                                     weakSelf.fullscreenBrowser.imageSelectionHandler = ^(NSInteger selectionIndex, PSTCollectionView *collectionView) {
                                         [UIView animateWithDuration:0.3
                                                               delay:0
                                                             options:UIViewAnimationOptionAllowUserInteraction
                                                          animations:^{
                                                              weakSelf.fullscreenBrowser.view.alpha = 0;
                                                              [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                                                          } completion:^(BOOL finished) {
                                                              [weakSelf.fullscreenBrowser.view removeFromSuperview];
                                                              weakSelf.fullscreenBrowserPresented = NO;
                                                          }];
                                     };
                                 }];
            }else{
                //                [weakSelf showImages];
            }
        };
    }
}

#pragma mark----播放视频通知返回


-(void)movieStateChangeCallback:(NSNotification*)notify  {
    
    //点击播放器中的播放/ 暂停按钮响应的通知
    
}

-(void)movieFinishedCallback:(NSNotification*)notify{
    
    // 视频播放完或者在presentMoviePlayerViewControllerAnimated下的Done按钮被点击响应的通知。
    
    MPMoviePlayerController* theMovie = [notify object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
     
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
     
                                                  object:theMovie];
    [theMovie.view removeFromSuperview];
    
    [self dismissMoviePlayerViewControllerAnimated];
    
}

- (void)showDetailView
{
    if (detailView) {
        detailView.delegate = nil;
        [detailView removeFromSuperview];
    }
    detailView = [[AppDetailView alloc] initWithFrame:CGRectMake(0, _imagesContainer.frame.origin.y + _imagesContainer.frame.size.height, self.view.frame.size.width, 250)];
    detailView.delegate = self;
    detailView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [scrollView addSubview:detailView];
    
    detailView.app = self.app;
    CGSize detailViewSize = [detailView sizeThatFits:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    detailView.frame = CGRectMake(0, _imagesContainer.frame.origin.y + _imagesContainer.frame.size.height + 10, self.view.frame.size.width, detailViewSize.height);
}

- (void)showCommentsView
{
    [commentsView removeFromSuperview];
    commentsView = nil;
    if (self.app.comments.count > 0) {
        
        commentsView = [[AppCommentsView alloc] initWithFrame:CGRectZero];
        commentsView.app = self.app;
        
        CGRect commentsFrame;
        if (detailView) {
            commentsFrame = CGRectMake(0, detailView.frame.origin.y + detailView.frame.size.height, scrollView.frame.size.width, 0);
        } else {
            commentsFrame = CGRectMake(0, _imagesContainer.frame.origin.y + _imagesContainer.frame.size.height - 8, scrollView.frame.size.width, 0);
        }
        CGSize commentsSize = [commentsView sizeThatFits:self.view.bounds.size];
        commentsFrame.size = commentsSize;
        commentsView.frame = commentsFrame;
        [scrollView addSubview:commentsView];
    }
}

- (void)showBottomView
{
    //    if (self.bottomView) {
    //        [self.bottomView removeFromSuperview];
    //    }
    //    CGFloat y = self.view.bounds.size.height - BOTTOM_VIEW_HEIGHT;
    //    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, BOTTOM_VIEW_HEIGHT)];
    //    [self.bottomView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    //    self.bottomView.layer.cornerRadius = 2.0f;
    //    self.bottomView.layer.masksToBounds = YES;
    //    [self.bottomView.layer setBorderColor:[UIColor colorForHex:@"#CCCCCC"].CGColor];
    //    [self.bottomView.layer setBorderWidth:1.0];
    //    [self.bottomView setBackgroundColor:[UIColor colorForHex:@"#F5F5F5"]];
    if (self.downloadBtn) {
        [self.downloadBtn removeFromSuperview];
        [self.downloadBtn removeTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.downloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    [self.downloadBtn setTitle:@"立即下载" forState:UIControlStateNormal];
    self.downloadBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:18];
    [self.downloadBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.downloadBtn.layer.masksToBounds = YES;
    //    self.downloadBtn.layer.cornerRadius = 5;
    //    self.downloadBtn.layer.borderWidth = 1;
    //    self.downloadBtn.layer.borderColor = AI_MAIN_BLUECOLOR.CGColor;
    self.downloadBg = [[UIButton alloc] initWithFrame:(CGRect){CGPointZero,self.downloadBtn.frame.size}];
    self.downloadBg.userInteractionEnabled = NO;
    self.downloadBg.backgroundColor = [UIColor colorForHex:@"#007aff"];
    [self.downloadBtn insertSubview:self.downloadBg belowSubview:self.downloadBtn.titleLabel];
    [self.view addSubview:self.downloadBtn];
}

- (void)showDetailFooterView
{
    if (self.detailFooterView) {
        
        [self.detailFooterView removeFromSuperview];
        [self.footLine removeFromSuperview];
    }
    
    CGRect rect = detailView.frame;
    if (commentsView) {
        rect = commentsView.frame;
    }
    
    CGFloat y = rect.origin.y + rect.size.height + 10;
    self.footLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, .5f)];
    self.footLine.backgroundColor = [UIColor colorWithRed:0xc9 / 255.0f green:0xc9 / 255.0f blue:0xc9 / 255.0f alpha:.8];
    self.footLine.autoresizingMask = self.footLine.autoresizingMask | UIViewAutoresizingFlexibleWidth;
    [scrollView addSubview:self.footLine];
    self.detailFooterView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_MARGIN, y, self.view.bounds.size.width - LEFT_MARGIN * 2, _footHight)];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.detailFooterView.frame.size.width, 0)];
    [label setFont:[UIFont boldSystemFontOfSize:15.0]];
    label.textColor = [UIColor blackColor];
    [label setBackgroundColor:[UIColor clearColor]];
    label.text = NSLocalizedString(@"其他信息", @"");
    [label sizeToFit];
    [self.detailFooterView addSubview:label];
    
    rect = label.frame;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, rect.origin.y + rect.size.height + 9, 48, 13)];
    [label setFont:[UIFont systemFontOfSize:12.0]];
    label.textColor = [UIColor colorForHex:@"#999999"];
    [label setBackgroundColor:[UIColor clearColor]];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"语言";
    //    [label sizeToFit];
    [self.detailFooterView addSubview:label];
    CGFloat width = self.detailFooterView.frame.size.width - 55;
    rect = label.frame;
    label = [[UILabel alloc] initWithFrame:CGRectMake(55, rect.origin.y, width, 0)];
    [label setFont:[UIFont systemFontOfSize:12.0]];
    label.textColor = [UIColor grayColor];
    [label setBackgroundColor:[UIColor clearColor]];
    NSString* language = self.app.language && [self.app.language isEqualToString:@"1"] ? @"中文" : (self.app.language && [self.app.language isEqualToString:@"2"] ? @"英文" : @"其他");
    label.text = language;
    [label sizeToFit];
    [self.detailFooterView addSubview:label];
    
    rect = label.frame;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, rect.origin.y + rect.size.height + 9, 48, 13)];
    [label setFont:[UIFont systemFontOfSize:12.0]];
    label.textColor = [UIColor colorForHex:@"#999999"];
    [label setBackgroundColor:[UIColor clearColor]];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"分类";
    //    [label sizeToFit];
    [self.detailFooterView addSubview:label];
    
    rect = label.frame;
    label = [[UILabel alloc] initWithFrame:CGRectMake(55, rect.origin.y, width, 0)];
    [label setFont:[UIFont systemFontOfSize:12.0]];
    label.textColor = [UIColor colorForHex:@"#666666"];
    [label setBackgroundColor:[UIColor clearColor]];
    NSString* category = [self.app.category isEqualToString:@"1"] ? @"软件" : @"游戏";
    label.text = category;
    [label sizeToFit];
    [self.detailFooterView addSubview:label];
    
    if(self.app.developer != nil && self.app.developer.length > 0){
        rect = label.frame;
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, rect.origin.y + rect.size.height + 9, 48, 13)];
        [label setFont:[UIFont systemFontOfSize:12.0]];
        label.textColor = [UIColor colorForHex:@"#999999"];
        [label setBackgroundColor:[UIColor clearColor]];
        label.text = @"开发商";
        label.textAlignment = NSTextAlignmentRight;
        //    [label sizeToFit];
        [self.detailFooterView addSubview:label];
        rect = label.frame;
        label = [[UILabel alloc] initWithFrame:CGRectMake(55, rect.origin.y, width, 0)];
        [label setFont:[UIFont systemFontOfSize:12.0]];
        label.textColor = [UIColor colorForHex:@"#666666"];
        [label setBackgroundColor:[UIColor clearColor]];
        label.text = self.app.developer;
        [label sizeToFit];
        if (label.frame.size.width > width) {
            CGRect rect = label.frame;
            NSInteger lines = label.frame.size.width / width;
            int value1 = (int)label.frame.size.width;
            int value2 = (int)width;
            if (value1 % value2) {
                lines += 1;
            }
            rect.size.height = rect.size.height * lines;
            rect.size.width = width;
            label.frame = rect;
            label.numberOfLines = 0;
        }
        [self.detailFooterView addSubview:label];
    }
    
    
    rect = label.frame;
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, rect.origin.y + (rect.size.height > 13 ? rect.size.height : 13) + 9, 48, 13)];
    [label setFont:[UIFont systemFontOfSize:12.0]];
    label.textColor = [UIColor colorForHex:@"#999999"];
    label.textAlignment = NSTextAlignmentRight;
    [label setBackgroundColor:[UIColor clearColor]];
    label.text = @"系统要求";
    //    [label sizeToFit];
    [self.detailFooterView addSubview:label];
    
    rect = label.frame;
    label = [[UILabel alloc] initWithFrame:CGRectMake(55, rect.origin.y, width, 0)];
    [label setFont:[UIFont systemFontOfSize:12.0]];
    label.textColor = [UIColor grayColor];
    [label setBackgroundColor:[UIColor clearColor]];
    label.text = self.app.minOSVersion;
    [label sizeToFit];
    [self.detailFooterView addSubview:label];
    _footHight = label.frame.origin.y + label.frame.size.height;
    self.detailFooterView.frame = CGRectMake(LEFT_MARGIN, y, self.view.bounds.size.width - LEFT_MARGIN * 2, _footHight);
    [scrollView addSubview:self.detailFooterView];
    
}

- (void)showAppsView {
    if (self.appsView) {
        [self.appsView removeFromSuperview];
    }
    self.appsView = [[[AIApplicationUtility xibBundle] loadNibNamed:@"AIDetailAppsView" owner:nil options:nil] objectAtIndex:0];
    self.appsView.frame = (CGRect){{0,self.detailFooterView.frame.origin.y + self.detailFooterView.frame.size.height},self.appsView.frame.size};
    self.appsView.appDelegate = self;
    self.appsView.parent = self.parent;
    if (_app.recsoftlist.count > 0) {
        self.appsView.hidden = NO;
        [self.appsView setAppArray:_app.recsoftlist];
    }
    else {
        self.appsView.hidden = YES;
    }
    
    [scrollView addSubview:self.appsView];
}
//-(void)showDefaultViewForApp
//{
//    if (self.app != nil) {
//        [scrollView removeFromSuperview];
//
//        CGRect rect = self.view.bounds;
//        rect.size.height -= BOTTOM_VIEW_HEIGHT;
//        scrollView = [[UIScrollView alloc] initWithFrame:rect];
//        scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        scrollView.delegate = self;
//        scrollView.scrollEnabled = YES;
//        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
//        [self.contentView addSubview:scrollView];
//        [self showHeaderView];
////        [self showImages];
////        [self showDetailView];
////        [self showCommentsView];
////        [self showDetailFooterView];
////        [self showAppsView];
//
//        CGSize contentSize = CGSizeMake(self.view.frame.size.width, self.headerView.frame.size.height);
//
//        if (_imagesContainer) {
//            contentSize.height += _imagesContainer.frame.size.height;
//        }
//
//        if (detailView != nil) {
//            contentSize.height += detailView.frame.size.height;
//        }
//
//        if (commentsView != nil) {
//            contentSize.height += commentsView.frame.size.height;
//        }
//
//        if (self.detailFooterView != nil) {
//            contentSize.height += self.detailFooterView.frame.size.height;
//        }
//        [scrollView setContentSize:contentSize];
//
//        [self showBottomView];
//        [self updateButtonState];
//    }
//
//}

- (void)showViewForApp
{
    [self hideLoadingView];
    if (self.app != nil) {
        [scrollView removeFromSuperview];
        
        CGRect rect = self.view.bounds;
        rect.origin.y += self.jfa_navigationBar.frame.size.height;
        rect.size.height -= BOTTOM_VIEW_HEIGHT + self.jfa_navigationBar.frame.size.height ;
        scrollView = [[UIScrollView alloc] initWithFrame:rect];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        scrollView.delegate = self;
        scrollView.scrollEnabled = YES;
        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
        [self.contentView addSubview:scrollView];
        [self showHeaderView];
        [self showImages];
        [self showDetailView];
        [self showCommentsView];
        [self showDetailFooterView];
        [self showAppsView];
        
        CGSize contentSize = CGSizeMake(self.view.frame.size.width, self.headerView.frame.size.height);
        
        if (_imagesContainer) {
            contentSize.height += _imagesContainer.frame.size.height;
        }
        
        if (detailView != nil) {
            contentSize.height += detailView.frame.size.height;
        }
        
        if (commentsView != nil) {
            contentSize.height += commentsView.frame.size.height;
        }
        
        if (self.detailFooterView != nil) {
            contentSize.height += self.detailFooterView.frame.size.height;
        }
        [scrollView setContentSize:contentSize];
        [self showBottomView];
        [self updateButtonState];
        
        
        
    }
}


- (void)layoutViews
{
    
    if (self.headerView) {
        CGRect rect = self.headerView.frame;
        rect.origin.y = 0.0;
        self.headerView.frame = rect;
    }
    
    if (_imagesContainer) {
        CGRect rect = _imagesContainer.frame;
        rect.origin.y = self.headerView.frame.origin.y + self.headerView.frame.size.height;
        if (self.app.short_brief) {
            rect.origin.y = self.headerView.frame.origin.y + self.headerView.frame.size.height;
        }
        _imagesContainer.frame = rect;
    }
    
    if (detailView) {
        
        CGSize detailViewSize = [detailView sizeThatFits:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
        CGFloat y = self.headerView.frame.origin.y + self.headerView.frame.size.height + 30;
        if (_imagesContainer) {
            
            y = _imagesContainer.frame.origin.y + _imagesContainer.frame.size.height;
        }
        detailView.frame = CGRectMake(0, y, self.view.frame.size.width, detailViewSize.height);
    }
    
    if (commentsView) {
        CGRect rect = commentsView.frame;
        rect.origin.y = detailView.frame.origin.y + detailView.frame.size.height;
        commentsView.frame = rect;
    }
    
    if (self.detailFooterView) {
        CGRect rect = detailView.frame;
        self.footLine.frame = CGRectMake(0, rect.origin.y + rect.size.height, self.view.bounds.size.width, .5);
        self.detailFooterView.frame = CGRectMake(LEFT_MARGIN, rect.origin.y + rect.size.height + 10, self.view.frame.size.width - LEFT_MARGIN * 2, _footHight);
    }
    
    if (self.appsView) {
        CGRect rect = self.detailFooterView.frame;
        self.appsView.frame = CGRectMake(0, rect.origin.y + rect.size.height + 5, self.view.frame.size.width, self.appsView.frame.size.height);
    }
    
    CGSize contentSize = CGSizeMake(self.view.frame.size.width, self.headerView.frame.size.height);
    
    if (_imagesContainer) {
        contentSize.height += _imagesContainer.frame.size.height;
    }
    if (self.app.short_brief) {
        contentSize.height += self.editDes.frame.size.height;
    }
    
    if (detailView != nil) {
        contentSize.height += detailView.frame.size.height;
    }
    
    if (commentsView != nil) {
        contentSize.height += commentsView.frame.size.height;
    }
    
    if (self.detailFooterView) {
        contentSize.height += self.detailFooterView.frame.size.height;
    }
    if (self.appsView && !self.appsView.isHidden) {
        contentSize.height += self.appsView.frame.size.height;
    }
    
    contentSize.height += 0;
    [scrollView setContentSize:contentSize];
}

- (void)btnPressed:(UIButton *)btn
{
    if ([self.parent isEqualToString:@"Push_Notification"]) {
        [[AILogCenter defaultCenter] sendActiveEvent:@"19000010002x"];
    }
    
    if (btn == self.downloadBtn) {
        
        if (self.downloadType) {
            NSString *downloadType = self.downloadType;
            DLog(@"doenloadType = %@",downloadType);
            // 下载方式  0：直接下载  1：跳Safari页面   2:跳APP itunes页  3:应用内itunes页
            if ([downloadType isEqualToString:@"0"]){
                [self download];
                
            }else if ([downloadType isEqualToString:@"1"]){
                [[AILogCenter defaultCenter] sendActiveEvent:@"1700001" adv:@"1"];
                
                NSString *str = [self.safariUrl stringByAppendingFormat:@"&me=%@&me2=%@",[[myAppInfo udidString] md5String],[[myAppInfo udidString2] md5String]];
                DLog(@"webUrl = %@",str);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                
            }else if ([downloadType isEqualToString:@"3"]){
                [[AILogCenter defaultCenter] sendActiveEvent:@"1700001" adv:@"3"];
                if (IOS6_EARLY) {
                    [self download];
                }else{
                    [[AIInstallManager sharedInstance] installThroughAppStore:self.app];
                }
            }else if ([downloadType isEqualToString:@"2"]){
                [[AILogCenter defaultCenter] sendActiveEvent:@"1700001" adv:@"2"];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"itms-apps://itunes.apple.com/us/app/cnn-app-for-iphone/id%@?mt=8",self.app.itunesID]]];
            }else{
                [self download];
                
            }
        }else{
            [self download];
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1002) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [MobClick event:@"GPRS_Download_Alert" label:@"Download"];
            [self.downloadApp startDownload:YES];
        }
        else {
            [MobClick event:@"GPRS_Download_Alert" label:@"Cancel"];
        }
        
    }else if (buttonIndex != alertView.cancelButtonIndex && alertView.tag == 1003){
        [self downloadIPA];
    }
}

- (void)download
{
    
    self.app.modelID = [self.logid stringByAppendingString:@"2x"];
    self.app.keyword = self.keyword;
    if (self.app.downloadUrl.length) {
        if ([self.downloadApp.status intValue] == LocalAppStatusDownloaded && [self.downloadApp.displayVersion compare:self.app.displayVersion options:NSNumericSearch] == NSOrderedSame) {
            //安装
            if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable){
                //安装需要保持手机网络畅通（基本不耗流量）
                
                AICustomizedMBProgressHud *hud = [AICustomizedMBProgressHud showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] type:AI_HudType_Warning animated:YES];
                [hud setLabelText:@"安装需要保持手机网络畅通（基本不耗流量）"];
                [hud hide:YES afterDelay:1];
                return;
            }
            [self doInstallApp];
        } else {
            
            if (![self.downloadApp.displayVersion compare:self.app.displayVersion options:NSNumericSearch] == NSOrderedSame) {
                if ([_downloadApp.status intValue] == LocalAppStatusDownloaded && !_installedApp) {
                    [self doInstallApp];
                    return;
                }
                else {
                    _downloadApp.status = [NSNumber numberWithInt:LocalAppDownloadStatusNone];
                    [[LocalAppManager instance] removeIPAFileForLocalApp:_downloadApp];
                    _downloadApp.downloadUrl = nil;
                }
            }
            
            //下载
            
            if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable){
                AICustomizedMBProgressHud *hud = [AICustomizedMBProgressHud showHUDAddedTo:self.view type:AI_HudType_Warning animated:YES];
                [hud setLabelText:@"网络未连接"];
                [hud hide:YES afterDelay:1];
                return;
            }
            
            BOOL wifiStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == kReachableViaWiFi;
            if ([[SettingManager instance] checkDownloadPauseForWWANSetting] && !wifiStatus) {
                if ([self downloadIPA]) {
                    NSString * text = NSLocalizedString(@"未连接WiFi，要用2G/3G/4G网络继续下载吗?", @"");
                    NSString * title = NSLocalizedString(@"下载", @"");
                    if ([self.downloadApp.size doubleValue] > 0) {
                        text = NSLocalizedString(@"未连接WiFi，要用2G/3G/4G网络继续下载吗?", @"");
                        title = NSLocalizedString(@"继续下载", @"");
                    }
                    
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:text delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") otherButtonTitles:title, nil];
                    alertView.tag = 1002;
                    [alertView show];
                }
            }else{
                if (self.downloadApp.status == [NSNumber numberWithInt:LocalAppStatusDownloadPause]) {
                    [self.downloadApp startDownload:NO];
                }else if(self.downloadApp.status ==[NSNumber numberWithInt:LocalAppStatusDownloading]){
                    //                    [[NSNotificationCenter defaultCenter] postNotificationName:JFAPushDownLoadNotification object:[NSString stringWithFormat:@"%d",self.fromDownload]];
                    [self.downloadApp pauseDownload];
                }else {
                    [self downloadIPA];
                }
            }
            
        }
    }
}


-(void)doInstallApp {
#ifdef JFAJAILBREAK
    AIAppInstallErrCode ret = [[AIInstallManager sharedInstance] jailBreakInstall:_app.downloadApp];
#else
    if ((_downloadApp.installing && IOS8_OR_LATER) || _downloadApp.removeInstalling) {
        return;
    }
    AIAppInstallErrCode ret = [[AIInstallManager sharedInstance] install:_app.downloadApp];
#endif
    if (AIAppInstallErrCode_IPANotExist == ret) {
        NSString * text = NSLocalizedString(@"安装包已被删除，是否重新下载后安装?", @"");
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:text delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") otherButtonTitles:@"确定" , nil];
        alertView.tag = 1003;
        [alertView show];
    }
}

- (BOOL)downloadIPA
{
    
    if (![AIInstallManager authorized]) {
        [[AIInstallManager sharedInstance] installThroughAppStore:self.app];
        return NO;
    }
    BOOL result = NO;
    switch ([[LocalAppManager instance] createDownLoadLocalAppFromApp:self.app]) {
        case System_Version_Not_Support:
            [self showAlertViewForVersionNotSupport];
            break;
        case createDownLoadLocalAppErrorSpaceFull:{
            AICustomizedMBProgressHud *hud = [AICustomizedMBProgressHud showHUDAddedTo:self.view type:AI_HudType_Warning animated:YES];
            [hud setLabelText:@"抱歉，您的手机空间不足"];
            [hud hide:YES afterDelay:1];
            break;
        }
        case NotAuthorized:{
            
            [[LocalAppManager instance] showNotAuthAlert];
            
            break;
        }
        default: {
            [[NSNotificationCenter defaultCenter] postNotificationName:InstallManagerWillInstallAPP object:nil];
            [MobClick event:@"App_Download" label:self.parent];
            [MobClick event:@"AppDetail_Download" label:self.parent];
            result = YES;
            break;
        }
    }
    return result;
}

- (void)showAlertViewForVersionNotSupport
{
    NSString * txtFormat = NSLocalizedString(@"该应用仅支持%@以上的系统，建议您升级系统后再下载安装。", @"");
    NSString * text = [NSString stringWithFormat:txtFormat, self.app.minOSVersion];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:text delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles: nil];
    [alertView show];
}

//- (void)setApp:(App *)app
//{
//    _app = app;
//    DLog(@"%@",app.sign);
//    [self setInstalledApp:_app.installedApp];
//    [self setDownloadApp:_app.downloadApp];
//    
//    DLog(@"doenloadType = %@",self.app.downloadType);
//    if (self.app.downloadType) {
//        if (![self.app.downloadType isEqualToString:@"0"]) {
//            self.isOffical = YES;
//        }else{
//            self.isOffical = NO;
//        }
//        self.safariUrl = self.app.webUrl;
//        self.downloadType = self.app.downloadType;
//        [self updateButtonState];
//    }
//    
//}
//
//-(void)cellClickedWithApp:(App *)app {
//    [MobClick event:@"App_Click" label:@"iPhone_AssistantApp"];
//    if (app.size.longLongValue == 0) {
//        [[JFAAppDelegateHelper sharedHelper] openAppWithIdentifier:app.itunesID];
//    }
//    else {
//        AppDetailViewController *detailViewController = [[AppDetailViewController alloc] init];
//        detailViewController.parent = self.parent;
//        [MobClick event:@"AppDetail_Enter" label:detailViewController.parent];
//        detailViewController.app = app;
//        //        detailViewController.logid = [NSString stringWithFormat:@"1300001"];
//        [[AILogCenter defaultCenter] sendActiveEvent:@"1300001"];
//        detailViewController.parentServiceBaseURLKey = self.serviceBaseURLKey;
//        detailViewController.managedObjectContext = self.managedObjectContext;
//        //        detailViewController.parentNavigationController = self.parentNavigationController;
//        detailViewController.isTopController=NO;
//        if (self.rootDetailVC) {
//            detailViewController.rootDetailVC = self.rootDetailVC;
//        }
//        else {
//            detailViewController.rootDetailVC = self;
//        }
//
//        [self.jfa_navigationController pushViewController:detailViewController];
//     }
//}

//- (void)setInstalledApp:(LocalApp *)installedApp
//{
//    [self removeObserverForInstalledApp];
//    _installedApp = installedApp;
//    [self registerObserverForInstalledApp];
//}
//
//- (void)setDownloadApp:(LocalApp *)downloadApp
//{
//    [self removeObserverForDownloadApp];
//    _downloadApp = downloadApp;
//    [self registerObserverForDownloadApp];
//}



- (void)updateButtonState
{
    @synchronized(self.downloadBtn)
    {
        NSString *title = self.isOffical ? @"官方下载" : @"立即下载";
        BOOL enable = YES;
        UIColor* textColor = [UIColor whiteColor];
        UIColor* bgColor = [UIColor colorForHex:@"#007aff"];
        CGFloat width = self.downloadBtn.frame.size.width;
        if (_installedApp != nil || [[myAppInfo appSoftId] isEqualToString:_app.sourceID]) {
            if ([[myAppInfo appSoftId] isEqualToString:_app.sourceID]) {
                enable = NO;
                title = NSLocalizedString(@"已安装", @"");
                textColor = [UIColor grayColor];
                bgColor = II_GRAY_UNDERLINECOLOR;
            }
            else {
                switch ([_installedApp.displayVersion compare:_app.displayVersion options:NSNumericSearch]) {
                    case NSOrderedDescending:
                    case NSOrderedSame: {
                        enable = NO;
                        title = NSLocalizedString(@"已安装", @"");
                        textColor = [UIColor grayColor];
                        bgColor = II_GRAY_UNDERLINECOLOR;
                    }
                        break;
                        
                    case NSOrderedAscending:
                        if (_downloadApp != nil) {
                            if ([_downloadApp.displayVersion compare:_app.displayVersion options:NSNumericSearch] == NSOrderedSame){
                                if ([_downloadApp.status intValue] == LocalAppStatusDownloaded){
                                    title = NSLocalizedString(@"安装", @"");
                                    bgColor = II_ORANGE_BORDERCOLOR;
                                    if ((_downloadApp.installing && IOS8_OR_LATER) || _downloadApp.removeInstalling) {
                                        title = NSLocalizedString(@"安装中", @"");
                                        bgColor = II_GRAY_UNDERLINECOLOR;
                                    }
                                    
                                }else{
                                    title = [self checkDownloadState:_downloadApp enabled:&enable];
                                    if ([title isEqualToString:@"安装"]) {
                                        bgColor = II_ORANGE_BORDERCOLOR;
                                    }
                                    else if([title isEqualToString:@"等待下载"]) {
                                        bgColor = AI_BLUE_DOWNLOAD;
                                    }else if ([title isEqualToString:@"重新下载"]){
                                        bgColor = AI_GREEN_FAIL;
                                    }else if ([title isEqualToString:@"继续下载"]){
                                        bgColor = AI_MAIN_YELLOWCOLOR;
                                        
                                    }
                                    
                                    else {
                                        textColor = AI_MAIN_DARK_BLUECOLOR;
                                        bgColor = AI_MAIN_BLUECOLOR;
                                        width = 0;
                                        NSUInteger location = [title rangeOfString:@"%"].location;
                                        if (location != NSNotFound) {
                                            CGFloat percent = [title substringToIndex:location].floatValue / 100.0f;
                                            width = percent * self.downloadBtn.frame.size.width;
                                            enable = YES;
                                        }
                                    }
                                }
                            } else {
                                enable = YES;
                                self.isShowUpdateAlert = YES;
                                title = NSLocalizedString(@"更新", @"");
                                bgColor = II_GREEN_BORDERCOLOR;
                            }
                        } else {
                            enable = YES;
                            self.isShowUpdateAlert = YES;
                            title = NSLocalizedString(@"更新", @"");
                            bgColor = II_GREEN_BORDERCOLOR;
                        }
                        break;
                        
                    default:
                        break;
                }
            }
        } else {
            if (_downloadApp != nil) {
                if ([_downloadApp.status intValue] == LocalAppStatusDownloaded){
                    title = NSLocalizedString(@"安装", @"");
                    bgColor = II_ORANGE_BORDERCOLOR;
                    if ((_downloadApp.installing && IOS8_OR_LATER) || _downloadApp.removeInstalling) {
                        title = NSLocalizedString(@"安装中", @"");
                        bgColor = II_GRAY_UNDERLINECOLOR;
                    }
                }else{
                    title = [self checkDownloadState:_downloadApp enabled:&enable];
                    if ([title isEqualToString:@"安装"]) {
                        bgColor = II_ORANGE_BORDERCOLOR;
                    }
                    else if([title isEqualToString:@"等待下载"]) {
                        bgColor = AI_BLUE_DOWNLOAD;
                    }else if ([title isEqualToString:@"重新下载"]){
                        bgColor = AI_GREEN_FAIL;
                    }else if ([title isEqualToString:@"继续下载"]){
                        bgColor = AI_MAIN_YELLOWCOLOR;
                        
                    }
                    else {
                        textColor = AI_MAIN_DARK_BLUECOLOR;
                        bgColor = [UIColor colorForHex:@"#007aff"];
                        width = 0;
                        NSUInteger location = [title rangeOfString:@"%"].location;
                        if (location != NSNotFound) {
                            CGFloat percent = [title substringToIndex:location].floatValue / 100.0f;
                            width = percent * self.downloadBtn.frame.size.width;
                            enable = YES;
                        }
                    }
                }
            }
        }
        self.downloadBtn.enabled = enable;
        self.downloadBtn.layer.borderColor = bgColor.CGColor;
        self.downloadBg.backgroundColor = bgColor;
        CGRect frame = self.downloadBg.frame;
        frame.size.width = width;
        self.downloadBg.frame = frame;
        [self.downloadBtn setTitle:title forState:UIControlStateNormal];
        [self.downloadBtn setTitle:title forState:UIControlStateDisabled];
        
        [self.downloadBtn setTitleColor:textColor forState:UIControlStateNormal];
        [self.downloadBtn setTitleColor:textColor forState:UIControlStateDisabled];
    }
}

#pragma mark - on Notification

- (void)onDownloadApp:(NSNotification *)notification
{
    QVLogMethodCallStartVerbose();
    
    LocalApp *localApp = (LocalApp *)notification.object;
    if ([localApp.app.bundleID isEqualToString:self.app.bundleID] && [localApp compareWithVersion:self.app.version] >= 0) {
        [self setDownloadApp:_app.downloadApp];
        [self updateButtonState];
    }
    
    QVLogMethodCallEndVerbose();
}

- (void)onRemoveLocalApp:(NSNotification *)notification
{
    QVLogMethodCallStartVerbose();
    
    NSString *bundleID = notification.object;
    if ([bundleID isEqualToString:_app.bundleID]) {
        [self setApp:_app];
        [self updateButtonState];
    }
    
    QVLogMethodCallEndVerbose();
}

- (void)onNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:AIInstalledAppsSyncFinishedNotification]) {
        [self setApp:_app];
        [self updateButtonState];
    }
}

#pragma mark - KVO

- (void)registerObserverForDownloadApp
{
    if (_downloadApp) {
        [_downloadApp addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [_downloadApp addObserver:self forKeyPath:@"size" options:NSKeyValueObservingOptionNew context:nil];
        _registerDownload = YES;
    }
}

- (void)removeObserverForDownloadApp
{
    if (_downloadApp && _registerDownload) {
        [_downloadApp removeObserver:self forKeyPath:@"status"];
        [_downloadApp removeObserver:self forKeyPath:@"size"];
    }
    _registerDownload = NO;
}

- (void)registerObserverForInstalledApp
{
    if (_installedApp) {
        [_installedApp addObserver:self forKeyPath:@"upgradeStatus" options:NSKeyValueObservingOptionNew context:nil];
        _registerInstalled = YES;
    }
}

- (void)removeObserverForInstalledApp
{
    if (_installedApp && _registerInstalled) {
        [_installedApp removeObserver:self forKeyPath:@"upgradeStatus"];
    }
    _registerInstalled = NO;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setApp:self.app];
    [self updateButtonState];
}

#pragma mark - AINetworkServiceDelegate

-(JFANetWorkServiceItem*)getServiceItem
{
    JFANetWorkServiceItem* item=[[JFANetWorkServiceItem alloc] init];
    item.url=[self getTableRequestUrl];
    
    [item.parameters setObject:@"1" forKey:@"device"];
    [item.parameters setObject:[NSString stringWithFormat:@"%d",self.currentPage] forKey:@"page"];
    [item.parameters setObject:[NSString stringWithFormat:@"%ld",(long)[self getPageSize]] forKey:@"size"];
    return item;
}

-(NSArray*)getDataArrayWithResult:(id)result
{
    NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:result options:0 error:NULL];
    DLog(@"%@",jsonResult);
    
    NSDictionary* dataDic=[jsonResult safeObjectForKey:@"data"];
    NSArray* appInfoArray=[dataDic safeObjectForKey:@"result"];
    NSMutableArray* tempArray=[[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary* dic in appInfoArray) {
        JFARecommonTableViewItem* item=[[JFARecommonTableViewItem alloc] init];
        [item setupWithData:dic];
        item.selected=^(JFATableCellItem* item){
            
        };
        [tempArray addObject:item];
    }
    return tempArray;
}
#pragma mark -AppDetailViewDelegate
- (void)textViewDidFinishLoadForDetailView:(AppDetailView *)detailView
{
    [self layoutViews];
}

- (void)showMoreViewAtOffsetY:(CGFloat)offsetY {
    if (offsetY + scrollView.frame.size.height > scrollView.contentSize.height) {
        [scrollView setContentOffset:CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height)];
    }
    else {
        [scrollView setContentOffset:CGPointMake(0, offsetY)];
    }
    
}

#pragma mark - dealloc
- (void)dealloc
{
    DDLogInfo(@"dealloc %@", self);
    _parent = nil;
    [self removeObserverForDownloadApp];
    [self removeObserverForInstalledApp];
    self.downloadBtn = nil;
    self.downloadBg = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    scrollView.delegate = nil;
    [scrollView removeFromSuperview];
    scrollView = nil;
    [self.imageView removeFromSuperview];
    detailView.delegate = nil;
    [detailView removeFromSuperview];
    detailView = nil;
    
    [commentsView removeFromSuperview];
    commentsView = nil;
    
    [self.imagesContainer removeFromSuperview];
    self.imagesContainer = nil;
    
    self.getDetailService.delegate = nil;
}
#pragma mark --播放视频
-(void)playMoiveWithUrl:(NSString *)avplayerStr videoType:(NSString*)videoType
{
    NSArray *array = [avplayerStr componentsSeparatedByString:@"mp4"];
    
    NSString * urlStr = [NSString stringWithFormat:@"%@mp4",array[0]];
    
    AIMPMoviePlayerViewController *mpv =[[ AIMPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:urlStr]];
    [mpv.moviePlayer prepareToPlay];
    
    [self presentViewController:mpv animated:YES completion:^{
        
    }];
    
    [mpv.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    
    [mpv.view setBackgroundColor:[UIColor clearColor]];
    
    [mpv.view setFrame:self.view.bounds];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:mpv.moviePlayer];
}
#pragma mark - JFAWebImageBrowserControllerDelegate

- (UIView *)customLoadingViewWithCellSize:(CGSize)cellSize {
    CGRect frame = CGRectZero;
    frame.size = cellSize;
    return [AIViewFactory createDetailDefaultViewWithFrame:frame];
}

- (AIProgressView *)customNewLoadingViewWithCellSize:(CGSize)cellSize{
    CGRect frame = CGRectZero;
    frame.size = cellSize;
    return [AIViewFactory createNewDetailDefaultViewWithFrame:frame];
}

- (UIImage *)placeholderForIndex:(NSInteger)index {
    
    UIView *placeHolderView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage storeImageNamed:@"wallpaper_placeholder"]];
    placeHolderView.backgroundColor = [UIColor colorForHex:@"#f7f7f7"];
    CGRect frame = imageV.frame;
    frame.size.height = 296/3.0;
    frame.size.width = 356/3.0 + 20;
    imageV.frame = frame;
    imageV.center = placeHolderView.center;
    [placeHolderView addSubview:imageV];
    
    return [UIImage imageWithUIView:placeHolderView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
