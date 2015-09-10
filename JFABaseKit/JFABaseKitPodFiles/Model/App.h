//
//  App.h
//  Pods
//
//  Created by 魏星 on 15/9/9.
//
//

#import <Foundation/Foundation.h>
typedef enum
{
    AppTypeSoftware = 1,
    AppTypeGame = 2,
    AppTypeBook = 3,
    AppTypeTheme = 4,
    AppTypeAll
} AppType;

@interface App : NSObject
@property (nonatomic, retain) NSString * sourceID; // App在数据源端所定义的ID
@property (nonatomic, retain) NSString * itunesID;    // App被App所定义的ID，比如591006911
@property (nonatomic, retain) NSString * bundleID; // App对应的package ID, 比如kr.co.trendyapp.myfridge
@property (nonatomic, retain) NSString * webUrl; // 跳转到Safari的url 由后端负责跳转appstore
@property (nonatomic, retain) NSString * downloadType; // 0：直接下载  1：跳Safari页面   2:跳APP itunes页  3:应用内itunes页

@property (nonatomic, retain) NSString * title; // App的名字
@property (nonatomic, retain) NSNumber * size; // App的大小
@property (nonatomic, retain) NSNumber * numberOfScores; // App的评分个数
@property (nonatomic, retain) NSNumber * star; // App的评分
@property (nonatomic, retain) NSString * icon; // App的图标
@property (nonatomic, retain) NSNumber * price; // App的价格
@property (nonatomic, retain) NSNumber * lastPrice; // App上次的价格，用于判断是否限免
@property (nonatomic, retain) NSNumber * isLimitedFree; // 是否限免
@property (nonatomic, retain) NSString * version; // App的版本
@property (nonatomic, retain) NSString * shortVersion; // App的short version
@property (nonatomic, strong, readonly) NSString *displayVersion; // 优先显示version和shortVersion中带点的，如果都不带点，显示version
@property (nonatomic, retain) NSString * textSummary; // App的描述信息
@property (nonatomic, retain) NSString * updateInfo; // 更新信息
@property (nonatomic, retain) NSString * imageSummary; // App的截图
@property (nonatomic, retain) NSString * releaseDate; // App的发布日期
@property (nonatomic, retain) NSString * releaseNote; // App更新内容
@property (nonatomic, retain) NSString * downloadUrl; // App对应的ipa的下载地址
@property (nonatomic, retain) NSString * downloadKey; // 此下载地址对应的key
@property (nonatomic, retain) NSSet    * locals;
@property (nonatomic, retain) NSNumber * order; // App的排序信息，用于显示
@property (nonatomic, retain) NSNumber * downloadCount; // App下载次数
@property (nonatomic, retain) NSString * titlePinyin; // App的title对应的中文拼音
@property (nonatomic, retain) NSNumber * jailBreak; // 此App是否被破解了
@property (nonatomic, retain) NSString * category; // 此App所属分类的ID
@property (nonatomic, retain) NSString * subcategory; // 此App所属的子分类的ID
@property (nonatomic, retain) NSSet    * comments; // 用户评论
@property (nonatomic, retain) NSString * minOSVersion; // 此App支持的最低系统版本
@property (nonatomic, retain) NSString * developer; // 此App的开发者
@property (nonatomic, retain) NSString * short_brief; // 此App的编辑简介
@property (nonatomic, strong) NSString * sign;//app属性 0没有特殊属性 1有礼包
@property (nonatomic, strong) NSString * companySign; // 是否企业签名 1:企业签 0:非企业签
@property (nonatomic, retain) NSString * dsid; // 证书

@property (nonatomic, strong) NSString * avplayerUrlStr;
@property (nonatomic, strong) NSString * avplayerImageStr;


@property (nonatomic, retain) NSString *modelID;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, retain) NSMutableArray *recsoftlist;
@property (nonatomic, retain) NSDate *version_time;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSMutableArray * bundleIdlist;//联运游戏bundleid列表
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) NSString *hotindex;// 不规则展示位打点标记

// 首页非常规展示
@property (nonatomic, strong) NSString *hotListType;
@property (nonatomic, strong) NSString *hotListTitle;
@property (nonatomic, strong) NSArray *hotListApps;
@property (nonatomic, strong) NSArray *hotListTag;
@property (nonatomic, strong) NSDictionary *hotListBannerInfo;

@end
