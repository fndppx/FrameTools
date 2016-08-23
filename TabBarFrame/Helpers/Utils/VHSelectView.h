//
//  VHSelectView.h
//  VhallIphone
//
//  Created by keyan on 16/7/11.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^VHActionSheetBlock)(NSInteger buttonIndex);
@interface VHSelectView : UIView
@property (nonatomic, copy) VHActionSheetBlock clickedBlock;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSString *cancelText;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat backgroundOpacity;

+ (instancetype)sheetWithTitle:(NSString *)title buttonTitles:(NSArray *)buttonTitles  buttonImages:(NSArray *)buttonImages  clicked:(VHActionSheetBlock)clicked;
- (void)show;
- (void)dismiss:(UITapGestureRecognizer *)tap ;
@end
