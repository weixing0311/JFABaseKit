//
//  JFATableGroupCellItem.h
//  JFABaseKit
//
//  Created by stefan on 15/8/27.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import "JFATableCellItem.h"

@interface JFATableGroupCellItem : JFATableCellItem

@property(nonatomic,copy)NSMutableArray* sectionArray;//section数据源

@property(nonatomic,copy)NSString* sectionTitle;//section Title

@end
