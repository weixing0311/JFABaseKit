//
//  JFADownLoadApp.h
//  Pods
//
//  Created by 魏星 on 15/9/28.
//
//

#import <Foundation/Foundation.h>

@interface JFADownLoadApp : NSObject
+ (instancetype)sharedManager;
-(void)DownLoadAppWithID:(NSString *)uid;
@end
