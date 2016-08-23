//
//  VHSelectView.m
//  VhallIphone
//
//  Created by keyan on 16/7/11.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//
// 按钮高度
#define BUTTON_H 40
// 屏幕尺寸
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
// 颜色
#define LCColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]

#define LC_ACTION_SHEET_TITLE_FONT  [UIFont systemFontOfSize:18.0f]

#define LC_DEFAULT_ANIMATION_DURATION 0.3f

#define LC_DEFAULT_BACKGROUND_OPACITY 0.3f

#define GAPWidth 0

#import "VHSelectView.h"
@interface VHSelectView()


@property (nonatomic, strong) NSMutableArray *buttonTitles;
@property (nonatomic, strong) NSMutableArray *buttonImages;
@property (nonatomic, strong) UIView *darkView;
@property (nonatomic, strong) UIView *bottomView;
//@property (nonatomic, strong) UIWindow *backWindow;

@end
@implementation VHSelectView
#pragma mark - getter

- (NSString *)cancelText
{
    if (!_cancelText) {
        _cancelText = @"取消";
    }
    
    return _cancelText;
}

- (UIFont *)textFont
{
    
    if (!_textFont) {
        _textFont = [UIFont systemFontOfSize:14];
    }
    
    return _textFont;
}

- (UIColor *)textColor
{
    if (!_textColor) {
        _textColor = MakeColor(1, 1, 1, 1.0);
    }
    
    return _textColor;
}

- (CGFloat)animationDuration {
    if (!_animationDuration) {
        _animationDuration = LC_DEFAULT_ANIMATION_DURATION;
    }
    
    return _animationDuration;
}

- (CGFloat)backgroundOpacity {
    if (!_backgroundOpacity) {
        _backgroundOpacity = LC_DEFAULT_BACKGROUND_OPACITY;
    }
    
    return _backgroundOpacity;
}

+ (instancetype)sheetWithTitle:(NSString *)title buttonTitles:(NSArray *)buttonTitles  buttonImages:(NSArray *)buttonImages  clicked:(VHActionSheetBlock)clicked {

    return [[self alloc]initWithTitle:title buttonTitles:buttonTitles buttonImages:buttonImages  clicked:clicked] ;
}
- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)buttonTitles
                 buttonImages:(NSArray *)buttonImages
                      clicked:(VHActionSheetBlock)clicked
{
    
    if (self = [super init]) {
        
        self.title = title;
        self.buttonTitles = [[NSMutableArray alloc] initWithArray:buttonTitles];
        if (buttonImages) {
            self.buttonImages = [[NSMutableArray alloc]initWithArray:buttonImages];

        }
        self.clickedBlock = clicked;
    }
    
    return self;
}


//- (UIWindow *)backWindow {
//    
//    if (_backWindow == nil) {
//        
//        _backWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        _backWindow.windowLevel       = UIWindowLevelStatusBar;
//        _backWindow.backgroundColor   = [UIColor clearColor];
//        _backWindow.hidden = NO;
//    }
//    
//    return _backWindow;
//}


- (void)setupMainView {
    
   
    UIView *darkView = [[UIView alloc] init];
    [darkView setAlpha:0];
    [darkView setUserInteractionEnabled:NO];
    [darkView setFrame:(CGRect){0, 0, SCREEN_SIZE}];
    [darkView setBackgroundColor:LCColor(46, 49, 50)];
    [self addSubview:darkView];
    _darkView = darkView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [darkView addGestureRecognizer:tap];
    
    // 所有按钮的底部view
    UIView *bottomView = [[UIView alloc] init];
    [bottomView setBackgroundColor:MakeColorRGBA(0xf4f4f6,1.0)];
    _bottomView = bottomView;
    

    if (self.title) {
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width-GAPWidth,  39.5)];
        titleLabel.text = self.title;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.textColor = [UIColor lightGrayColor];
        [bottomView addSubview:titleLabel];
    }
    if (self.buttonTitles.count) {
        
        for (int i = 0; i < self.buttonTitles.count; i++) {
            

            UIButton *btn = [[UIButton alloc] init];
            [btn setTag:i];
            [btn setTitle:self.buttonImages!=nil?[NSString stringWithFormat:@"  %@",self.buttonTitles[i]]:[NSString stringWithFormat:@"%@",self.buttonTitles[i]] forState:UIControlStateNormal];
            [[btn titleLabel] setFont:self.textFont];
            UIColor * titleColor = self.textColor ;
          
            [btn setTitleColor:titleColor forState:UIControlStateNormal];
            
            [btn setBackgroundImage:[VHTools imageWithColor:MakeColorRGBA(0xffffff,1.0) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [btn setBackgroundImage:[VHTools imageWithColor:MakeColorRGBA(0xffffff,0.7) size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[VHTools imageWithColor:MakeColorRGBA(0xffffff,0.7) size:CGSizeMake(1, 1)] forState:UIControlStateSelected];

            if (self.buttonImages) {
                if (i>self.buttonImages.count-1) {
                    [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    
                }
                else
                {
                    [btn setImage:[UIImage imageNamed:self.buttonImages[i]] forState:UIControlStateNormal];
                    
                }
            }
            

            [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            CGFloat btnY = (39.5+0.5)* (self.title.length==0 ?i:i+1) ;
      
            [btn setFrame:CGRectMake(0, btnY, SCREEN_SIZE.width-GAPWidth,  39.5)];

            
            btn.backgroundColor = [UIColor whiteColor];
            [bottomView addSubview:btn];
        }
        
    }
    
    
    // 取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTag:self.buttonTitles.count];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [cancelBtn setTitle:self.cancelText forState:UIControlStateNormal];
    [[cancelBtn titleLabel] setFont:self.textFont];
    [cancelBtn setTitleColor:self.textColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat btnY = 40 *(self.title.length==0?self.buttonTitles.count:self.buttonTitles.count+1)   +10 ;
    [cancelBtn setFrame:CGRectMake(0, btnY, SCREEN_SIZE.width-GAPWidth, 55)];
    [bottomView addSubview:cancelBtn];
    
    CGFloat bottomH = BUTTON_H *  self.buttonTitles.count +10 + 55 +(self.title.length==0?0:40);
    [bottomView setFrame:CGRectMake(GAPWidth/2, SCREEN_SIZE.height, SCREEN_SIZE.width-GAPWidth, bottomH)];
    
    bottomView.layer.masksToBounds = YES;
    [self setFrame:(CGRect){0, 0, SCREEN_SIZE}];
}

- (void)didClickBtn:(UIButton *)btn {
    
    [self dismiss:nil];
    
    if (self.clickedBlock) {
        
        self.clickedBlock(btn.tag);
    }
}
- (void)didClickCancelBtn {
    
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [_darkView setAlpha:0];
        [_darkView setUserInteractionEnabled:NO];
        
        CGRect frame = _bottomView.frame;
        frame.origin.y += frame.size.height;
        [_bottomView setFrame:frame];
        
    } completion:^(BOOL finished) {
        
        if (self.clickedBlock) {
            
            __weak typeof(self) weakSelf = self;
            self.clickedBlock(weakSelf.buttonTitles.count);
        }
        
        [self removeFromSuperview];
        
     
    }];
}
- (void)dismiss:(UITapGestureRecognizer *)tap {
    
    [self didClickCancelBtn];
//    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        
//        [_darkView setAlpha:0];
//        [_darkView setUserInteractionEnabled:NO];
//        
//        CGRect frame = _bottomView.frame;
//        frame.origin.y += frame.size.height;
//        [_bottomView setFrame:frame];
//        
//    } completion:^(BOOL finished) {
//        
//        [self removeFromSuperview];
//     
//    }];
}

- (void)show {
    [self setupMainView];
    [self addSubview:self.bottomView];
    [[UIApplication sharedApplication].keyWindow  addSubview:self];
    
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [_darkView setAlpha:self.backgroundOpacity];
        [_darkView setUserInteractionEnabled:YES];
        
        CGRect frame = _bottomView.frame;
        frame.origin.y -= frame.size.height;
        [_bottomView setFrame:frame];
        
    } completion:nil];
}

@end
