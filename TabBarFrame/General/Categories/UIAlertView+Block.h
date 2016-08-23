//
//  UIAlertView+Block.h
//  VhallIphone
//
//  Created by dev on 16/4/27.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Block)
+(void)showTextInputWithTitle:( NSString *)title message:( NSString *)message action:(void(^)(NSInteger buttonIndex,NSString*text))action  cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:( NSString *)otherButtonTitle;
+ (void)showWithTitle:( NSString *)title message:( NSString *)message action:(void(^)(NSInteger buttonIndex))action  cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:( NSString *)otherButtonTitle;
@end
