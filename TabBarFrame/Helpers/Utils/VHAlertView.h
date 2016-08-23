//
//  VHAlertView.h
//  VhallIphone
//
//  Created by keyan on 16/6/24.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//
typedef void(^ButtonClickBlock)(int index);//0左边，1右边
typedef void(^ButtonWithTextClickBlock)(int index,NSString * text);//0左边，1右边
#import <UIKit/UIKit.h>

@interface VHAlertView : UIView
+(void)initWithtitle:(NSString *)title leftBtn:(NSString *)leftBtn rightBtn:(NSString *)rightBtn ClickRespon:(ButtonClickBlock)clickRespon ;
+(void)initWithtitle:(NSString *)title  confirmBtn:(NSString *)confirmBtn ClickRespon:(ButtonClickBlock)clickRespon;
+(void)initInputAlertWithtitle:(NSString *)title leftBtn:(NSString *)leftBtn rightBtn:(NSString *)rightBtn ClickRespon:(ButtonWithTextClickBlock)clickRespon;
@end
@interface VHClearBufferView : UIView
@property (nonatomic,strong,readonly)UITextField * inputTextField;
@property (nonatomic,copy) void(^block)(NSInteger type);
- (VHClearBufferView *)initWithClearBufferViewFrame:(CGRect )frame title:(NSString *)title leftBtn:(NSString *)leftBtn rightBtn:(NSString *)rightBtn;
- (VHClearBufferView *)initWithClearBufferViewFrame:(CGRect )frame title:(NSString *)title confirmBtn:(NSString*)confirmBtn;
- (VHClearBufferView *)initWithInputAlertViewFrame:(CGRect )frame title:(NSString *)title leftBtn:(NSString *)leftBtn rightBtn:(NSString *)rightBtn;//带输入框的弹窗
@end
