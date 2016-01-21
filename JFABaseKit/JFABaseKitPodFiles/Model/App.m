//
//  self.m
//  Pods
//
//  Created by 魏星 on 15/9/9.
//
//

#import "App.h"
#import "Reachability.h"
#import "JFASubApps.h"
@implementation App
//@dynamic sourceID;
//@dynamic itunesID;
//@dynamic bundleID;
//
//@dynamic title;
//@dynamic size;
//@dynamic numberOfScores;
//@dynamic star;
//@dynamic icon;
//@dynamic price;
//@dynamic lastPrice;
//@dynamic isLimitedFree;
//@dynamic version;
//@dynamic shortVersion;
//@dynamic textSummary;
//@dynamic updateInfo;
//@synthesize short_brief;
//@dynamic imageSummary;
//@dynamic releaseDate;
//@dynamic releaseNote;
//@dynamic downloadUrl;
//@dynamic downloadKey;
//@dynamic locals;
//@dynamic order;
//@dynamic downloadCount;
//@dynamic titlePinyin;
//@dynamic jailBreak;
//@dynamic comments;
//@dynamic category;
//@dynamic subcategory;
//@dynamic minOSVersion;
//@dynamic developer;
//@synthesize keyword;
//@synthesize modelID;
//@synthesize recsoftlist;
//@synthesize version_time;
//@synthesize language;
//@synthesize bundleIdlist;
//@synthesize sign;
//@synthesize isSelected;
//@synthesize companySign;
//
//@synthesize hotListType;
//@synthesize hotListTitle;
//@synthesize hotListApps;
//@synthesize hotListTag;
//@synthesize hotListBannerInfo;
//@synthesize hotindex;
//@synthesize webUrl;
//@synthesize downloadType;
//@synthesize avplayerUrlStr;
//@synthesize avplayerImageStr;
//@synthesize dsid;

- (void)createAppFromSummaryInfo:(NSDictionary *)appInfo
{
    DLog(@"appinfo = %@",appInfo);

    NSString *bundleID = [appInfo safeObjectForKey:@"pkg_id"];
    
    if ([[appInfo safeObjectForKey:@"artificial"] boolValue]) {
        [[NSUserDefaults standardUserDefaults] setObject:[appInfo safeObjectForKey:@"artificial"] forKey:bundleID];
    }
    self.dsid = [appInfo safeObjectForKey:@"dsid"];
    if (self.dsid.length>0) {
        DLog(@"disd = %@,title = %@",[appInfo safeObjectForKey:@"dsid"],[appInfo safeObjectForKey:@"soft_name"]);
    }
    self.sourceID = [appInfo safeObjectForKey:@"soft_id"];
    self.itunesID = [appInfo safeObjectForKey:@"apple_app_id"];
    self.title = [appInfo safeObjectForKey:@"soft_name"];
//    self.titlePinyin = self.title ? [hz2pyString(self.title) lowercaseString] : @"";
    self.price = [NSNumber numberWithFloat:[[appInfo safeObjectForKey:@"price"] doubleValue]];
    DLog(@"self.proce = %@",self.price);
    self.version = [appInfo safeObjectForKey:@"pkg_ver"];
    self.shortVersion = [appInfo safeObjectForKey:@"disp_ver"];
    self.minOSVersion = [appInfo safeObjectForKey:@"os_ver_min"];
    self.size = [NSNumber numberWithInt:[[appInfo safeObjectForKey:@"pkg_size"] intValue]];
    if ([appInfo safeObjectForKey:@"short_brief"]) {
        self.short_brief = [appInfo safeObjectForKey:@"short_brief"];
    }
    
    self.releaseDate = [appInfo safeObjectForKey:@"version_time"];
    self.textSummary = [appInfo safeObjectForKey:@"intro"];

    
    DLog(@"is_safari = %@",[appInfo safeObjectForKey:@"is_safari"]);
    if ([appInfo safeObjectForKey:@"is_safari"]) {
        if ([[appInfo safeObjectForKey:@"is_safari"] isKindOfClass:[NSString class]]) {
            self.downloadType = [appInfo safeObjectForKey:@"is_safari"];
        }else{
            self.downloadType = [NSString stringWithFormat:@"%@",[appInfo safeObjectForKey:@"is_safari"]];
        }
    }
    
    if ([appInfo safeObjectForKey:@"referer_url"]) {//后台url字段
        self.webUrl = [appInfo safeObjectForKey:@"referer_url"];
    }
    
    DLog(@"shartb = %@",[appInfo safeObjectForKey:@"short_brief"]);
    id signObject=[appInfo safeObjectForKey:@"sign"];
    
    if ([signObject isKindOfClass:[NSNumber class]]) {
        self.sign=[signObject stringValue];
    }else{
        self.sign=signObject;
    }
    if ([appInfo safeObjectForKey:@"pkg_ids"]&&[[appInfo safeObjectForKey:@"pkg_ids"] isKindOfClass:[NSArray class]]) {
        self.bundleIdlist=[[NSMutableArray alloc]initWithArray:[appInfo safeObjectForKey:@"pkg_ids"]];
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
 
    NSString* iiapple_score=[appInfo safeObjectForKey:@"iiapple_score"];
    
    if ([iiapple_score isKindOfClass:[NSNumber class]]) {
        iiapple_score=[[appInfo safeObjectForKey:@"iiapple_score"] stringValue];
    }else{
        iiapple_score=[appInfo safeObjectForKey:@"iiapple_score"];
    }
    
    NSString* itunes_score=[appInfo safeObjectForKey:@"itunes_score"];
    if ([itunes_score isKindOfClass:[NSNumber class]]) {
        itunes_score=[[appInfo safeObjectForKey:@"itunes_score"] stringValue];
    }else{
        itunes_score=[appInfo safeObjectForKey:@"itunes_score"];
    }
    
    DLog(@"%@---%@",itunes_score,iiapple_score);
    
    if (iiapple_score&&[iiapple_score length]>0) {
        if ([iiapple_score isEqualToString:@"0"]) {
            if (itunes_score&&[itunes_score length]>0) {
                if (![itunes_score isEqualToString:@"0"]) {
                    self.star=[NSNumber numberWithInt:[itunes_score doubleValue]];
                }
            }
        }else{
            self.star=[NSNumber numberWithInt:[iiapple_score doubleValue]];
        }
    }
    self.downloadCount = [NSNumber numberWithInt:[[appInfo safeObjectForKey:@"down_num"] intValue]];
    self.downloadUrl = [appInfo safeObjectForKey:@"down_url"];
    self.downloadKey = [appInfo safeObjectForKey:@"ukey"];
    self.sign=[appInfo objectForKey:@"sign"];
    
//    if ([AIApplicationUtility isiPadDevice]) {
//        self.imageSummary = [appInfo safeObjectForKey:@"ipad_snap_urls"];
//        if (self.imageSummary == nil || self.imageSummary.length == 0) {
//            self.imageSummary = [appInfo safeObjectForKey:@"snap_urls"];
//        }
//    }
//    else {
        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]==kReachableViaWiFi) {
            NSString* snap_big_urls=[appInfo safeObjectForKey:@"snap_big_urls"];
            if (snap_big_urls&&[snap_big_urls length]>0) {
                self.imageSummary=snap_big_urls;
            }else{
                self.imageSummary=[appInfo safeObjectForKey:@"snap_urls"];
            }
        }else{
            self.imageSummary = [appInfo safeObjectForKey:@"snap_urls"];
        }
//    }
    
    self.developer = [appInfo safeObjectForKey:@"dev_name"];
    self.updateInfo = [appInfo safeObjectForKey:@"ver_intro"];
    self.recsoftlist = [NSMutableArray array];
    NSArray* array = [appInfo valueForKey:@"recsoftlist"];
    if (array && [array isKindOfClass:[NSArray class]]) {
        for (NSDictionary* dict in [appInfo valueForKey:@"recsoftlist"]) {
            JFASubApps* listApp= [[JFASubApps alloc]init];
            [listApp getSubAppsWithDic:dict];
            [self.recsoftlist addObject:listApp];
        }
    }
    // parse tag
    NSArray *tags = [appInfo safeObjectForKey:@"tag_json"];
    DLog(@"%@",tags);
        if (tags.count) {
            self.hotListTag = [NSArray arrayWithArray:tags];
            DLog(@"%@",self.hotListTag);
        }
//    }
//     return app;
}
@end
