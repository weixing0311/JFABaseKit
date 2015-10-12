//
//  ServiceResultErrorView.h
//  AppInstaller
//
//  Created by liuweina on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JFAErrorView.h"

@interface ServiceResultErrorView : JFAErrorView

@property (nonatomic, retain) NSError *error;
@property (nonatomic, retain) UILabel *errorLabel;
@property (nonatomic, retain) UIButton *refreshButton;

@property (nonatomic, retain) UIButton *control;

@property (nonatomic, retain) UIView* errorView;
@property (nonatomic, retain) UIButton *errorButton;

- (void)setErrorText:(NSString *)errorText;

@end
