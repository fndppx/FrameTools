//
//  NSTimer+Block.m
//  VhallIphone
//
//  Created by dev on 16/4/19.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//

#import "NSTimer+Block.h"

@implementation NSTimer (Block)
+ (void)_execBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(_execBlock:) userInfo:[block copy] repeats:repeats];
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(_execBlock:) userInfo:[block copy] repeats:repeats];
}
@end
