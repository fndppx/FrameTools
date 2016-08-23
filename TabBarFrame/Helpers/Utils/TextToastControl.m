//
//  TextToastControl.m
//  StarsShow
//
//  Created by keyan on 16/5/25.
//  Copyright © 2016年 developer_k. All rights reserved.
//

#import "TextToastControl.h"
#define TextMaxWidth  190
#define TextMinWidth  90
#define TextAlertFieldHeightMargin    10
#define TextAlertFieldWidthMargin     10
#define TextAlertFieldFontSize      16
#define WidthBetweenContentTextAndTextView  10

#define SYSTEM_VERSION [[[UIDevice currentDevice]systemVersion]floatValue]

#define TagTextToastView    38192712

@implementation TextToastControl

+(void) showTextToastWithText:(NSString *) text inView:(UIView *) view displayDuration:(NSInteger) displayDuration {
    if (!text||[text isKindOfClass:[NSNull class]]){
        return;
    }
    
    UIView *textAlertView = [view viewWithTag:TagTextToastView];
    if (textAlertView){
        [textAlertView removeFromSuperview];
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideTextAlert:) object:self];
    
    textAlertView = [[UIView alloc] init];
    textAlertView.backgroundColor = [UIColor clearColor];
    textAlertView.opaque = YES;
    textAlertView.tag = TagTextToastView;
    
    UIView *textAlertBgView = [[UIView alloc] init];
    textAlertBgView.backgroundColor = [UIColor blackColor];
    textAlertBgView.alpha = 0.5;
    
    UIFont *font = [UIFont boldSystemFontOfSize:TextAlertFieldFontSize];
    
    int textWidth = [text sizeWithFont:font].width;
    
    int lineCount = textWidth / TextMaxWidth + ((0 == (textWidth % TextMaxWidth)) ? 0 : 1);
    
    float contentTextWidth = (1 == lineCount) ?
    ((textWidth > TextMinWidth) ?
     textWidth : TextMinWidth) : TextMaxWidth;
    
    UITextView *textAlertContentField = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, contentTextWidth + WidthBetweenContentTextAndTextView, 0)];
    textAlertContentField.backgroundColor = [UIColor clearColor];
    textAlertContentField.textColor = [UIColor whiteColor];
    textAlertContentField.opaque = YES;
    textAlertContentField.userInteractionEnabled = NO;
    textAlertContentField.text = text;
    [textAlertContentField sizeToFit];
    textAlertContentField.textAlignment = NSTextAlignmentCenter;
    textAlertContentField.font = font;
    textAlertContentField.editable=NO;
    [textAlertView addSubview:textAlertBgView];
    [textAlertView addSubview:textAlertContentField];
    

    
    float contentTextHeight;
    float systemVersion = [[[UIDevice currentDevice]systemVersion]floatValue];
    if (systemVersion >= 7.0) {
        contentTextHeight = [[NSString stringWithFormat:@"%@\n ",textAlertContentField.text]
                             boundingRectWithSize:CGSizeMake(contentTextWidth, CGFLOAT_MAX)
                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                             attributes:[NSDictionary dictionaryWithObjectsAndKeys:textAlertContentField.font,NSFontAttributeName, nil] context:nil].size.height;
    }else {
        contentTextHeight = textAlertContentField.contentSize.height;
    }
    
    textAlertContentField.frame = CGRectMake(TextAlertFieldWidthMargin, TextAlertFieldHeightMargin, contentTextWidth + WidthBetweenContentTextAndTextView, contentTextHeight);
    
    CGRect textAlertContentFieldFrame = textAlertContentField.frame;
    
    textAlertView.frame = CGRectMake((view.frame.size.width - (textAlertContentFieldFrame.size.width + TextAlertFieldWidthMargin * 2)) / 2, (view.frame.size.height - (textAlertContentFieldFrame.size.height + TextAlertFieldHeightMargin * 2)) / 2, textAlertContentFieldFrame.size.width + TextAlertFieldWidthMargin * 2, textAlertContentFieldFrame.size.height + TextAlertFieldHeightMargin * 2);
    
    textAlertBgView.frame = textAlertView.bounds;
    
    textAlertView.layer.cornerRadius = 10;
    textAlertView.layer.masksToBounds = YES;
    [view addSubview:textAlertView];
    
    //animation
    textAlertView.alpha = 0;
    [UIView animateWithDuration:AnimationInterval animations:^{
        textAlertView.alpha = 1;
    } completion:nil];
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, displayDuration * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(){
        [self hideTextAlert:view];
    });
}

+ (void) hideTextAlert:(UIView *) holderView {
    UIView *textAlertView = [holderView viewWithTag:TagTextToastView];
    if (!textAlertView){
        return;
    }
    
    //animation
    textAlertView.alpha = 1;
    [UIView animateWithDuration:AnimationInterval animations:^{
        textAlertView.alpha = 0;
    } completion:^(BOOL finished) {
        [textAlertView removeFromSuperview];
    }];
}
@end
