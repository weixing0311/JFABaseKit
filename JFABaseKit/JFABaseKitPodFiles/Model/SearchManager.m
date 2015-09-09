//
//  SearchManager.m
//  AppInstaller
//
//  Created by  on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SearchManager.h"
#import "SearchText.h"
//#import "AIApplicationUtility.h"

static SearchManager *_instance;

@implementation SearchManager

@synthesize managedObjectContext = _managedObjectContext;

+ (SearchManager *)instance
{
    if (_instance == NULL) {
        _instance = [[SearchManager alloc] init];
    }
    
    return _instance;
}

- (SearchText *)startSearch:(NSString *)searchString ofType:(AppType)appType
{
    if (searchString == nil) {
        SearchText *searchText = nil;
        searchText = [NSEntityDescription insertNewObjectForEntityForName:@"SearchText" inManagedObjectContext:self.managedObjectContext];
        searchText.text = searchString;
        searchText.type = [NSNumber numberWithInt:appType];
        searchText.searchDate = [NSDate date];
        return searchText;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SearchText"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"text like %@ and type == %@", searchString, [NSNumber numberWithInt:appType]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];

    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    SearchText *searchText = nil;
    if (results.count == 0) {
        searchText = [NSEntityDescription insertNewObjectForEntityForName:@"SearchText" inManagedObjectContext:self.managedObjectContext];
        searchText.text = searchString;
        searchText.type = [NSNumber numberWithInt:appType];
    } else {
        searchText = [results objectAtIndex:0];
    }
    
    searchText.searchDate = [NSDate date];
    
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    NSAssert1(error == nil, @"failed to save the context because: %@", error);
        
    return searchText;
}

- (void)clearSearchTextHistory
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SearchText"];
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    for (SearchText * search in results) {
        
        [self.managedObjectContext deleteObject:search];
    }
    
    
}
@end
