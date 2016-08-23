////
////  QQSdkCall.h
////  vhall1
////
////  Created by yangyang on 14-3-24.
////  Copyright (c) 2014年 vhallrd01. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
////#import <TencentOpenAPI/TencentOAuth.h>
////#import <TencentOpenAPI/TencentOAuthObject.h>
////#import "TencentOpenAPI/QQApiInterface.h"
//
//typedef void (^Block)(TencentOAuth *);
//@protocol QQSdkCallDelegate <NSObject>
//
//-(void)thirdRegWithQQ;
//
//@end
//
//@interface QQSdkCall : NSObject 
//+ (QQSdkCall *)getinstance;
//
//
//- (void)showInvalidTokenOrOpenIDMessage;
//
//@property (nonatomic, strong)TencentOAuth *tencentOAuth;
//@property (nonatomic, strong)NSArray *permissions;
//@property (nonatomic, weak)id<QQSdkCallDelegate>delegate;
//@property (nonatomic,strong)void(^thirdRegBlock)(NSString *type,NSString *uid,NSString *userName, NSString *gender,NSString *img);
//@property (nonatomic,strong)Block completionBlock;
//
//- (void)authorize:(NSArray *)permissions shareWithTitle:(NSString *)title withContent:(NSString *)content completion:(void(^)(TencentOAuth *TencentOAuth))completion;
//
//@end
