//
//  XDatePickerView.m
//  BabyDress
//
//  Created by 臧金晓 on 15/1/4.
//  Copyright (c) 2015年 7ul.ipa. All rights reserved.
//

#import "XDatePickerView.h"
#import "NimbusKitAttributedLabel.h"

@implementation XDatePickerView
{
    NIAttributedLabel *titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.datePicker = [[UIDatePicker alloc] init];
        [self addSubview:self.datePicker];
        [self setBackgroundColor:[UIColor whiteColor]];
        titleLabel = [NIAttributedLabel labelWithFontSize:16 color:[UIColor blackColor] backgroundColor:[UIColor clearColor]];
        [self addSubview:titleLabel];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setVerticalTextAlignment:NIVerticalTextAlignmentMiddle];
        titleLabel.layer.borderWidth = px;
        titleLabel.layer.borderColor = RGBPureColor(188).CGColor;
        self.datePicker.layer.borderColor = RGBPureColor(188).CGColor;
        self.datePicker.layer.borderWidth = px;
        
        _cancelButton = [self createCommonButton];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];

        _okButton = [self createCommonButton];
        [_okButton setTitle:@"确定" forState:UIControlStateNormal];
        @weakly(self);
        [_cancelButton bk_addEventHandler:^(id sender) {
            [selfWeak removeFromSuperview];
        } forControlEvents:UIControlEventTouchUpInside];
        
        [_okButton bk_addEventHandler:^(id sender) {
            if (selfWeak.didSelectDate)
            {
                selfWeak.didSelectDate(selfWeak.datePicker.date);
                [selfWeak removeFromSuperview];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        [self layoutSubviews];
    }
    return self;
}

- (UIButton *)createCommonButton
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitleColor:RGBCOLOR_HEX(0x97d808) forState:UIControlStateNormal];
    [self addSubview:button];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button.titleLabel setFont:XFont(16)];
    return button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.datePicker setFrame:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(35, 0, 47, 0))];
    [titleLabel setFrame:CGRectMake(0, 0, self.width, 35)];
    [_cancelButton setFrame:CGRectMake(0, self.height - 47, self.width / 2.0f, 47)];
    [_okButton setFrame:CGRectMake(self.width / 2.0f, self.height - 47, self.width / 2.0f, 47)];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [titleLabel setText:title];
}

@end
