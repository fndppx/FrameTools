//
//  VHStystemSetting.h
//  VhallIphone
//
//  Created by vhall on 15/7/30.
//  Copyright (c) 2015年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VHStystemSetting : NSObject
+ (VHStystemSetting *)sharedSetting;

@property(nonatomic)BOOL isPushMsg;
@property(nonatomic)BOOL isOnlyWIFIPlay;
@property(nonatomic)BOOL isNotifyFans;
@property(nonatomic)int  videoResolution;
@property(nonatomic)int  bitRate;

@property(nonatomic)BOOL isUpdateUserInfo;
//        AFNetworkReachabilityStatusUnknown          = -1,
//        AFNetworkReachabilityStatusNotReachable     = 0,
//        AFNetworkReachabilityStatusReachableViaWWAN = 1,
//        AFNetworkReachabilityStatusReachableViaWiFi = 2,
@property(nonatomic)int  netStatus;

@property(nonatomic)BOOL isCheckFlag;
@property(nonatomic)BOOL isUploadSys;
@property(nonatomic)int  tag;

@property(nonatomic,strong)NSString* hostUrl;//接口URL
@end
