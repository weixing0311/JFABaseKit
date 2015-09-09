//
//  AIMPMoviePlayerViewController.m
//  Pods
//
//  Created by 魏星 on 15/8/4.
//
//

#import "AIMPMoviePlayerViewController.h"
//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface AIMPMoviePlayerViewController ()
{
    long _oldDirection;//旧方向
    long _currentDirection;//当前方向
}
@end

@implementation AIMPMoviePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
//    [self.view setTransform:transform];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transContro:) name:UIDeviceOrientationDidChangeNotification object:nil];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 屏幕旋转
- (void)transContro:(NSNotification *)notification
{
    _currentDirection = [[UIDevice currentDevice] orientation];
    
    if (_oldDirection != _currentDirection) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
                if (_oldDirection != 3 && _oldDirection != 5) {
                    self.view.frame = CGRectMake(0, 0, ScreenHeight, ScreenWidth);
                    self.view.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
                }
                CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(M_PI_2 * 3);
                self.view.transform = landscapeTransform;
                
                _oldDirection = UIDeviceOrientationLandscapeRight;
            }
            if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
                if (_oldDirection != 4 && _oldDirection != 5) {
                    self.view.frame = CGRectMake(0, 0, ScreenHeight, ScreenWidth);
                    self.view.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
                }
                CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(M_PI_2);
                self.view.transform = landscapeTransform;
                
                _oldDirection = UIDeviceOrientationLandscapeLeft;
            }
            if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
                CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(0.0);
                self.view.transform = landscapeTransform;
                self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
                self.view.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
                
                _oldDirection = UIDeviceOrientationPortrait;
            }
            if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
                CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(M_PI);
                self.view.transform = landscapeTransform;
                self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
                self.view.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
                
                _oldDirection = UIDeviceOrientationPortraitUpsideDown;
            }
        } completion:^(BOOL finished) {
            nil;
        }];
    }
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
