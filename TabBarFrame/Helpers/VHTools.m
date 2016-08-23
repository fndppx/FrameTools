//
//  VHTools.m
//  vhallIphone
//
//  Created by yangyang on 14-7-23.
//  Copyright (c) 2014年 zhangxingming. All rights reserved.
//

#import "VHTools.h"
#import "AFNetworkReachabilityManager.h"
#import <CommonCrypto/CommonDigest.h>
#import <MobileCoreServices/MobileCoreServices.h>
#include "GTMBase64.h"
#import "VHBTFiter.h"

#import "AVFoundation/AVCaptureDevice.h"
#import "AVFoundation/AVMediaFormat.h"
#import <AssetsLibrary/AssetsLibrary.h>

//#import "VHBTFiter.h"

#import <AVFoundation/AVFoundation.h>

@implementation VHTools


// 是否wifi
+ (BOOL) IsEnableWIFI {
    return [AFNetworkReachabilityManager sharedManager].isReachableViaWiFi;
   
}

// 是否3G
+ (BOOL) IsEnable3G {

  return [AFNetworkReachabilityManager sharedManager].isReachableViaWWAN;
  
}

+ (NSString*)MD5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int) strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
+ (NSString*) MD5WithNet:(NSString *)netOperate
{
    NSString* sign = [netOperate stringByReplacingOccurrencesOfString:@"/" withString:@""];
    sign = [sign stringByAppendingString:@"tAF^aVaz@l"];
    return [VHTools MD5:sign];
}

+ (NSString*) MD5WithParam:(NSDictionary *)param
{
    if(param == nil)return @"";
    
    NSArray *myKeys = [param allKeys];
    NSArray *sortedKeys = [myKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    NSMutableString *sign = [NSMutableString stringWithString:@""];
    for(NSString* key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:[NSString stringWithFormat:@"%@",[param objectForKey:key]]];
    }
    [sign appendString:@""];

    return [VHTools MD5:sign];
}

+ (NSString*) MD5WithUrl:(NSString*)url Param:(NSDictionary *)param
{
    if(url == nil)return @"";

    NSArray *myKeys = [param allKeys];
    NSArray *sortedKeys = [myKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    NSMutableString *sign = [NSMutableString stringWithString:url];
    for(NSString* key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:[NSString stringWithFormat:@"%@",[param objectForKey:key]]];
    }
    [sign appendString:@""];
    
    return [VHTools MD5:sign];
}


+ (NSString*) atomSting:(NSDictionary *)param
{
    if(param == nil)return @"";
    
    NSArray *myKeys = [param allKeys];
    NSMutableString *atom = [NSMutableString string];
    for(NSString* key in myKeys) {
        [atom appendString:[NSString stringWithFormat:@"%@=%@&",key,[param objectForKey:key]]];
    }
    
    return [GTMBase64 stringByEncodingData:[atom dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString*) dicToJsonStr:(NSDictionary*)dic
{
    NSString *jsonString = nil;
    if([NSJSONSerialization isValidJSONObject:dic]){
//        VHLog(@"it is a JSONObject!");
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        if([jsonData length] > 0 && error == nil) {
            jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            //        VHLog(@"data:%@",jsonString);
        }
    }
    return jsonString;
}

+(void)testValue:(id)value key:(NSString*)key op:(NSString*)op
{
    if ([value isKindOfClass:[NSDictionary class]]){
        NSDictionary* dic = value;
        NSArray *allKeys = dic.allKeys;
        for (NSString *key in allKeys) {
            [VHTools testValue:[dic objectForKey:key] key:key op:op];
        }
    }else if ([value isKindOfClass:[NSArray class]]){
        NSArray* arr = value;
        if(arr.count>0)
            [VHTools testValue:arr[0] key:key op:op];
    } else if ([value isKindOfClass:[NSSet class]]){
        
    } else {
        if(![value isKindOfClass:[NSString class]])
            VHLog(@"%@=%@-------------%@",key,value,op);
    }
    
}

+(NSString*)getAppVersion
{
  
    NSString *version=[VHTools emptyForNil:VH_APP_ver];
    NSArray *array = [version componentsSeparatedByString:@"."];
    
    //检查版本
    NSString *ver =array[0];
    if(array.count>=2)
        ver = [ver stringByAppendingString:[NSString stringWithFormat:@"%02d",[array[1] intValue]]];
    else
        ver = [ver stringByAppendingString:@"00"];
    if(array.count>=3)
        ver = [ver stringByAppendingString:[NSString stringWithFormat:@"%02d",[array[2] intValue]]];
    else
        ver = [ver stringByAppendingString:@"00"];
    if(array.count>=4)
        ver = [ver stringByAppendingString:[NSString stringWithFormat:@"%02d",[array[3] intValue]]];
    else
        ver = [ver stringByAppendingString:@"00"];
    return ver;
//        NSMutableString *first=array[0];
//        NSMutableString *second=array[1];
//        if (second.length==2)
//        {
//            
//        }else
//        {
//            second=[NSMutableString stringWithFormat:@"0%@",second];
//        }
//        
//        
//        NSMutableString *third=array[2];
//        if (third.length ==2)
//        {
//            
//        }else
//        {
//            third=[NSMutableString stringWithFormat:@"0%@",third];
//        }
//        
//        NSMutableString *fourth=nil;
//        if (array.count==4)
//        {
//            fourth=array[3];
//            if (fourth.length==2)
//            {
//                
//            }else
//            {
//                fourth=[NSMutableString stringWithFormat:@"0%@",fourth];
//            }
//        }else
//        {
//            fourth=@"00";
//        }
//        
//        NSString *ver=[NSString stringWithFormat:@"%@%@%@%@",first,second,third,fourth];
//        return ver;
//    
}

+ (NSString *)emptyForNil:(id)str
{
    NSString* ret = @"";
    if(![str isKindOfClass:[NSNull class]] && str)
        ret = [NSString stringWithFormat:@"%@",str];
    return ret;
}

+ (NSString *)delSpaceCharacter:(NSString *)str
{
    if(str == nil)return nil;
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

//去掉首尾空格

//yyyy-MM-dd HH:mm:ss
+ (NSDate *)dateFromString:(NSString *)dateString Formatter:(NSString*)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if(formatter == nil)
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    else
        [dateFormatter setDateFormat:formatter];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}
//MM-dd HH:mm
+ (NSString *)stringFromDate:(NSDate *)date Formatter:(NSString*)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if(formatter == nil)
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    else
        [dateFormatter setDateFormat:formatter];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+(BOOL)isFloat:(NSString *)floatstr {
    NSString *emailRegex = @"^(([0-9]{1,10}+)|([0-9]+\\.[0-9]{1,2})|([0-9]+\\.)|(\\.)|(\\.[0-9]{1,2}))$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:floatstr];
}

+ (BOOL)isIntNumber:(NSString *)number
{
    NSString * pattern = @"^[0-9]";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
}
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isValidateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
+ (BOOL)isPhoneNumber:(NSString *)mobileNum
{

    
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:#对手机号段的判断（13X、14X、15X、17X、18X、）
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


+ (BOOL)isCheckCode:(NSString *)checkCode
{
    NSString * MOBILE = @"\\d{6}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:checkCode];
}

+ (NSString*)isWebinar:(NSString *)url
{
    NSRange range = [url rangeOfString:@"e.vhall.com/"];
    if(range.location != NSNotFound)
    {
        NSString * str = [url substringFromIndex:range.location+range.length];
        range = [str rangeOfString:@"/"];
        if(range.location != NSNotFound && str.length == range.location+1)
        {
            str = [str substringToIndex:range.location];
        }
        NSString * MOBILE = @"\\d{9}$";
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        if([regextestmobile evaluateWithObject:str])
            return str;
    }
    return nil;
//    NSString * MOBILE = @"(?:e.vhall.com/)(\\d+)";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    if( [regextestmobile evaluateWithObject:url])
//    {
//        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"e.vhall.com/([\\d])/$1" options:NSRegularExpressionCaseInsensitive error:nil];
//        NSString *modifiedString = [regex stringByReplacingMatchesInString:url
//                                                                   options:0
//                                                                     range:NSMakeRange(0, [url length])
//                                                              withTemplate:@""];
//        return modifiedString;
//    }
//    return nil;
}


+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
   return scaledImage;
}


#pragma mark image scale utility
+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage size:(CGSize)size//等比缩小 边最大 为size
{
    if (sourceImage.size.width <= size.width && sourceImage.size.height <= size.height)
        return sourceImage;
    
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width/sourceImage.size.height > size.width/size.height )
    {
        btWidth  = size.width;
        btHeight = sourceImage.size.height * (size.width / sourceImage.size.width);
    } else
    {
        btWidth = sourceImage.size.width * (size.height / sourceImage.size.height);
        btHeight = size.height;
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [VHTools imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

+ (UIImage *)imageByScalingToMinSize:(UIImage *)sourceImage size:(CGSize)size//等比放大 边最小 为size
{
    if (sourceImage.size.width >= size.width && sourceImage.size.height >= size.height)
        return sourceImage;
    
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width/sourceImage.size.height > size.width/size.height )
    {
        btWidth = sourceImage.size.width * (size.height / sourceImage.size.height);
        btHeight = size.height;
    } else
    {
        btWidth  = size.width;
        btHeight = sourceImage.size.height * (size.width / sourceImage.size.width);
    }
    if(btWidth> size.width*3 || btHeight > size.height*3)
        return sourceImage;
    
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [VHTools imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark camera utility
+ (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

+ (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

+ (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
+ (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
+ (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

//图片旋转
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

//进行NSUTF8String encoding 进行编码
//stringByReplacingPercentEscapesUsingEncoding: 解码
//+ (NSString*)urlEncodeUTF8String:(NSString *)string
//{
//    
//    return [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//}
//+ (NSString*)urlDecodeChineseString:(NSString *)string{
//    
//    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//}

+ (NSString *)urlEncodeUTF8String: (NSString *) input
{
    
    // Encode all the reserved characters, per RFC 3986
    
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    
//    NSString *outputStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)input,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
     NSString *outputStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)input,NULL,NULL,kCFStringEncodingUTF8));
    
    return outputStr;
    
}


+ (NSString *)urlDecodeChineseString: (NSString *) input
{
    
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    
    [outputStr replaceOccurrencesOfString:@"+"
     
                               withString:@" "
     
                                  options:NSLiteralSearch
     
                                    range:NSMakeRange(0, [outputStr length])];  
    
    
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  
    
}


//圆角值跟随屏幕适配变化
+ (CGFloat)cornerRadiusAutoLay:(CGFloat)number
{
    CGFloat autoSizeScaleY;
    if(VHScreenHeight > 480){
        autoSizeScaleY = VHScreenHeight/568;
    }else{
        autoSizeScaleY = 1.0;
    }
    return number * autoSizeScaleY;
}

//字号变化
+ (CGFloat)fontChange:(CGFloat)font
{
    if (VH_SH > 568) {
        return font + 1.0;
    }
    else return font;
}



+(NSString*)numShowAll:(NSInteger)num
{
    NSString *ret;
  
        ret = [NSString stringWithFormat:@"%ld",(long)num];
    return ret;
}

//数字转 k w 等
+ (NSString*)numToString:(NSInteger)num
{
    NSString* ret;
//    if(num>=1000000)
//    {
//        ret = [NSString stringWithFormat:@"%0.1fm",num/1000000.0];
//    }
//    else
    if(num>=10000)
    {
        ret = [NSString stringWithFormat:@"%0.1fw",num/10000.0];
    }
//    else if(num>=1000)
//    {
//        ret = [NSString stringWithFormat:@"%0.1fk",num/1000.0];
//    }
    else
        ret = [NSString stringWithFormat:@"%ld",(long)num];
    return ret;
}

//只显示K
+(NSString*)numToStringWithK:(NSInteger)num{
    NSString *ret;
    if (num>=1000) {
        ret = [NSString stringWithFormat:@"%0.1fk",num/1000.0];
    }else{
        ret = [NSString stringWithFormat:@"%ld",(long)num];
    }
    return ret;
}


//只显示w
+(NSString*)numToStringWithW:(NSInteger)num{
    NSString *ret;
    if (num>=10000) {
        ret = [NSString stringWithFormat:@"%0.1fw",num/10000.0];
    }else{
        ret = [NSString stringWithFormat:@"%ld",(long)num];
    }
    return ret;
}

+ (NSString*)numToStringWithChinese:(NSInteger)num{
    //*****************************转汉字
//    NSString* ret;
//    if(num>=100000000)
//    {
//        ret = [NSString stringWithFormat:@"%0.1f亿",num/100000000.0];
//    }
//    else if(num>=10000)
//    {
//        ret = [NSString stringWithFormat:@"%0.1f万",num/10000.0];
//    }
//    else if(num>=1000)
//    {
//         ret = [NSString stringWithFormat:@"%ld",(long)num];
//    }
//    else
//        ret = [NSString stringWithFormat:@"%ld",(long)num];
//    return ret;
    //*******************************************
    
    
    
    NSString  *ret;
    if (num>=10000) {
        ret=[NSString stringWithFormat:@"%0.1fw",num/10000.0];
    }else if (num>=1000){
        ret = [NSString stringWithFormat:@"%0.1fk",num/1000.0];
    }else{
        ret=[NSString stringWithFormat:@"%ld",(long)num];
    }
    
    return ret;

    
    
}





//判断是否超过2周时间，登录成功后提醒打开通讯录授权(授权关闭情况下)
+ (BOOL)timeOverDays
{
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * start = [[NSUserDefaults standardUserDefaults] objectForKey:@""];
    NSString *end = [DateFormatter stringFromDate:[NSDate date]];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [f dateFromString:start];
    NSDate *endDate = [f dateFromString:end];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    
    if ((long)[components day] >11){
        [[NSUserDefaults standardUserDefaults] setValue:end forKey:@""];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
      return YES;
    }
     else return  NO;
}


//记录首次拒绝通讯录授权时间
+ (void)recoreAdressBookAuthorRejectTime
{
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    BOOL completed = [[NSUserDefaults standardUserDefaults] boolForKey:@""];
    if (!completed) {
        NSString * time = [DateFormatter stringFromDate:[NSDate date]];
        [[NSUserDefaults standardUserDefaults] setValue:time  forKey:@""];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@""];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


+ (BOOL)isHaveEmoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return ![modifiedString isEqualToString:text];
}

+ (NSString *)disableEmoji:(NSString *)text
{
    if(text == nil) return nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
//    @"小明 ‍韓國米思納美品牌創始人"@"黄经纬 ‍太陽熊搬家™️"
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"‍"];
    modifiedString = [[modifiedString componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
    return modifiedString;
}

//CGSizeMake(width, MAXFLOAT)
+(CGSize)calStrSize:(NSString*)str width:(CGFloat)width font:(UIFont*)font
{
    if(str == nil || font == nil)
        return CGSizeZero;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [str boundingRectWithSize: CGSizeMake(width, MAXFLOAT)
                          options: (NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine)
                       attributes: attributes
                          context: nil].size;
    return size;
}
//CGSizeMake(MAXFLOAT, MAXFLOAT)
+(CGSize)calStrSize:(NSString*)str font:(UIFont*)font
{
    if(str == nil || font == nil)
        return CGSizeZero;

    return [VHTools calStrSize:str width:MAXFLOAT font:font];
    
//    CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:font}];
//    return size;
}

//检测相机 麦克风、图片库授权状态（提示-跳转系统设置）
+ (BOOL)checkMediaDevice:(NSString * const)AVMediaTypeStr
{
    NSString * message ;
    NSInteger  alertViewTag = 0;
    if ([AVMediaTypeStr isEqualToString: @"ALAssetsLibrary"]) {//图片库
        message = [VH_Device_OS_ver floatValue] <8.0? @"请在设备的\"设置-隐私-照片\"中允许访问。":@"打开照片库，无限精彩";
//        alertViewTag = VHEVENT_TAG_SET_PHOTOLIBRIARY_AUTH;
        ALAuthorizationStatus alAuthorizationStatus = [ALAssetsLibrary authorizationStatus];
        if (alAuthorizationStatus == ALAuthorizationStatusDenied){}
        else return YES;
    }
    else {
        if ([AVMediaTypeStr isEqualToString:AVMediaTypeVideo]){
            message = [VH_Device_OS_ver floatValue] <8.0? @"请在设备的\"设置-隐私-相机\"中允许访问。":@"打开相机，无限精彩";
//            alertViewTag = VHEVENT_TAG_SET_CAMERA_AUTH;
        }
        else{
            message = [VH_Device_OS_ver floatValue] <8.0? @"请在设备的\"设置-隐私-麦克风\"中允许访问。":@"打开麦克风，无限精彩";
//            alertViewTag = VHEVENT_TAG_SET_MIRCO_AUTH;
        }
        AVAuthorizationStatus avAuthorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeStr];
        if(avAuthorizationStatus == AVAuthorizationStatusDenied){}
        else  return YES;
    }
    
    UIAlertView * view = [[UIAlertView alloc]initWithTitle:nil
                                                   message:message
                                                  delegate: [UIApplication sharedApplication].delegate
                                         cancelButtonTitle:[VH_Device_OS_ver floatValue] <8.0? nil :@""
                                         otherButtonTitles:[VH_Device_OS_ver floatValue] <8.0? @"知道了":@"去设置", nil];
    view.tag = alertViewTag;
    [view show];
    return NO;
}

//检测相机 麦克风授权(未确定或未提示)状态
+ (BOOL)checkMediaAuthorizationStatus:(NSString *)AVMediaTypeStr
{
    if ([AVMediaTypeStr isEqualToString: @"ALAssetsLibrary"]) {//图片库
        ALAuthorizationStatus alAuthorizationStatus = [ALAssetsLibrary authorizationStatus];
        if ((alAuthorizationStatus == ALAuthorizationStatusRestricted) || (alAuthorizationStatus == ALAuthorizationStatusNotDetermined)) return NO;
        else  return YES;
    }
    else {
        AVAuthorizationStatus avAuthorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeStr];
        if((avAuthorizationStatus == AVAuthorizationStatusRestricted) || (avAuthorizationStatus == AVAuthorizationStatusNotDetermined)) return NO;
        else return YES;
    }
}

+(BOOL)SensitiveWordsListWithWord:(NSString *)word
{
    NSString*fileStr = [[VHBTFiter shareBTFiter] filterWithString:word];
    if ([fileStr isEqualToString:word]) {
        return NO;
    }
    return YES;
}

//检查状态栏是否为正常：正常高度为20
+ (BOOL)statusBarHeighrIsNormal
{
    CGRect statusBarRect = [[UIApplication sharedApplication] statusBarFrame];
    return (fabs( statusBarRect.size.height - 20)<0.01);
}

//判断空字符串
+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL || [string isEqualToString:@" "] ) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

//判断中英混合的的字符串长度
+ (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }

    }
    return strlength;
}

//判断字符串是否在规定的字节范围内
+ (BOOL)isOverLengthString:(NSString *)string limitLength:(int)length
{
    int stringLength = [VHTools convertToInt:string];
    if (stringLength <= length)
        return NO;
    else
        return YES;
}

//是否耳机插入
+ (BOOL)isHeadsetPluggedIn
{
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    return NO;
}

//图像数据转成base64
+ (NSString *)imageChangeToBase64:(UIImage *)image
{
    NSData *dataObj = UIImageJPEGRepresentation(image, 0.5);
    if (dataObj == nil)
        dataObj=UIImagePNGRepresentation(image);
    return [GTMBase64 stringByEncodingData:dataObj];
}

//去掉字符串首尾空格
+ (NSString *)deleteWhiteSpaceWithString:(NSString *)string
{
    if ([VHTools isBlankString:string])
        return nil;
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

//字符串是否超过规定字节数
+ (BOOL)isLealString:(NSString *)string limitStringSizeOf:(int)limitNumber
{
    int  currentStringSizeOf = [VHTools convertToInt:string];
//    NSLog(@"int = %d  str = %@",currentStringSizeOf,string);
    if (currentStringSizeOf <= limitNumber)
        return YES;
    else
        return NO;
}

//View边框颜色
+ (void)setUserIconBorderWithView:(UIView *)view{
    
    
    view.layer.cornerRadius = view.size.height/2 ;
    view.layer.borderWidth = 1;
//    view.layer.borderColor = [VHThemeManager sharedManager].userIconColor.CGColor;
    view.layer.masksToBounds = YES;
}

//Button边框颜色
+ (void)setUserIconBorderWithButton:(UIButton*)button{
    
    
    button.layer.cornerRadius = button.size.height/2 ;
    button.layer.borderWidth = 1;
//    button.layer.borderColor = [VHThemeManager sharedManager].userIconColor.CGColor;
    button.layer.masksToBounds = YES;
}





+(BOOL)compareCheckFlagDate
{
    
   
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
  
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    [df setTimeZone:GTMzone];

    NSDate *from = [[NSDate alloc] init];
    from = [df dateFromString:@""];
    
    NSDate *current=[[NSDate alloc] init];
    NSString *currentStr= [df stringFromDate:current];
    NSDate  *currentData=[df dateFromString:currentStr];
    
    NSCalendar*calendar = [NSCalendar currentCalendar];
    
    //计算两个日期的差值
    
    NSDateComponents*cmps= [calendar components:NSCalendarUnitDay fromDate:from toDate:currentData options:NSCalendarMatchStrictly];
    if (cmps.day <7) {
        return YES;
    }else
    {
        return NO;
    }
    
}

@end





//判断是否包含表情符号
//    __block BOOL returnValue = NO;
//
//    [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
//                               options:NSStringEnumerationByComposedCharacterSequences
//                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
//                                const unichar hs = [substring characterAtIndex:0];
//                                if (0xd800 <= hs && hs <= 0xdbff) {
//                                    if (substring.length > 1) {
//                                        const unichar ls = [substring characterAtIndex:1];
//                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
//                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
//                                            returnValue = YES;
//                                        }
//                                    }
//                                } else if (substring.length > 1) {
//                                    const unichar ls = [substring characterAtIndex:1];
//                                    if (ls == 0x20e3) {
//                                        returnValue = YES;
//                                    }
//                                } else {
//                                    if (0x2100 <= hs && hs <= 0x27ff) {
//                                        returnValue = YES;
//                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
//                                        returnValue = YES;
//                                    } else if (0x2934 <= hs && hs <= 0x2935) {
//                                        returnValue = YES;
//                                    } else if (0x3297 <= hs && hs <= 0x3299) {
//                                        returnValue = YES;
//                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
//                                        returnValue = YES;
//                                    }
//                                }
//                            }];
//
//    return returnValue;


