//
//  NSTimer+Block.h
//  VhallIphone
//
//  Created by dev on 16/4/19.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Block)
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;
@end
