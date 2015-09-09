//
//  AppStarImageView.h
//  AppInstaller
//
//  Created by liuweina on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat kAppStarViewHeight;

@interface AppStarView : UIView
{

}
@property (nonatomic, strong) NSNumber *appStar;
@property (nonatomic, assign) float appStarViewWidth;
@property (nonatomic) CGFloat starSize;

@end
