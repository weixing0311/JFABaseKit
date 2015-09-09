//
//  JFAAppManagerItem.m
//  JFAAppStoreHelper
//
//  Created by 魏星 on 15/9/8.
//  Copyright © 2015年 JF. All rights reserved.
//

#import "JFAAppManagerItem.h"

@implementation JFAAppManagerItem
-(NSString*)cellXibName
{
    return @"JFAAppManagerCell";
}

-(NSString*)cellClassName
{
    return @"JFAAppManagerCell";
}

-(CGFloat)cellHeight
{
    return 79;
}
-(void)setupWithData:(id)data
{
    self.appId=[data safeObjectForKey:@"apple_app_id"];
    self.logoUrl=[data safeObjectForKey:@"logo_url"];
    self.softName=[data safeObjectForKey:@"soft_name"];
    self.shortBrief=[data safeObjectForKey:@"short_brief"];
    
}
@end
