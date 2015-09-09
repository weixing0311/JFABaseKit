//
//  MediaPlayMP4.m
//  Pods
//
//  Created by 魏星 on 15/7/21.
//
//

#import "AIMediaPlayMP4.h"
static AIMediaPlayMP4 *_instance;
@implementation AIMediaPlayMP4

+ (AIMediaPlayMP4 *)instance
{
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _instance = [[AIMediaPlayMP4 alloc] init];
    });
    
    return _instance;
}
-(instancetype)init
{
    if (self ) {
        self = [super init];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stateChange) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
        //2 监听播放完成
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(myMovieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        //3视频截图
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(caputerImage:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
//        //3视频截图
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(caputerImage:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
        //4退出全屏通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exitFullScreen:) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
        
 
    }
    return self;
}
- (void)stateChange
{
    
    switch (_player.playbackState) {
        case MPMoviePlaybackStatePaused:
            DLog(@"暂停");
            break;
        case MPMoviePlaybackStatePlaying:
            //设置全屏播放
            [_player setFullscreen:YES animated:YES];
            DLog(@"播放");
            break;
        case MPMoviePlaybackStateStopped:
            //注意：正常播放完成，是不会触发MPMoviePlaybackStateStopped事件的。
            //调用[self.player stop];方法可以触发此事件。
            DLog(@"停止");
            [_player stop];
            break;
        default:
            break;
    }
}

-(void)createMp4PlayerWithUrl:(NSString *)urlStr
{
    MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc]initWithContentURL:urlStr];

    if (!self.loadingAni) {
        self.loadingAni = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.PlayVC.view.frame.size.width / 2 - 18, self.PlayVC.view.frame.size.height / 2 - 18, 37, 37)];
        self.loadingAni.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self.PlayVC.view addSubview:self.loadingAni];

    }
    [self.loadingAni startAnimating];
        if ([_player shouldAutoplay]) {
            [_player stop];
            [_player.view removeFromSuperview];
        }
        if (!_player) {
            _player = [[MPMoviePlayerController alloc]init];
        }
        _player.contentURL = [NSURL URLWithString:urlStr];
        if ([_player respondsToSelector:@selector(loadState)])
        {
            // Set movie player layout
            [_player setControlStyle:MPMovieControlStyleFullscreen];        //MPMovieControlStyleFullscreen        //MPMovieControlStyleEmbedded
            //满屏
            [_player setFullscreen:YES];
            // 有助于减少延迟
            [_player prepareToPlay];
            
            // Register that the load state changed (movie is ready)
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(moviePlayerLoadStateChanged:)
                                                         name:MPMoviePlayerLoadStateDidChangeNotification
                                                       object:nil];
        }
        else
        {
            // Play the movie For 3.1.x devices
            [_player play];
        }
}
- (void) moviePlayerLoadStateChanged:(NSNotification*)notification
{
    [_loadingAni stopAnimating];

    // Unless state is unknown, start playback
    if ([_player loadState] != MPMovieLoadStateUnknown)
    {
        // Remove observer
        [[NSNotificationCenter  defaultCenter] removeObserver:self
                                                         name:MPMoviePlayerLoadStateDidChangeNotification
                                                       object:nil];
        //设置横屏
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortraitUpsideDown animated:YES];
         [[_player view] setFrame:_PlayVC.view.frame];
        [_PlayVC.view addSubview:[_player view]];
        
        [_player play];
    }
}

-(void)myMovieFinishedCallback:(NSNotification*)notify
{
    MPMoviePlayerController* theMovie = [notify object];
    [theMovie.view removeFromSuperview];
}
-(void)exitFullScreen:(NSNotification *)notify
{
    MPMoviePlayerController* theMovie = [notify object];
     [theMovie.view removeFromSuperview];
    [_player stop];
}
@end
