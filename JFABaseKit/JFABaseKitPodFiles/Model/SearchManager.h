//
//  SearchManager.h
//  AppInstaller
//
//  Created by  on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchText.h"
#import "App.h"

@interface SearchManager : NSObject

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

+ (SearchManager *)instance;

- (SearchText *)startSearch:(NSString *)searchString ofType:(AppType)appType;
- (void)clearSearchTextHistory;
@property (nonatomic,assign)BOOL isMainView;
@end
