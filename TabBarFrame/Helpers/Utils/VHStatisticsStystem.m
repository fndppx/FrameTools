//
//  VHStatisticsStystem.m
//  vhallIphone
//
//  Created by vhallrd01 on 14-8-5.
//  Copyright (c) 2014年 zhangxingming. All rights reserved.
//

#import "VHStatisticsStystem.h"
#import<CoreTelephony/CTTelephonyNetworkInfo.h>
#include "sys/types.h"
#include "sys/sysctl.h"
//#import "UMMobClick/MobClick.h"
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <net/if.h>

#ifdef DEBUG
#import <mach/mach.h>
#endif

typedef NS_ENUM(NSUInteger, AddressType) {
    
    AddressTypeBoth     = 0,
    AddressTypeIPv4     = 1,
    AddressTypeIPv6     = 2
};

typedef enum {
    NETWORK_TYPE_NONE= 0,
    NETWORK_TYPE_WIFI,
    NETWORK_TYPE_2G,
    NETWORK_TYPE_3G,
    NETWORK_TYPE_4G,
}NETWORK_TYPE;

@interface VHStatisticsStystem()
{
long last_WiFiSent;
long last_WiFiReceived;
long last_WWANSent;
long last_WWANReceived;
}
@end

@implementation VHStatisticsStystem

static VHStatisticsStystem *_statisticsStystemsharedManager = nil;

+ (VHStatisticsStystem *)sharedManager
{
    @synchronized(self)
    {
        if (_statisticsStystemsharedManager == nil)
        {
            _statisticsStystemsharedManager = [[VHStatisticsStystem alloc] init];
        }
    }
    
    return _statisticsStystemsharedManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (_statisticsStystemsharedManager == nil) {
            
            _statisticsStystemsharedManager = [super allocWithZone:zone];
            return _statisticsStystemsharedManager;  // assignment and return on first allocation
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
        
    }
    
    return self;
}

- (NSString *)devideIP
{
    if (_iphoneIp == nil || _iphoneIp.length <= 0)
    {
        NSURL *iPURL = [NSURL URLWithString:@""];
        if (iPURL) {
            NSError *error = nil;
            NSString *theIpHtml = [NSString stringWithContentsOfURL:iPURL
                                                           encoding:NSUTF8StringEncoding
                                                              error:&error];
            if (!error) {
                NSLog(@"the theiphtml is %@",theIpHtml);
                _iphoneIp = theIpHtml;
                NSLog(@"%@",theIpHtml);
            } else {
                _iphoneIp = @"";
            }
        }
    }
    
    if (_iphoneIp == nil)
    {
        _iphoneIp = @"";
    }
    return _iphoneIp;
}

- (BOOL)isBreak
{
    return NO;
}

-(WWANState)wwanState
{
    WWANState returnValue = WWANStateNone;
    CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc] init];
    NSString *currentRadioAccessTechnology = info.currentRadioAccessTechnology;
    if (currentRadioAccessTechnology)
    {
        if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE])
        {
            returnValue =  WWANState4G;
        }
        else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS])
        {
            returnValue =  WWANState2G;
        }
        else
        {
            returnValue =  WWANState3G;
        }
    }
    return returnValue;
}

- (NSString *)netWorkStatus//状态栏隐藏后不可用
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    int netType = NETWORK_TYPE_NONE;
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    if (num == nil) {
        
        netType = NETWORK_TYPE_NONE;
        
    }else{
        
        int n = [num intValue];
        if (n == 0) {
            netType = NETWORK_TYPE_NONE;
        }else if (n == 1){
            netType = NETWORK_TYPE_2G;
        }else if (n == 2){
            netType = NETWORK_TYPE_3G;
        }else if (n == 3){
            netType = NETWORK_TYPE_4G;
        }else{
            netType = NETWORK_TYPE_WIFI;
        }
        
    }
//    NSLog(@"%@",num);
    
    NSString *netWork = nil;
    if (netType == NETWORK_TYPE_NONE)
    {
        netWork = @"无网络";
    }
    else if(netType == NETWORK_TYPE_2G)
    {
        netWork = @"2G";
    }
    else if(netType == NETWORK_TYPE_3G)
    {
        netWork = @"3G";
    }
    else if(netType == NETWORK_TYPE_4G)
    {
        netWork = @"4G";
    }
    else if(netType == NETWORK_TYPE_WIFI)
    {
        netWork = @"wifi";
    }
    
    return netWork;
    
}

- (NSString *)netWork
{
//    void *connection = _CTServerConnectionCreate(kCFAllocatorDefault, NULL, NULL);
//    
//    NSDictionary *info = nil;
//    struct CTResult result;
//    _CTServerConnectionCopyMobileEquipmentInfo(&result, connection, &info);
//    CFRelease(connection);
//    
//    NSString* imsi = (NSString*)info[(__bridge NSString*)kCTMobileEquipmentInfoIMEI];
//
//    
//    if (imsi == nil || [imsi isEqualToString:@"SIM Not Inserted"] ) {
//        return @"Unknown";
//    }
//    else {
//        if ([[imsi substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"460"]) {
//            NSInteger MNC = [[imsi substringWithRange:NSMakeRange(3, 2)] intValue];
//            switch (MNC) {
//                case 00:
//                case 02:
//                case 07:
//                    return @"China Mobile";
//                    break;
//                case 01:
//                case 06:
//                    return @"China Unicom";
//                    break;
//                case 03:
//                case 05:
//                    return @"China Telecom";
//                    break;
//                case 20:
//                    return @"China Tietong";
//                    break;
//                default:
//                    break;
//            }
//        }
//    }
//    return @"Unknown";
    return @"";
}

- (NSString *)mobileModelString
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *answer = malloc(size);
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    free(answer);
    
    NSLog(@"the result is %@",results);
    return results;
}

- (NSString *)mobileModel
{
    NSString *results = self.mobileModelString;
    NSString *moblie = nil;

    if ([results isEqualToString:@"iPad1,1"])
    {
        moblie = @"ipad 1G";
    }
    else if([results isEqualToString:@"iPad2,1"] || [results isEqualToString:@"iPad2,2"] || [results isEqualToString:@"iPad2,3"]  ||[results isEqualToString:@"iPad2,4"])
    {
        moblie = @"ipad 2";
    }
    else if([results isEqualToString:@"iPad3,1"] || [results isEqualToString:@"iPad3,2"] || [results isEqualToString:@"iPad3,3"])
    {
        moblie = @"ipad 3";
    }
    else if([results isEqualToString:@"iPad3,4"] || [results isEqualToString:@"iPad3,5"] || [results isEqualToString:@"iPad3,6"])
    {
        moblie = @"ipad 4";
    }
    else if([results isEqualToString:@"iPad4,1"] || [results isEqualToString:@"iPad4,2"] || [results isEqualToString:@"iPad4,3"])
    {
        moblie = @"ipad air";
    }
    else if([results isEqualToString:@"iPad5,1"] || [results isEqualToString:@"iPad5,2"] || [results isEqualToString:@"iPad5,3"])
    {
        moblie = @"ipad air2";
    }
    else if([results isEqualToString:@"iPad2,5"] || [results isEqualToString:@"iPad2,6"] || [results isEqualToString:@"iPad2,7"])
    {
        moblie = @"ipad mini 1G";
    }
    else if([results isEqualToString:@"iPad4,4"] || [results isEqualToString:@"iPad4,5"] || [results isEqualToString:@"iPad4,6"])
    {
        moblie = @"ipad mini 2G";
    }
    else if([results isEqualToString:@"iPhone3,1"] || [results isEqualToString:@"iPhone3,2"] || [results isEqualToString:@"iPhone3,3"])
    {
        moblie = @"iPhone 4";
    }
    else if([results isEqualToString:@"iPhone4,1"])
    {
        moblie = @"iPhone 4S";
    }
    else if([results isEqualToString:@"iPhone5,1"] || [results isEqualToString:@"iPhone5,2"])
    {
        moblie = @"iPhone 5";
    }
    else if([results isEqualToString:@"iPhone5,3"] || [results isEqualToString:@"iPhone5,4"])
    {
        moblie = @"iPhone 5c";
    }
    else if([results isEqualToString:@"iPhone6,1"] || [results isEqualToString:@"iPhone6,2"])
    {
        moblie = @"iPhone 5s";
    }
    else if([results isEqualToString:@"iPhone7,1"])
    {
        moblie = @"iPhone 6 Plus";
    }
    else if([results isEqualToString:@"iPhone7,2"])
    {
        moblie = @"iPhone 6";
    }
    
    else if ([results   isEqualToString:@"iPhone8,1"]){
        
        moblie=@"iPhone 6S";
        
    }
    
    else if ([results isEqualToString:@"iPhone8,2"]){
        
        moblie=@"iPhone 6S Plus";
        
    }
    else if([results isEqualToString:@"iPod1,1"])
    {
        moblie = @"iPod touch 1G";
    }
    else if([results isEqualToString:@"iPod2,1"])
    {
        moblie = @"iPod touch 2G";
    }
    else if([results isEqualToString:@"iPod3,1"])
    {
        moblie = @"iPod touch 3G";
    }
    else if([results isEqualToString:@"iPod4,1"])
    {
        moblie = @"iPod touch 4G";
    }
    else if([results isEqualToString:@"iPod5,1"])
    {
        moblie = @"iPod touch 5G";
    }
    else
        moblie = @"";
    
    
    return moblie;
}


- (NSString *)onlyID          //唯一串号
{
    NSString *onlyid;
    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    
    if (adSupportBundle == nil)
    {
        return @"";
    }
    else
    {
        
        Class ASIdentifierManagerClass = NSClassFromString(@"ASIdentifierManager");
        
        
        if(ASIdentifierManagerClass == nil)
        {
            return @"";
        }
        else if (ASIdentifierManagerClass) {
            SEL sharedManagerSelector = NSSelectorFromString(@"sharedManager");
            id sharedManager = ((id (*)(id, SEL))[ASIdentifierManagerClass methodForSelector:sharedManagerSelector])(ASIdentifierManagerClass, sharedManagerSelector);
            SEL advertisingIdentifierSelector = NSSelectorFromString(@"advertisingIdentifier");
            NSUUID *uuid = ((NSUUID* (*)(id, SEL))[sharedManager methodForSelector:advertisingIdentifierSelector])(sharedManager, advertisingIdentifierSelector);
            onlyid = [uuid UUIDString];
        }
    }
    
    return onlyid;
    
}


- (NSString *)OS               //操作系统
{    return @"ios";
}
- (NSString *)OSversion        //操作系统版本
{
    NSString *OSversion =[[UIDevice currentDevice]systemVersion];
    return OSversion;
}
- (NSString *)deviceType       //设备类型
{
    NSString *deviceType = [[UIDevice currentDevice]model];
    return deviceType;
}
- (NSString *)deviceID         //设备号
{
    //idfv
    NSString *deviceID =  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return deviceID;
}

- (NSString *)time
{
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *date=[nsdf2 stringFromDate:[NSDate date]];
    
    return date;
}


- (NSDictionary *) _interfaceAddressesForFamily:(AddressType)family {
    
    NSMutableDictionary *interfaceInfo = [NSMutableDictionary dictionary];
    struct ifaddrs *interfaces;
    
    if ( (0 == getifaddrs(&interfaces)) ) {
        
        struct ifaddrs *interface;
        
        for ( interface=interfaces; interface != NULL; interface=interface->ifa_next ) {
            
            if ( (interface->ifa_flags & IFF_UP) && !(interface->ifa_flags & IFF_LOOPBACK) ) {
                
                const struct sockaddr_in *addr = (const struct sockaddr_in *)interface->ifa_addr;
                
                if ( addr && addr->sin_family == PF_INET ) {
                    
                    if ( (family == AddressTypeBoth) || (family == AddressTypeIPv4) ) {
                        char ip4Address[INET_ADDRSTRLEN];
                        inet_ntop( addr->sin_family, &(addr->sin_addr), ip4Address, INET_ADDRSTRLEN );
                        
                        [interfaceInfo setObject:[NSString stringWithUTF8String:interface->ifa_name]
                                          forKey:[NSString stringWithUTF8String:ip4Address]];
                        
                    } } else if ( addr && addr->sin_family == PF_INET6 ) {
                        
                        if ( (family == AddressTypeBoth) || (family == AddressTypeIPv6) ) {
                            char ip6Address[INET6_ADDRSTRLEN];
                            inet_ntop( addr->sin_family, &(addr->sin_addr), ip6Address, INET6_ADDRSTRLEN );
                            
                            [interfaceInfo setObject:[NSString stringWithUTF8String:interface->ifa_name]
                                              forKey:[NSString stringWithUTF8String:ip6Address]];
                        } }
            }
            
        } freeifaddrs( interfaces );
        
    } return [NSDictionary dictionaryWithDictionary:interfaceInfo];
}

- (NSString *)token            //deviceToken
{
    NSDictionary *deviceTokenDic = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/deviceTokenCache.plist",NSTemporaryDirectory()]];
        if (deviceTokenDic)
           return [deviceTokenDic objectForKey:@"deviceToken"];
    return @"";
            
}
- (NSString *)version          //APP版本
{
    
    return [NSString stringWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}

- (NSMutableDictionary*)getAtomDic
{

    if(_stystemInfo == nil)
    {
        _stystemInfo = [NSMutableDictionary dictionary];
//        [_stystemInfo setValue:VH_userId              forKey:@"uid"];
//        [_stystemInfo setValue:[VHUserServer sid]     forKey:@"sid"];
        [_stystemInfo setValue:@"10000"               forKey:@"cc"];
        [_stystemInfo setValue:@"ios"                 forKey:@"pf"];
        [_stystemInfo setValue:self.version           forKey:@"cv"];
        [_stystemInfo setValue:self.mobileModelString forKey:@"dt"];
        [_stystemInfo setValue:self.onlyID            forKey:@"imei"];
        [_stystemInfo setValue:@""                    forKey:@"imsi"];
        [_stystemInfo setValue:@""                    forKey:@"pn"];
        [_stystemInfo setValue:self.netWorkStatus forKey:@"cn"];
    }
//    [_stystemInfo setValue:VH_userId              forKey:@"uid"];
//    [_stystemInfo setValue:[VHUserServer sid]     forKey:@"sid"];
    [_stystemInfo setValue:self.netWorkStatus forKey:@"cn"];
    return _stystemInfo;
//    uid 用户ID int 未登录留空
//    sid 用户认证过的Token，未登录留空
//    cc 渠道号，默认传10000，必填
//    pf APP平台 ios | android 必填
//    cn 网络环境，WIFI、3G、4G 获取不到留空
//    cv 版本号 必填
//    dt 设备，主要为手机型号等 获取不到留空
//    imei 手机串号 获取不到留空
//    imsi SIM序列号 获取不到留空
//    pn 手机号 获取不到留空
}

//- (NSDictionary*)stystemInfo
//{
//
//    
//    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
//    [dic setValue:self.onlyID forKey:@"id"];
//    [dic setValue:self.deviceType forKey:@"DeviceType"];
//    [dic setValue:self.deviceID forKey:@"deviceid"];
//    [dic setValue:self.mobileModel forKey:@"mobilemodel"];
//    [dic setValue:[NSNumber numberWithInt:0] forKey:@"device_os"];
//    [dic setValue:self.OSversion forKey:@"device_os_ver"];
//    [dic setValue:self.deviceType forKey:@"device_mode"];
//    [dic setValue:self.token forKey:@"token"];
//    [dic setValue:self.version forKey:@"version"];
//
//    return dic;
//}

#ifdef DEBUG
- (NSArray *)getDataCounters
{
    BOOL   success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    
    long WiFiSent = 0;
    long WiFiReceived = 0;
    long WWANSent = 0;
    long WWANReceived = 0;
    
    NSString *name=[[NSString alloc]init];
    
    success = getifaddrs(&addrs) == 0;
    if (success)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
//            NSLog(@"ifa_name %s == %@\n", cursor->ifa_name,name);
            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
            
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                if ([name hasPrefix:@"en"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent+=networkStatisc->ifi_obytes;
                    WiFiReceived+=networkStatisc->ifi_ibytes;
//                    NSLog(@"WiFiSent %d ==%d",WiFiSent,networkStatisc->ifi_obytes);
//                    NSLog(@"WiFiReceived %d ==%d",WiFiReceived,networkStatisc->ifi_ibytes);
                }
                
                if ([name hasPrefix:@"pdp_ip"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent+=networkStatisc->ifi_obytes;
                    WWANReceived+=networkStatisc->ifi_ibytes;
//                    NSLog(@"WWANSent %d ==%d",WWANSent,networkStatisc->ifi_obytes);
//                    NSLog(@"WWANReceived %d ==%d",WWANReceived,networkStatisc->ifi_ibytes);
                }
            }
            
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    
    long dot_WiFiSent = WiFiSent - last_WiFiSent;
    long dot_WiFiReceived = WiFiReceived - last_WiFiReceived;
    long dot_WWANSent = WWANSent - last_WWANSent;
    long dot_WWANReceived = WWANReceived - last_WWANReceived;
    
    last_WiFiSent = WiFiSent;
    last_WiFiReceived = WiFiReceived;
    last_WWANSent = WWANSent;
    last_WWANReceived = WWANReceived;
    
    return [NSArray arrayWithObjects:[NSNumber numberWithLong:dot_WiFiSent], [NSNumber numberWithLong:dot_WiFiReceived],[NSNumber numberWithLong:dot_WWANSent],[NSNumber numberWithLong:dot_WWANReceived], nil];
}

-(float) cpu_usage
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

// 获取当前设备可用内存(单位：MB）
- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

// 获取当前任务所占用的内存（单位：MB）
- (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

#endif

@end
