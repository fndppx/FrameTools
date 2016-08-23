//
//  TabBarController.h
//  FrameTools
//
//  Created by keyan on 16/8/23.
//  Copyright © 2016年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarController : UITabBarController
@property(nonatomic) float tabbarHeight;
- (void)hiddenTabbar:(BOOL)hidden Animated:(BOOL)animated;
@end
