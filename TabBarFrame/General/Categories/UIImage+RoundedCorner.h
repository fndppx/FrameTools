// UIImage+RoundedCorner.h
// Created by Trevor Harmon on 9/20/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Extends the UIImage class to support making rounded corners

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (RoundedCorner)

/**
 *  把图片弄成圆形
 *
 *  @param bounds 传入对应imageview的bounds
 *
 *  @return 
 */
-(UIImage *)clipImage:(CGRect)bounds;
/**
 *  这个是给多大得半圆
 *
 *  @param cornerSize <#cornerSize description#>
 *  @param borderSize <#borderSize description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;

- (void)addRoundedRectToPath:(CGRect)rect context:(CGContextRef)context ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight;
@end
