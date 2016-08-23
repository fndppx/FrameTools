//
//  VHBTFiter.h
//  VhallIphone
//
//  Created by developer_k on 16/3/29.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VHBTFiter : NSObject

+(VHBTFiter*)shareBTFiter;
/**
 *  字符过滤方法
 *
 *  @param string 被过滤字符
 *
 *  @return 过滤后字符
 */

-(NSString*)filterWithString:(NSString*)string;
/**
 *  关键字写入
 *
 *  @param array 关键字数组
 */

-(void)keyWordWriteWithArray:(NSArray *)array;


@end
