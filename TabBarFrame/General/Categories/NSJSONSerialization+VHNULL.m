//
//  NSJSONSerialization+VHNULL.m
//  VhallIphone
//
//  Created by dev on 16/6/13.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//

#import "NSJSONSerialization+VHNULL.h"
#import <objc/runtime.h>
static id AFJSONObjectByRemovingKeysWithNullValues(id JSONObject, NSJSONReadingOptions readingOptions) {
    if ([JSONObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[(NSArray *)JSONObject count]];
        for (id value in (NSArray *)JSONObject) {
            [mutableArray addObject:AFJSONObjectByRemovingKeysWithNullValues(value, readingOptions)];
        }
        
        return (readingOptions & NSJSONReadingMutableContainers) ? mutableArray : [NSArray arrayWithArray:mutableArray];
    } else if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:JSONObject];
        for (id <NSCopying> key in [(NSDictionary *)JSONObject allKeys]) {
            id value = (NSDictionary *)JSONObject[key];
            if (!value || [value isEqual:[NSNull null]]) {
                [mutableDictionary removeObjectForKey:key];
            } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                mutableDictionary[key] = AFJSONObjectByRemovingKeysWithNullValues(value, readingOptions);
            }
        }
        
        return (readingOptions & NSJSONReadingMutableContainers) ? mutableDictionary : [NSDictionary dictionaryWithDictionary:mutableDictionary];
    }
    
    return JSONObject;
}
@implementation NSJSONSerialization (VHNULL)
+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method oldMethod = class_getClassMethod([NSJSONSerialization class], @selector(JSONObjectWithData:options:error:));
        Method newMethod = class_getClassMethod([NSJSONSerialization class], @selector(VHJSONObjectWithData:options:error:));
        method_exchangeImplementations(oldMethod, newMethod);
    });
}
+(nullable id)VHJSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError **)error
{
    id objc = [self VHJSONObjectWithData:data options:opt error:error];
    return AFJSONObjectByRemovingKeysWithNullValues(objc,opt);
}
@end
