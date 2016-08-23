//
//  UIControl+ForbidRepeat.h
//  VhallIphone
//
//  Created by keyan on 16/8/19.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#define defaultInterval .5  //默认时间间隔

@interface UIButton (ForbidRepeat)
/**设置点击时间间隔*/
@property (nonatomic, assign) NSTimeInterval timeInterval;
/**
 *  用于设置单个按钮不需要被hook
 */
@property (nonatomic, assign) BOOL isIgnore;
@end
