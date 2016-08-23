//
//  AppMacro.h
//  FrameTools
//
//  Created by keyan on 16/8/23.
//  Copyright © 2016年 ky. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h


#ifdef DEBUG // 调试状态, 打开LOG功能
#define NSLog(...) NSLog(__VA_ARGS__)
#else // 发布状态, 关闭LOG功能
#define NSLog(...)
#endif

#ifdef DEBUG // 调试状态, 打开LOG功能
#define VHLog(...) NSLog(__VA_ARGS__)
#else // 发布状态, 关闭LOG功能
#define VHLog(...)
#endif


#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;



//获取物理屏幕的尺寸
#define VHScreenHeight  ([UIScreen mainScreen].bounds.size.height)
#define VHScreenWidth   ([UIScreen mainScreen].bounds.size.width)
#define VH_SW           ((VHScreenWidth<VHScreenHeight)?VHScreenWidth:VHScreenHeight)
#define VH_SH           ((VHScreenWidth<VHScreenHeight)?VHScreenHeight:VHScreenWidth)
#define VH_RATE         (VH_SW/320.0)
#define VH_RATE_SCALE   (VH_SW/375.0)//以ip6为标准 ip5缩小 ip6p放大 zoom
#define VH_RATE_6P      ((VH_SW>375.0)?VH_SW/375.0:1.0)//只有6p会放大


#define VH_Device_OS_ver [[UIDevice currentDevice] systemVersion]
#define VH_APP_ver       [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define VH_APP_Build_ver [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]



#ifdef UI_USER_INTERFACE_IDIOM
#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#else
#define IS_IPAD() (false)
#endif

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

//放大版的iphone6等于Iphone5的分辨率《求区别办法》
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone5_frame CGRectMake(0, 0, 320, 548 - 44)
#define iPhone4_frame CGRectMake(0, 0, 320, 460 - 44)
#define ios7 ([[UIDevice currentDevice].systemVersion doubleValue] <8 ? YES : NO )


#define IS_WIDESCREEN_5                            (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < __DBL_EPSILON__)
#define IS_WIDESCREEN_6                            (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)667) < __DBL_EPSILON__)
#define IS_WIDESCREEN_6Plus                        (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)736) < __DBL_EPSILON__)
#define IS_IPHONE                                  ([[[UIDevice currentDevice] model] isEqualToString: @"iPhone"] || [[[UIDevice currentDevice] model] isEqualToString: @"iPhone Simulator"])
#define IS_IPOD                                    ([[[UIDevice currentDevice] model] isEqualToString: @"iPod touch"])
#define IS_IPHONE_5                                (IS_IPHONE && IS_WIDESCREEN_5)
#define IS_IPHONE_6                                (IS_IPHONE && IS_WIDESCREEN_6)
#define IS_IPHONE_6Plus                            (IS_IPHONE && IS_WIDESCREEN_6Plus)


//颜色
#define MakeColor(r,g,b,a) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])
#define MakeColorRGB(hex)  ([UIColor colorWithRed:((hex>>16)&0xff)/255.0 green:((hex>>8)&0xff)/255.0 blue:(hex&0xff)/255.0 alpha:1.0])
#define MakeColorRGBA(hex,a) ([UIColor colorWithRed:((hex>>16)&0xff)/255.0 green:((hex>>8)&0xff)/255.0 blue:(hex&0xff)/255.0 alpha:a])
#define MakeColorARGB(hex) ([UIColor colorWithRed:((hex>>16)&0xff)/255.0 green:((hex>>8)&0xff)/255.0 blue:(hex&0xff)/255.0 alpha:((hex>>24)&0xff)/255.0])
#endif /* AppMacro_h */
