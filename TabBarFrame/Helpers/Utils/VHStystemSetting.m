//
//  VHStystemSetting.m
//  VhallIphone
//
//  Created by vhall on 15/7/30.
//  Copyright (c) 2015年 www.vhall.com. All rights reserved.
//

#import "VHStystemSetting.h"
#import "EGOCache.h"

@implementation VHStystemSetting

static VHStystemSetting *pub_sharedSetting = nil;

+ (VHStystemSetting *)sharedSetting
{
    @synchronized(self)
    {
        if (pub_sharedSetting == nil)
        {
            pub_sharedSetting = [[VHStystemSetting alloc] init];
        }
    }
    
    return pub_sharedSetting;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (pub_sharedSetting == nil) {
            
            pub_sharedSetting = [super allocWithZone:zone];
            return pub_sharedSetting;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
//        _isPushMsg      = [VH_UserDefaults boolForKey:@"isPushMsg"];
//        _isOnlyWIFIPlay = [VH_UserDefaults boolForKey:@"isOnlyWIFIPlay"];
//        _isNotifyFans   = [VH_UserDefaults boolForKey:@"isNotifyFans"];
//        _videoResolution= (int)[VH_UserDefaults integerForKey:@"videoResolution"];
//        if(_videoResolution <= kVideoResolution1)
//            self.videoResolution = kVideoResolution2;
//        _bitRate        = (int)[VH_UserDefaults integerForKey:@"bitRate"];
//        _isUpdateUserInfo=[VH_UserDefaults boolForKey:@"isUpdateUserInfo"];
//        _tag            = (int)[VH_UserDefaults integerForKey:@"tag"];
//        _hostUrl        =  [VH_UserDefaults objectForKey:@"hostUrl"];
//
//        _netStatus = 2;
//        _isCheckFlag =[VHTools compareCheckFlagDate];//比较时间是否大于7天;
//        _isUploadSys = NO;
//        if(_bitRate<=100)
//            self.bitRate = KBitRate300;

//        if(_hostUrl == nil || (![_hostUrl isEqualToString:VHNET_HOSTURL] && ![_hostUrl isEqualToString:VHNET_HOSTURL_T]))
//        {
//            self.hostUrl = VHNET_HOSTURL;
//        }
//        
//#ifndef USE_BACKDOOR
//        self.hostUrl = VHNET_HOSTURL;
//#endif
    }
    return self;
}

- (void)setIsPushMsg:(BOOL)isPushMsg
{
    _isPushMsg = isPushMsg;
//    [VH_UserDefaults setBool:_isPushMsg forKey:@"isPushMsg"];
//    [VH_UserDefaults synchronize];
}

- (void)setIsOnlyWIFIPlay:(BOOL)isOnlyWIFIPlay
{
    _isOnlyWIFIPlay = isOnlyWIFIPlay;
//    [VH_UserDefaults setBool:_isOnlyWIFIPlay forKey:@"isOnlyWIFIPlay"];
//    [VH_UserDefaults synchronize];
}

- (void)setIsNotifyFans:(BOOL)isNotifyFans
{
    _isNotifyFans = isNotifyFans;
//    [VH_UserDefaults setBool:_isNotifyFans forKey:@"isNotifyFans"];
//    [VH_UserDefaults synchronize];
}

- (void)setVideoResolution:(int)videoResolution
{
    _videoResolution = videoResolution;
//    [VH_UserDefaults setInteger:_videoResolution forKey:@"videoResolution"];
//    [VH_UserDefaults synchronize];
}

- (void)setBitRate:(int)bitRate
{
    _bitRate = bitRate;
//    [VH_UserDefaults setInteger:bitRate forKey:@"bitRate"];
//    [VH_UserDefaults synchronize];
}


- (void)setIsUpdateUserInfo:(BOOL)isUpdateUserInfo
{
    _isUpdateUserInfo = isUpdateUserInfo;
//    [VH_UserDefaults setBool:_isUpdateUserInfo forKey:@"isUpdateUserInfo"];
//    [VH_UserDefaults synchronize];
}

- (void)setTag:(int)tag
{
    _tag = tag;
//    [VH_UserDefaults setInteger:_tag forKey:@"tag"];
//    [VH_UserDefaults synchronize];
}

- (void)setHostUrl:(NSString *)hostUrl
{
    _hostUrl = hostUrl;
//    [VH_UserDefaults setObject:hostUrl forKey:@"hostUrl"];
//    [VH_UserDefaults synchronize];
}


@end
