//
//  VHBTFiter.m
//  VhallIphone
//
//  Created by developer_k on 16/3/29.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//

#import "VHBTFiter.h"
#import "NSArray+Search.h"

@interface VHBTFiter()
@property(nonatomic,copy)NSMutableDictionary * keyDic;

@end

@implementation VHBTFiter

+(VHBTFiter *)shareBTFiter
{
    static VHBTFiter*shareBT = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareBT = [[self alloc]init ];

    });
    return shareBT;
}

-(instancetype)init
{
    if (self = [super init]) {
        [self keywordRead];
    }
    return self;
}

-(void)keywordRead
{
    self.keyDic = [NSMutableDictionary dictionaryWithContentsOfFile:[self documentPath]];

}

-(NSString*)documentPath{
    return [[NSBundle mainBundle] pathForResource:@"SensitiveWordsList" ofType:@"plist"];
}

/**
 *  字符过滤方法
 *
 *  @param string 被过滤字符
 *
 *  @return 过滤后字符
 */
- (NSString *)filterWithString:(NSString *)string{
    //判断是否存在关键字
    if (!self.keyDic) {
        return string;
    }
    //文字信息转换小写
    NSString *tempString = [string lowercaseString];
    //关键字替换
    NSString *filteredString = [self replaceKeyWordWith:tempString];
    //与原始文本信息比对返回最终结果
    if ([filteredString isEqualToString:tempString]) {
        return string;
    }else{
        return filteredString;
    }
}

/**
 *  关键字替换算法
 *
 *  @param string 被过滤文字
 */
- (NSString *)replaceKeyWordWith:(NSString *)string {
    //"*"
    NSString *filter;
    //关键字位置
    NSRange range;

    for (int i = 0; i < string.length;) {
        //字符关键字过滤
        NSString *subString = [string substringWithRange:NSMakeRange(i, 1)];
        NSMutableArray *array =[self.keyDic objectForKey:subString];

        if (array) {
            for (int j = 0; j < array.count; j++) {
                //取得关键字在文字信息中的range
                NSString *keyString = array[j];
                range = [string rangeOfString:keyString];
                if (range.length) {
                    filter = [@"*" stringByPaddingToLength:range.length withString:@"*"startingAtIndex:0];
                    i += keyString.length - 1;
                    string = [string stringByReplacingCharactersInRange:range withString:filter];
                    break;
                }
            }
        }
        i++;
    }
    return string;
}

/**
 *  写入关键字
 *
 *  @param array 关键字数组
 */
- (void)keyWordWriteWithArray:(NSArray *)array{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *string in array) {
        if (![string isEqualToString:@""]) {
            NSString *firstChar = [string substringToIndex:1];
            if ([[dic allKeys] containsObject:firstChar]) {
                NSMutableArray *array = [dic objectForKey:firstChar];
                [array addObject:string];
                [array sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
                    if (obj1.length < obj2.length) {
                        return NSOrderedDescending;
                    }else if (obj1.length > obj2.length){
                        return NSOrderedAscending;
                    }
                    return NSOrderedSame;
                }];
            } else {
                NSMutableArray *array = [NSMutableArray array];
                [array addObject:string];
                [dic setObject:array forKey:firstChar];
            }
        }
    }

    [dic writeToFile:[self documentPath] atomically:YES];

    self.keyDic = dic;
}


@end
