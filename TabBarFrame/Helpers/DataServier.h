//
//  DataServier.h
//  vhallIphone
//
//  Created by yangyang on 14-7-23.
//  Copyright (c) 2014年 zhangxingming. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FinishLoadHandle) ( id responseObject,NSError *error);

@interface DataServier : NSObject

+(void)requestWithAFN:(NSString *)op
            GetParams:(NSDictionary *)getparams
           PostParams:(NSDictionary *)postparams
          finishBlock:(FinishLoadHandle)finishBlock;


+(void)requestWithAFN:(NSString *)op
            GetParams:(NSDictionary *)getparams
           PostParams:(NSDictionary *)postparams
      timeoutInterval:(NSTimeInterval)timeoutInterval
          finishBlock:(FinishLoadHandle)finishBlock;



//基本不用
+ (void)getWithAFN:(NSString *)url
            params:(NSDictionary *)params
   timeoutInterval:(NSTimeInterval)timeoutInterval
       finishBlock:(FinishLoadHandle)finishBlock;


//v3.2后已废弃
+ (void)requestWithAFN:(NSString *)op
                params:(NSDictionary *)params
           finishBlock:(FinishLoadHandle)finishBlock;

+ (void)requestWithAFN:(NSString *)op
                params:(NSDictionary *)params
               timeOut:(NSTimeInterval)timeOut
           finishBlock:(FinishLoadHandle)finishBlock;
@end
