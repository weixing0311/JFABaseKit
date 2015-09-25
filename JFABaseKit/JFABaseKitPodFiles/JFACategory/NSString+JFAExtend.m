//
//  NSString+JFAExtend.m
//  JFABaseKit
//
//  Created by stefan on 15/8/28.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import "NSString+JFAExtend.h"
#import <CommonCrypto/CommonDigest.h>
#define MD5_LENGTH 16

@implementation NSString (JFAExtend)

- (CGFloat)heightForLabelWithWidth:(CGFloat)isWidth isFont:(UIFont*)labelFont{
    CGFloat height = 0.0f;
    height = ceilf([self sizeWithFont:labelFont constrainedToSize:CGSizeMake(isWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height);
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
-(NSString*)md5String
{
    int i = 0;
    NSMutableString *cryptedString = [[NSMutableString alloc] initWithCapacity:MD5_LENGTH];
    unsigned char result[MD5_LENGTH];
    const char *string = [self UTF8String];
    CC_MD5(string, strlen(string), result);
    for (i = 0; i < MD5_LENGTH; ++i) {
        [cryptedString appendFormat:@"%02X", result[i]];
    }
    return [cryptedString lowercaseString];
}
- (CGSize)sizeWithTheFont:(UIFont *)font constrainedToSize:(CGSize)size{
    CGSize textSize;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]){
        textSize = [self boundingRectWithSize:size
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil].size;
    }else{
        textSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:0];
    }
    return textSize;
}
@end
