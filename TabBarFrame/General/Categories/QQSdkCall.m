////
////  QQSdkCall.m
////  vhall1
////
////  Created by yangyang on 14-3-24.
////  Copyright (c) 2014年 vhallrd01. All rights reserved.
////
//
//#import "QQSdkCall.h"
//#import <TencentOpenAPI/TencentOAuth.h>
//
//@interface QQSdkCall() <TencentSessionDelegate>
//{
//    
//}
//@end
//
//@implementation QQSdkCall
//
//
//+ (QQSdkCall *)getinstance {
//    static QQSdkCall *_sharedManager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _sharedManager = [[super allocWithZone:NULL]init];
//    });
//    
//    return _sharedManager;
//}
//
//+ (id)allocWithZone:(NSZone *)zone
//{
//    return [self getinstance];
//}
//
//- (id)copyWithZone:(NSZone *)zone
//{
//    return self;
//}
//
//
//- (id)init{
//    
//    self = [super init];
//    if (self) {
//        NSString *appid = @"101031821";
//        
//        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:appid
//                                                andDelegate:self];
//
//    }
//    return self;
//}
//
//- (void)getUserInfoResponse:(APIResponse*) response {
//
//        if (response.retCode == URLREQUEST_SUCCEED)
//        {
//            if (_thirdRegBlock) {
//                NSString *username = [response.jsonResponse objectForKey:@"nickname"];
//                NSString *profileImage =  ![[response.jsonResponse objectForKey:@"figureurl_2"]isKindOfClass:[NSNull class]]? [response.jsonResponse objectForKey:@"figureurl_2"]:[response.jsonResponse objectForKey:@"figureurl_1"];
//                NSString *gender = @"0";
//                if (![[response.jsonResponse objectForKey:@"gender"]isEqualToString:@"男"]) {
//                    gender =@"1";
//                }
//                NSString *uid =_tencentOAuth.openId;
//                
//                self.thirdRegBlock(@"6",uid,username,gender,profileImage);
//                //跳转到主页面
//
//            }
//            
//            
//        }
//        else
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
//                                  
//                                                           delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
//            [alert show];
//        }
//
//}
//
//////////////////////////////
//
//
//- (void)removeAuthData
//{
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
//}
//
//- (void)storeAuthData
//{
//}
//
//- (void)showInvalidTokenOrOpenIDMessage{
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"api调用失败" message:@"可能授权已过期，请重新获取" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
//}
//
//
////设置页分享好友调用
//- (void)authorize:(NSArray *)permissions shareWithTitle:(NSString *)title withContent:(NSString *)content completion:(void(^)(TencentOAuth *TencentOAuth))completion
//{
//    _completionBlock = completion;
//    [_tencentOAuth authorize:_permissions];
//    
//    
//}
//
//
//
///**
// * 登录成功后的回调
// */
//- (void)tencentDidLogin
//{
//    
//    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
//    {
//        if(![_tencentOAuth getUserInfo]){
//            [self showInvalidTokenOrOpenIDMessage];
//        }
//        
//        //存本地
//        
//        NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
//                                  _tencentOAuth.accessToken, @"AccessTokenKey",
//                                  _tencentOAuth.expirationDate, @"ExpirationDateKey",
//                                  _tencentOAuth.openId,@"OpenId", nil];
//        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"TencentAuthData"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
////        if (IS_IPAD()) {
//            if (_completionBlock) {
//                _completionBlock(_tencentOAuth);
//            }
////        }
//        
//        
//    }
//    else
//    {
//        NSLog(@"登录不成功 没有获取accesstoken");
//    }
//    
//
//}
//
///**
// * 登录失败后的回调
// * \param cancelled 代表用户是否主动退出登录
// */
//- (void)tencentDidNotLogin:(BOOL)cancelled
//{
////    self.thirdRegBlock(nil,nil,nil,nil,nil);
//}
//
///**
// * 登录时网络有问题的回调
// */
//- (void)tencentDidNotNetWork
//{
//    
//}
//
//
//
//
//@end
