//
//  JFASubApps.m
//  JFAAppStoreHelper
//
//  Created by 魏星 on 15/9/23.
//  Copyright © 2015年 JF. All rights reserved.
//

#import "JFASubApps.h"

@implementation JFASubApps
-(void)getSubAppsWithDic:(NSDictionary *)appInfo
{
 
    NSString *bundleID = [appInfo safeObjectForKey:@"pkg_id"];
    DLog(@"%@",appInfo);
    
    if ([[appInfo safeObjectForKey:@"artificial"] boolValue]) {
        [[NSUserDefaults standardUserDefaults] setObject:[appInfo safeObjectForKey:@"artificial"] forKey:bundleID];
    }
    self.sourceID = [appInfo safeObjectForKey:@"soft_id"];
    self.itunesID = [appInfo safeObjectForKey:@"apple_app_id"];
    self.title = [appInfo safeObjectForKey:@"soft_name"];
    self.version = [appInfo safeObjectForKey:@"pkg_ver"];
    self.shortVersion = [appInfo safeObjectForKey:@"disp_ver"];
    self.size = [NSNumber numberWithInt:[[appInfo safeObjectForKey:@"pkg_size"] intValue]];
    
    self.releaseDate = [appInfo safeObjectForKey:@"version_time"];
    
    
    DLog(@"shartb = %@",[appInfo safeObjectForKey:@"short_brief"]);
     if ([appInfo safeObjectForKey:@"pkg_ids"]) {
        self.bundleId=[appInfo safeObjectForKey:@"pkg_ids"];
    }
    DLog(@"%@",[appInfo safeObjectForKey:@"logo_url"]);
    
    if ([appInfo safeObjectForKey:@"logo_url"]) {
        self.icon = [appInfo safeObjectForKey:@"logo_url"];
    }
    
    if ([appInfo valueForKey:@"version_time"]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        self.version_time = [dateFormatter dateFromString:[appInfo valueForKey:@"version_time"]];
    }
    
    
    self.downloadCount = [NSNumber numberWithInt:[[appInfo safeObjectForKey:@"download_num"] intValue]];
    self.downloadUrl = [appInfo safeObjectForKey:@"down_url"];

    
}
@end
