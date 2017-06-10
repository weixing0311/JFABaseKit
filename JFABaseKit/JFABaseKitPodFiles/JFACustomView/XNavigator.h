//
//  CNavigator.h
//  HotelManager
//
//  Created by Tulipa on 14-4-29.
//  Copyright (c) 2014年  com.7ulipa All rights reserved.
//

#import <TTNavigator/TTBaseNavigator.h>

@interface XNavigator : TTBaseNavigator

+ (XNavigator*)navigator;

- (id)popToViewControllerWithClass:(Class)klass animated:(BOOL)animated;

@end
