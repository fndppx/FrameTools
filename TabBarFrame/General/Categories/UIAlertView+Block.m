//
//  UIAlertView+Block.m
//  VhallIphone
//
//  Created by dev on 16/4/27.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//

#import "UIAlertView+Block.h"
#import <objc/runtime.h>
@interface AlertViewDelegater:NSObject
@property (nonatomic,copy)void(^action)(NSInteger buttonIndex);
@end
@implementation AlertViewDelegater
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_action) {
        _action(buttonIndex);
    }
}
@end
@interface TextInputDelegater:NSObject
@property (nonatomic,copy)void(^action)(NSInteger buttonIndex,NSString*text);
@end
@implementation TextInputDelegater
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField* tf = [alertView textFieldAtIndex:0];
    if (_action) {
        _action(buttonIndex,tf.text);
    }
}
@end
static char * const delegateKey = "delegateKey";
@implementation UIAlertView (Block)
+ (void)showWithTitle:( NSString *)title message:( NSString *)message action:(void(^)(NSInteger buttonIndex))action  cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:( NSString *)otherButtonTitle
{
    AlertViewDelegater * delegate = [[AlertViewDelegater alloc]init];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
    delegate.action = action;
    objc_setAssociatedObject(alert, &delegateKey, delegate, OBJC_ASSOCIATION_RETAIN);
    [alert show];
}
+(void)showTextInputWithTitle:( NSString *)title message:( NSString *)message action:(void(^)(NSInteger buttonIndex,NSString*text))action  cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:( NSString *)otherButtonTitle
{
    TextInputDelegater * delegate = [[TextInputDelegater alloc]init];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    delegate.action = action;
    objc_setAssociatedObject(alert, &delegateKey, delegate, OBJC_ASSOCIATION_RETAIN);
    [alert show];
}
@end
