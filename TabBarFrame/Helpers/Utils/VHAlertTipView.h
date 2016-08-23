//
//  VHAlertTipView.h
//  test
//
//  Created by vhall on 16/4/14.
//  Copyright © 2016年 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VHAlertTipView;

@protocol VHAlertViewDelegate <NSObject>
@optional
- (void)VHAlertView:(VHAlertTipView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface VHAlertTipView : UIView

@property (strong,nonatomic) id <VHAlertViewDelegate>delegate;

/*
    isAutomaticHide  YES为自动隐藏，默认1.5秒 NO为点击右侧关闭按钮后隐藏
    message          提示的信息
 */
+ (void)showVHAlertTipViewWithMessage:(NSString *)message isAutomaticHide:(BOOL)isAutomaticHide;

/*
    delayTime    自动隐藏的时间,若设定时间为<=0时,默认为点击右侧关闭按钮后隐藏
    message      提示的信息
 */
+ (void)showVHAlertTipViewWithMessage:(NSString *)message hideViewDelay:(CGFloat)delayTime;

/*
   message      提示的信息(该方法可点击或自动隐藏)
 */
+ (void)showVHAlertTipViewWithMessage:(NSString *)message;

/*
   view        自定义view
 */
+ (void)showVHAlertTipViewWithView:(UIView *)view;

/*
   隐藏VHAlertView
 */
+ (void)hideVHAlertTipView;

/*
    警告弹窗 
    title、message 类型为NSAttributedString
 */
+ (void)showWithTitle:(NSAttributedString *)title message:(NSAttributedString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle;

@end
