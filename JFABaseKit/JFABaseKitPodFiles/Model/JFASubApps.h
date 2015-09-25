//
//  JFASubApps.h
//  JFAAppStoreHelper
//
//  Created by 魏星 on 15/9/23.
//  Copyright © 2015年 JF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFASubApps : NSObject
@property (nonatomic,strong)NSString * itunesID;
@property (nonatomic,strong)NSString * shortVersion;
@property (nonatomic,strong)NSString * downloadUrl;
@property (nonatomic,strong)NSNumber * downloadCount;
@property (nonatomic,strong)NSString * icon;
@property (nonatomic,strong)NSString * version;
@property (nonatomic,strong)NSString * bundleId;
@property (nonatomic,strong)NSNumber * size;
@property (nonatomic,strong)NSString * sourceID;
@property (nonatomic,strong)NSString * title;
@property (nonatomic,strong)NSString * releaseDate;
@property (nonatomic,strong)NSDate * version_time;
-(void)getSubAppsWithDic:(NSDictionary *)appInfo;
@end
