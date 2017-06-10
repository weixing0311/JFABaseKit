//
//  YDObject.m
//  YDBase
//
//  Created by jxzang on 14-4-28.
//  Copyright (c) 2014年  com.7ulipa All rights reserved.
//

#import "XObject.h"

@interface XObject()
{
    __strong NSDictionary* _dictionary;
}

@end

@implementation XObject

- (id)initWithDictionary:(NSDictionary *)inDic
{
    if (self = [super init])
    {
        [self updateWithDictionary:inDic];
    }
    
    return self;
}

- (NSDictionary *)dictionary
{
    return _dictionary;
}

+ (NSMutableArray *)arrayWithDicionaryArray:(NSArray *)inArray
{
	if (! [inArray isKindOfClass:[NSArray class]])
	{
		return nil;
	}
    NSMutableArray* results = [NSMutableArray arrayWithCapacity:inArray.count];
    
    if ([inArray isKindOfClass:[NSArray class]])
    {
        for (int i = 0; i < inArray.count; i ++)
        {
            [results addObject:[[[self class] alloc] initWithDictionary:inArray[i]]];
        }
    }
    
    return results;
}

- (void)updateWithDictionary:(NSDictionary *)inDic
{
    if (! [inDic isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    
    if ([self autoSetValues])
    {
        if ([inDic isKindOfClass:[NSDictionary class]])
        {
            [self setValuesForKeysWithDictionary:inDic];
        }
    }
    else
    {
        NSArray* keys = [self keys];
        if (keys.count)
        {
            for (int i = 0; i < keys.count; i++)
            {
                NSString* k = keys[i];
                [self setValue:[inDic objectForKey:k] forKey:k];
            }
        }
    }
    
    _dictionary = inDic;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // kill NSUndefinedKeyException
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

- (BOOL)autoSetValues
{
    return NO;
}

- (NSMutableDictionary *)dictionaryValue
{
    NSArray* keys = [self keys];
    if (keys.count)
    {
        NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:keys.count];
        for (NSString* key in keys)
        {
            id value = [self valueForKey:key];
            if (value)
            {
                [dic setObject:value forKey:key];
            }
        }
        return dic;
    }
    else
    {
        return nil;
    }
}

+ (NSMutableArray*)dictionaryArrayWithObjectArray:(NSArray*)inArray
{
    NSMutableArray* results = [NSMutableArray arrayWithCapacity:inArray.count];
    for (XObject* obj in inArray)
    {
        NSDictionary* dic = [obj dictionaryValue];
        if (dic)
        {
            [results addObject:dic];
        }
    }
    return results;
}


@end
