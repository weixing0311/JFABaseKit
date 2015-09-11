//
//  JFALoadingView.h
//  JFABaseKit
//
//  Created by stefan on 15/8/28.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import "JFACustomView.h"

@interface JFALoadingView : JFACustomView


-(UIImage*)loadingImage;

-(void)resetSubViews;

-(void)stoploading;

-(void)startloading;
+ (UIView *)createLoadingServiceViewWithFrame:(CGRect)frame autoLayout:(BOOL)autoLayout;
@end
