//
//  MediaPlayMP4.h
//  Pods
//
//  Created by 魏星 on 15/7/21.
//
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface AIMediaPlayMP4 : NSObject
+ (AIMediaPlayMP4 *)instance;
@property (nonatomic,strong) MPMoviePlayerController * player;
@property (nonatomic,strong) UIViewController *PlayVC;
@property (nonatomic,strong) UIActivityIndicatorView *loadingAni;
-(void)createMp4PlayerWithUrl:(NSString *)urlStr;
@end
