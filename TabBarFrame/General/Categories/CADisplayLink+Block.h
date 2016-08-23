//
//  CADisplayLink+Block.h
//  VhallIphone
//
//  Created by dev on 16/8/11.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CADisplayLink (Block)
+ (CADisplayLink *)displayLinkWithBlock:(void(^)(CADisplayLink* link))block;
@end
