//
//  NSString+JFAExtend.h
//  JFABaseKit
//
//  Created by stefan on 15/8/28.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (JFAExtend)

- (CGFloat)heightForLabelWithWidth:(CGFloat)isWidth isFont:(CGFloat)font;
- (CGFloat)heightForLabelWithWidth:(CGFloat)isWidth isTextFont:(CGFloat)isTextFont;
- (CGFloat)widthForLabelWithHeight:(CGFloat)isHeight isTextFont:(CGFloat)isTextFont;
- (CGFloat)widthForLabelWithHeight:(CGFloat)isHeight isFont:(UIFont*)font;

@end
