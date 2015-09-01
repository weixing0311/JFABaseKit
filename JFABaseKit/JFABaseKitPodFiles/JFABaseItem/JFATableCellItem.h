//
//  JFATableCellItem.h
//  JFABaseKit
//
//  Created by stefan on 15/8/27.
//  Copyright (c) 2015年 JF. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JFATableCellItem;

typedef void(^JFATableSelected)(JFATableCellItem* item);

@interface JFATableCellItem : NSObject

@property (nonatomic, copy)JFATableSelected selected;

-(NSString*)cellXibName;

-(NSString*)cellClassName;

-(CGFloat)cellHeight;

-(void)setupWithData:(id)data;

@end
