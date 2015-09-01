//
//  NSString+JFAExtend.m
//  JFABaseKit
//
//  Created by stefan on 15/8/28.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import "NSString+JFAExtend.h"

@implementation NSString (JFAExtend)

- (CGFloat)heightForLabelWithWidth:(CGFloat)isWidth isFont:(CGFloat)font{
    CGFloat height = 0.0f;
    height = ceilf([self sizeWithFont:font constrainedToSize:CGSizeMake(isWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height);
    return height;
}

- (CGFloat)heightForLabelWithWidth:(CGFloat)isWidth isTextFont:(CGFloat)isTextFont{
    return [self heightForLabelWithWidth:isWidth isFont:[UIFont systemFontOfSize:isTextFont]];
}

- (CGFloat)widthForLabelWithHeight:(CGFloat)isHeight isTextFont:(CGFloat)isTextFont {

    return [self widthForLabelWithHeight:isHeight isFont:[UIFont systemFontOfSize:isTextFont]];
}

- (CGFloat)widthForLabelWithHeight:(CGFloat)isHeight isFont:(UIFont*)font {
    CGFloat width = 0.0f;
    width = ceilf([self sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, isHeight) lineBreakMode:NSLineBreakByWordWrapping].width);
    return width;
}
@end
