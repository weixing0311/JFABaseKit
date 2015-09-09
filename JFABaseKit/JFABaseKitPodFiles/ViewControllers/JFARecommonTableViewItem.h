//
//  JFARecommonTableViewItem.h
//  JFAAppStoreHelper
//
//  Created by stefan on 15/9/6.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import "JFATableCellItem.h"

@interface JFARecommonTableViewItem : JFATableCellItem

@property(nonatomic,strong)NSString* appId;

@property(nonatomic,strong)NSString* logoUrl;

@property(nonatomic,strong)NSString* softName;

@property(nonatomic,strong)NSString* shortBrief;

@end


