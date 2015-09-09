//
//  JFAAppManagerItem.h
//  JFAAppStoreHelper
//
//  Created by 魏星 on 15/9/8.
//  Copyright © 2015年 JF. All rights reserved.
//

#import "JFATableCellItem.h"

@interface JFAAppManagerItem : JFATableCellItem
@property(nonatomic,strong)NSString* appId;

@property(nonatomic,strong)NSString* logoUrl;

@property(nonatomic,strong)NSString* softName;

@property(nonatomic,strong)NSString* shortBrief;

@end
