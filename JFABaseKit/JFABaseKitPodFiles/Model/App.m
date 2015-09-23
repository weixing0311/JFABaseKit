//
//  App.m
//  Pods
//
//  Created by 魏星 on 15/9/9.
//
//

#import "App.h"

@implementation App
@dynamic sourceID;
@dynamic itunesID;
@dynamic bundleID;

@dynamic title;
@dynamic size;
@dynamic numberOfScores;
@dynamic star;
@dynamic icon;
@dynamic price;
@dynamic lastPrice;
@dynamic isLimitedFree;
@dynamic version;
@dynamic shortVersion;
@dynamic textSummary;
@dynamic updateInfo;
@synthesize short_brief;
@dynamic imageSummary;
@dynamic releaseDate;
@dynamic releaseNote;
@dynamic downloadUrl;
@dynamic downloadKey;
@dynamic locals;
@dynamic order;
@dynamic downloadCount;
@dynamic titlePinyin;
@dynamic jailBreak;
@dynamic comments;
@dynamic category;
@dynamic subcategory;
@dynamic minOSVersion;
@dynamic developer;
@synthesize keyword;
@synthesize modelID;
@synthesize recsoftlist;
@synthesize version_time;
@synthesize language;
@synthesize bundleIdlist;
@synthesize sign;
@synthesize isSelected;
@synthesize companySign;

@synthesize hotListType;
@synthesize hotListTitle;
@synthesize hotListApps;
@synthesize hotListTag;
@synthesize hotListBannerInfo;
@synthesize hotindex;
@synthesize webUrl;
@synthesize downloadType;
@synthesize avplayerUrlStr;
@synthesize avplayerImageStr;
@synthesize dsid;

- (void)createAppFromSummaryInfo:(NSDictionary *)appInfo
{
    
    if (!self) {
        self = [[App alloc]init];
    }
    
    
    NSString *bundleID = [appInfo safeObjectForKey:@"pkg_id"];
    DLog(@"%@",appInfo);
    

    if ([[appInfo safeObjectForKey:@"artificial"] boolValue]) {
        [[NSUserDefaults standardUserDefaults] setObject:[appInfo safeObjectForKey:@"artificial"] forKey:bundleID];
    }
    
    
    app.dsid = [appInfo safeObjectForKey:@"dsid"];
    if (app.dsid.length>0) {
        DLog(@"disd = %@,title = %@",[appInfo safeObjectForKey:@"dsid"],[appInfo safeObjectForKey:@"soft_name"]);
    }
    app.sourceID = [appInfo safeObjectForKey:@"soft_id"];
    app.itunesID = [appInfo safeObjectForKey:@"apple_app_id"];
    app.title = [appInfo safeObjectForKey:@"soft_name"];
    app.titlePinyin = app.title ? [hz2pyString(app.title) lowercaseString] : @"";
    app.price = [NSNumber numberWithFloat:[[appInfo safeObjectForKey:@"price"] doubleValue]];
    DLog(@"app.proce = %@",app.price);
    app.version = [appInfo safeObjectForKey:@"pkg_ver"];
    app.shortVersion = [appInfo safeObjectForKey:@"disp_ver"];
    app.minOSVersion = [appInfo safeObjectForKey:@"os_ver_min"];
    app.size = [NSNumber numberWithInt:[[appInfo safeObjectForKey:@"pkg_size"] intValue]];
    if ([appInfo safeObjectForKey:@"short_brief"]) {
        app.short_brief = [appInfo safeObjectForKey:@"short_brief"];
    }
    DLog(@"is_safari = %@",[appInfo safeObjectForKey:@"is_safari"]);
    if ([appInfo safeObjectForKey:@"is_safari"]) {
        if ([[appInfo safeObjectForKey:@"is_safari"] isKindOfClass:[NSString class]]) {
            app.downloadType = [appInfo safeObjectForKey:@"is_safari"];
        }else{
            app.downloadType = [NSString stringWithFormat:@"%@",[appInfo safeObjectForKey:@"is_safari"]];
        }
    }
    
    if ([appInfo safeObjectForKey:@"referer_url"]) {//后台url字段
        app.webUrl = [appInfo safeObjectForKey:@"referer_url"];
    }
    
    DLog(@"shartb = %@",[appInfo safeObjectForKey:@"short_brief"]);
    id signObject=[appInfo safeObjectForKey:@"sign"];
    
    if ([signObject isKindOfClass:[NSNumber class]]) {
        app.sign=[signObject stringValue];
    }else{
        app.sign=signObject;
    }
    if ([appInfo safeObjectForKey:@"pkg_ids"]&&[[appInfo safeObjectForKey:@"pkg_ids"] isKindOfClass:[NSArray class]]) {
        app.bundleIdlist=[[NSMutableArray alloc]initWithArray:[appInfo safeObjectForKey:@"pkg_ids"]];
    }
    DLog(@"%@",[appInfo safeObjectForKey:@"logo_url"]);
    
    if ([appInfo safeObjectForKey:@"logo_url"]) {
        app.icon = [appInfo safeObjectForKey:@"logo_url"];
    }
    
    if ([appInfo valueForKey:@"version_time"]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        app.version_time = [dateFormatter dateFromString:[appInfo valueForKey:@"version_time"]];
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
                    app.star=[NSNumber numberWithInt:[itunes_score doubleValue]];
                }
            }
        }else{
            app.star=[NSNumber numberWithInt:[iiapple_score doubleValue]];
        }
    }
    app.downloadCount = [NSNumber numberWithInt:[[appInfo safeObjectForKey:@"down_num"] intValue]];
    
    // parse tag
    NSArray *tags = [appInfo safeObjectForKey:@"tag_json"];
    DLog(@"%@",tags);
    if ([tags isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempTags = [NSMutableArray new];
//        for (NSDictionary *tagJson in tags) {
//            AppTag *newTag = [AppTag new];
//            newTag.tag_name = [tagJson safeObjectForKey:@"tag_name"];
//            newTag.frame_color = [tagJson safeObjectForKey:@"frame_color"];
//            newTag.bg_color = [tagJson safeObjectForKey:@"bg_color"];
//            newTag.font_color = [tagJson safeObjectForKey:@"font_color"];
//            newTag.bg_style = [tagJson safeObjectForKey:@"bg_style"];
//            [tempTags addObject:newTag];
//        }
        if (tempTags.count) {
            app.hotListTag = [NSArray arrayWithArray:tempTags];
            DLog(@"%@",app.hotListTag);
        }
    }
//     return app;
}
@end
