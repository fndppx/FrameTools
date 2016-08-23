//
//  DataServier.m
//  vhallIphone
//
//  Created by yangyang on 14-7-23.
//  Copyright (c) 2014年 zhangxingming. All rights reserved.
//
#import "DataServier.h"
#import "AFNetworking.h"
//#import "VHUserServer.h"
//#import "VHNetOperate.h"
#import "VHStatisticsStystem.h"
AFHTTPSessionManager *g_manager;
@implementation DataServier

+ (void)requestWithAFN:(NSString *)op
                params:(NSDictionary *)params
           finishBlock:(FinishLoadHandle)finishBlock
{
    [DataServier requestWithAFN:op GetParams:nil PostParams:params timeoutInterval:30 finishBlock:finishBlock];
}

+ (void)requestWithAFN:(NSString *)op
                params:(NSDictionary *)params
               timeOut:(NSTimeInterval)timeOut
           finishBlock:(FinishLoadHandle)finishBlock
{
    [DataServier requestWithAFN:op GetParams:nil PostParams:params timeoutInterval:timeOut finishBlock:finishBlock];
}

+(void)requestWithAFN:(NSString *)op
            GetParams:(NSDictionary *)getparams
           PostParams:(NSDictionary *)postparams
          finishBlock:(FinishLoadHandle)finishBlock
{
    [DataServier requestWithAFN:op GetParams:getparams PostParams:postparams timeoutInterval:30 finishBlock:finishBlock];
}

+(void)requestWithAFN:(NSString *)op
            GetParams:(NSDictionary *)getparams
           PostParams:(NSDictionary *)postparams
      timeoutInterval:(NSTimeInterval)timeoutInterval
          finishBlock:(FinishLoadHandle)finishBlock
{
    
//    NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@%@?",VH_SETTING.hostUrl,VHNET_INTERFACE_VER,op];
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@%@?",@"",@"",op];

    if(getparams)
    {
        NSArray *myKeys = [getparams allKeys];
        for(NSString* key in myKeys) {
            [url appendString:key];
            [url appendString:@"="];
            [url appendString:[VHTools urlEncodeUTF8String:[NSString stringWithFormat:@"%@",[getparams objectForKey:key]]]];
            [url appendString:@"&"];
            
        }
    }

    //公共参数
    [url appendString:@"atom="];
    [url appendString:[VHTools atomSting:[[VHStatisticsStystem sharedManager] getAtomDic]]];
//    [url appendString:@"&sid="];
//    [url appendString:VH_SID];
    [url appendString:@"&rand="];
    NSString *rand = [[NSString alloc]init];
    for (int i = 0; i < 5; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            rand = [rand stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            rand = [rand stringByAppendingString:tempString];
        }
    }
    [url appendString:rand];
    NSString* sign =[ VHTools MD5WithUrl:url Param:postparams];
    [url appendString:@"&sign="];
    [url appendString:sign];
    //临时跑通添加
//    [url appendString:@"&secret="];
//    [url appendString:@"1"];
    if(postparams)
    {
        // 1.获得请求管理者
        if(g_manager == nil)
        {
            g_manager = [AFHTTPSessionManager manager];
        }
        if(g_manager == nil)
        {
            if (finishBlock) {
                finishBlock(nil,[NSError errorWithDomain:@"网络库初始化错误" code:4001 userInfo:nil]);
            }
            return;
        }
        // 2.发送Post请求
        [g_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        g_manager.requestSerializer.timeoutInterval = timeoutInterval;
        [g_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        [g_manager.requestSerializer willChangeValueForKey:@"cachePolicy"];
        g_manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        [g_manager.requestSerializer didChangeValueForKey:@"cachePolicy"];
        ((AFJSONResponseSerializer*) g_manager.responseSerializer).removesKeysWithNullValues = YES;
        [g_manager POST:url parameters:postparams progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if (finishBlock) {
#ifdef DEBUG
                //            NSString *resultStr = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
                //            [VHTools testValue:responseObject key:nil op:opstr];
                VHLog(@"POST_AFN: %@",op);
#endif
                @try
                {
                    NSMutableDictionary * dic = [responseObject mutableCopy];
                    if ([dic[@"data"] isKindOfClass:[NSArray class]]&&((NSArray*)dic[@"data"]).count<=0) {
                        [dic removeObjectForKey:@"data"];
                    }
                    finishBlock([dic copy],nil);
                }@catch (NSException * e) {
                    NSLog(@"Exception_requestWithAFN: %@",e);
                }
            }

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (finishBlock) {
                finishBlock(nil,[NSError errorWithDomain:@"网络已断开，请检查网络" code:4000 userInfo:nil]);
            }
            VHLog(@"error=%@",error);
        }];
    }
    else
    {
        [DataServier getWithAFN:url params:nil timeoutInterval:timeoutInterval finishBlock:finishBlock];
    }
}

+ (void)getWithAFN:(NSString *)url params:(NSDictionary *)params timeoutInterval:(NSTimeInterval)timeoutInterval finishBlock:(FinishLoadHandle)finishBlock
{
    if(g_manager == nil)
    {
        g_manager = [AFHTTPSessionManager manager];
    }
    if(g_manager == nil)
    {
        if (finishBlock) {
            finishBlock(nil,[NSError errorWithDomain:@"网络库初始化错误" code:4001 userInfo:nil]);
        }
        return;
    }
    // 设置超时时间
    [g_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    g_manager.requestSerializer.timeoutInterval = timeoutInterval;
    [g_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    [g_manager.requestSerializer willChangeValueForKey:@"cachePolicy"];
    g_manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    [g_manager.requestSerializer didChangeValueForKey:@"cachePolicy"];
    ((AFJSONResponseSerializer*) g_manager.responseSerializer).removesKeysWithNullValues = YES;
    [g_manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
        if (finishBlock) {
#ifdef DEBUG
            NSString *urlStr = [task.originalRequest.URL absoluteString];
            NSRange range = [urlStr rangeOfString:@"atom"];
            if(range.location != NSNotFound)
                VHLog(@"GET_AFN: %@",[urlStr substringToIndex:range.location-1]);
            else
                VHLog(@"GET_AFN: %@",urlStr);
            
#endif
            finishBlock(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (finishBlock) {
            finishBlock(nil,[NSError errorWithDomain:@"网络已断开，请检查网络" code:4000 userInfo:nil]);
            VHLog(@"error=%@",error);
        }
    }];
}

@end
