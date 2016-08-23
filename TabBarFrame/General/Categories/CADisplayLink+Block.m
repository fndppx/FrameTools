//
//  CADisplayLink+Block.m
//  VhallIphone
//
//  Created by dev on 16/8/11.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//

#import "CADisplayLink+Block.h"
#import <objc/runtime.h>
typedef void(^CADisplayLinkBlock)(CADisplayLink* link);
const NSString *displayLineBlockKey = @"displayLineBlockKey";

@implementation CADisplayLink (Block)
+ (void)_execBlock:(CADisplayLink*)link {
    if (link.block) {
        link.block(link);
    }
}
+ (CADisplayLink *)displayLinkWithBlock:(CADisplayLinkBlock)block
{
    CADisplayLink * link = [CADisplayLink displayLinkWithTarget:self selector:@selector(_execBlock:)];
    link.block = block ;
    return link;
}
-(void)setBlock:(CADisplayLinkBlock)block
{
    CADisplayLinkBlock _block = objc_getAssociatedObject(self, &displayLineBlockKey);
    if (_block == block) {
        return;
    }
    objc_setAssociatedObject(self,  &displayLineBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(CADisplayLinkBlock)block
{
    return objc_getAssociatedObject(self, &displayLineBlockKey);
}
@end
