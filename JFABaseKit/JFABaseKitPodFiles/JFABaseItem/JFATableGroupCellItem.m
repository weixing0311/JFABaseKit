//
//  JFATableGroupCellItem.m
//  JFABaseKit
//
//  Created by stefan on 15/8/27.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import "JFATableGroupCellItem.h"

@implementation JFATableGroupCellItem

-(instancetype)init
{
    self=[super init];
    if (self) {
        self.sectionArray=[[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}


@end
