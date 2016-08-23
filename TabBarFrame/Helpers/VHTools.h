//
//  VHTools.h
//  vhallIphone
//
//  Created by yangyang on 14-7-23.
//  Copyright (c) 2014年 zhangxingming. All rights reserved.
//

#import <Foundation/Foundation.h>
//@class VHVideoInfo;
//@class VHVideoInfoItem;
@interface VHTools : NSObject
+ (BOOL) IsEnableWIFI ;
+ (BOOL) IsEnable3G ;
+ (NSString*) MD5:(NSString *)str;
+ (NSString*) MD5WithNet:(NSString *)netOperate;
+ (NSString*) MD5WithParam:(NSDictionary *)Param;
+ (NSString*) MD5WithUrl:(NSString*)url Param:(NSDictionary *)param;
+ (NSString*) atomSting:(NSDictionary *)param;
+ (NSString*) dicToJsonStr:(NSDictionary*)dic;
+ (NSString*) emptyForNil:(NSString *)str;
+ (NSString*) delSpaceCharacter:(NSString *)str;
+ (void) testValue:(id)value key:(NSString*)key op:(NSString*)op;
//yyyy-MM-dd HH:mm:ss
+ (NSDate *)dateFromString:(NSString *)dateString Formatter:(NSString*)formatter;
//MM-dd HH:mm
+ (NSString *)stringFromDate:(NSDate *)date Formatter:(NSString*)formatter;
+(BOOL)isFloat:(NSString *)floatstr;
+(BOOL)isValidateEmail:(NSString *)email;
//身份证号
+ (BOOL)isValidateIdentityCard: (NSString *)identityCard;
+ (BOOL)isPhoneNumber:(NSString *)mobileNum;
+ (BOOL)isIntNumber:(NSString *)number;
+ (BOOL)isCheckCode:(NSString *)checkCode;
+ (NSString*)isWebinar:(NSString *)url;
//纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//图像尺寸修改
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage size:(CGSize)size;//等比缩小 边最大 为size
+ (UIImage *)imageByScalingToMinSize:(UIImage *)sourceImage size:(CGSize)size;//等比放大 边最小 为size
+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize;
//图片旋转
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;
#pragma mark camera utility
+ (BOOL) isCameraAvailable;
+ (BOOL) isRearCameraAvailable;
+ (BOOL) isFrontCameraAvailable;
+ (BOOL) doesCameraSupportTakingPhotos;
+ (BOOL) isPhotoLibraryAvailable;
+ (BOOL) canUserPickVideosFromPhotoLibrary;
+ (BOOL) canUserPickPhotosFromPhotoLibrary;
+ (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceTyp;

//进行NSUTF8String encoding 进行编码
//stringByReplacingPercentEscapesUsingEncoding: 解码
+ (NSString*)urlEncodeUTF8String:(NSString *)string;
+ (NSString*)urlDecodeChineseString:(NSString *)string;
//检查状态栏是否为正常：正常高度为20
+ (BOOL)statusBarHeighrIsNormal;
//圆角值跟随屏幕适配变化
+ (CGFloat)cornerRadiusAutoLay:(CGFloat)number;

//字号变化
+ (CGFloat)fontChange:(CGFloat)font;

//数字转 k w 等
+ (NSString*)numToString:(NSInteger)num;
//数字转 千 万 亿
+ (NSString*)numToStringWithChinese:(NSInteger)num;
//只显示K
+(NSString*)numToStringWithK:(NSInteger)num;
//只显示w
+(NSString*)numToStringWithW:(NSInteger)num;


+(NSString*)numShowAll:(NSInteger)num;
//判断是否超过2周时间，登录成功后提醒打开通讯录授权
+ (BOOL)timeOverDays;


+(NSString*)getAppVersion;

//记录首次拒绝通讯录授权时间
+ (void)recoreAdressBookAuthorRejectTime;

//字符串中是否包含表情符号
+ (BOOL)isHaveEmoji:(NSString *)text;
//去掉字符串中的表情符号
+ (NSString *)disableEmoji:(NSString *)text;

//计算字符串所占区域大小
+(CGSize)calStrSize:(NSString*)str width:(CGFloat)width font:(UIFont*)font;//CGSizeMake(width, MAXFLOAT)
+(CGSize)calStrSize:(NSString*)str font:(UIFont*)font;//CGSizeMake(MAXFLOAT, MAXFLOAT)

//敏感词
+(BOOL)SensitiveWordsListWithWord:(NSString *)word;

//检测相机 麦克风、图片库授权状态（提示-跳转系统设置）
+ (BOOL)checkMediaDevice:(NSString * const)AVMediaTypeStr;
//检测相机 麦克风授权(未确定或未提示)状态
+ (BOOL)checkMediaAuthorizationStatus:(NSString *)AVMediaTypeStr;

//判断空字符串
+ (BOOL)isBlankString:(NSString *)string;

//判断中英混合的的字符串长度
+ (int)convertToInt:(NSString*)strtemp;

+ (BOOL)isHeadsetPluggedIn;

//图像数据转成base64
+ (NSString *)imageChangeToBase64:(UIImage *)image;

//去掉字符串首尾空格
+ (NSString *)deleteWhiteSpaceWithString:(NSString *)string;

//字符串是否超过规定字节数
+ (BOOL)isLealString:(NSString *)string limitStringSizeOf:(int)limitNumber;
//View边框颜色
+ (void)setUserIconBorderWithView:(UIView*)view;
//Button边框颜色
+ (void)setUserIconBorderWithButton:(UIButton*)button;


//比较提交审核日期是否大于7天

+(BOOL)compareCheckFlagDate;
@end
