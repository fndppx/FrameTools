//
//  NSArray+Search.h
//  VhallIphone
//
//  Created by developer_k on 16/3/29.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Search)
/**
 *  线性查找
 *
 *  @param object 检索对象
 *
 *  @return 查找结果
 */
- (NSInteger)linearSearchFor:(id)object;
- (id)linearSearchForIn:(id)objectt;
- (id)linearSearchEnumerate:(id)object;

/**
 *  折半查找
 *
 *  @param object 检索目标
 *
 *  @return 查找结果
 */
- (NSInteger)halfSearch:(id)object;

/**
 *  NSSet查找
 *
 *  @param objext 检索目标
 *
 *  @return 查找结果
 */
- (id)setSearch:(id)object;

@end
