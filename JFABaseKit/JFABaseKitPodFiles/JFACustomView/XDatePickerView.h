//
//  XDatePickerView.h
//  BabyDress
//
//  Created by 臧金晓 on 15/1/4.
//  Copyright (c) 2015年 7ul.ipa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDatePickerView : UIView

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) void(^didSelectDate)(NSDate *date);

@end
