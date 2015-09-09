//
//  JFARecommonTableViewItem.m
//  JFAAppStoreHelper
//
//  Created by stefan on 15/9/6.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import "JFARecommonTableViewItem.h"

@implementation JFARecommonTableViewItem

-(NSString*)cellXibName
{
    return @"JFARecommonTableViewCell";
}

-(NSString*)cellClassName
{
    return @"JFARecommonTableViewCell";
}

-(CGFloat)cellHeight
{
    return 79;
}

//{
//    "apple_app_id" = 504776703;
//    artificial = 0;
//    "baike_score" = 8;
//    "device_type" = 3;
//    "disp_ver" = "3.3.18";
//    "down_num" = 53946;
//    dsid = 92a8f4c8a8d4f58d84e5087299369442;
//    "iiapple_score" = 4;
//    "is_safari" = 0;
//    "itunes_score" = 0;
//    "limit_price" = 0;
//    "logo_url" = "http://img.coolsrv.com/ez/114x114_/v01b0d226212f561654.png";
//    "os_ver_min" = "5.0";
//    "pkg_id" = "com.qvod.duoping";
//    "pkg_size" = 32609639;
//    "pkg_ver" = 2021;
//    "short_brief" = "\U4f60\U60f3\U770b\U7684\Uff0c\U8fd9\U91cc\U90fd\U6709\n";
//    sign = 0;
//    "soft_id" = 440;
//    "soft_name" = "\U5feb\U64ad\U4e92\U52a8\U6d4f\U89c8";
//    "tag_json" =                 (
//    );
-(void)setupWithData:(id)data
{
    self.appId=[data safeObjectForKey:@"apple_app_id"];
    self.logoUrl=[data safeObjectForKey:@"logo_url"];
    self.softName=[data safeObjectForKey:@"soft_name"];
    self.shortBrief=[data safeObjectForKey:@"short_brief"];

}


@end
