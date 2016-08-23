//
//  TextToastControl.h
//  StarsShow
//
//  Created by keyan on 16/5/25.
//  Copyright © 2016年 developer_k. All rights reserved.
//

#import <Foundation/Foundation.h>


#define AnimationInterval   0.5

@interface TextToastControl : NSObject

+(void) showTextToastWithText:(NSString *) text inView:(UIView *) view displayDuration:(NSInteger) displayDuration;

@end

