//
//  VHAlertView.m
//  VhallIphone
//
//  Created by keyan on 16/6/24.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//

#define KeyboardHeight 252
#import "VHAlertView.h"
//#import "VHClearBufferView.h"
@interface VHAlertView()

@property (nonatomic,strong)NSString * message;
@property (nonatomic,strong)NSString * leftTitle;
@property (nonatomic,strong)NSString * rightTitle;

@property (nonatomic,strong)NSString * confirmBtn;


@property (nonatomic,copy)ButtonClickBlock buttonClickBlock;
@property (nonatomic,copy)ButtonWithTextClickBlock buttonWithTextClickBlock;
@end
@implementation VHAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(void)initWithtitle:(NSString *)title  confirmBtn:(NSString *)confirmBtn ClickRespon:(ButtonClickBlock)clickRespon
{
    VHAlertView * alertView = [[VHAlertView alloc] init];
    alertView.buttonClickBlock = clickRespon;
    
    [alertView initWithTitle:title confirmBtn:confirmBtn];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:alertView];

}

+(void)initWithtitle:(NSString *)title leftBtn:(NSString *)leftBtn rightBtn:(NSString *)rightBtn ClickRespon:(ButtonClickBlock)clickRespon
{
    
    VHAlertView * alertView = [[VHAlertView alloc] init];
    alertView.buttonClickBlock = clickRespon;

    [alertView initWithTitle:title leftBtnTitle:leftBtn rightBtnTitle:rightBtn];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:alertView];
}

+(void)initInputAlertWithtitle:(NSString *)title leftBtn:(NSString *)leftBtn rightBtn:(NSString *)rightBtn ClickRespon:(ButtonWithTextClickBlock)clickRespon
{
    
    VHAlertView * alertView = [[VHAlertView alloc] init];
    alertView.buttonWithTextClickBlock = clickRespon;
    
    [alertView initInputAlertWithTitle:title leftBtnTitle:leftBtn rightBtnTitle:rightBtn];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:alertView];

}
- (void)initWithTitle:(NSString*)title leftBtnTitle:(NSString*)leftBtn rightBtnTitle:(NSString*)rightBtn
{
    CGFloat W = [[UIScreen mainScreen] bounds].size.width;
    CGFloat H = [[UIScreen mainScreen] bounds].size.height;
    self.frame =CGRectMake(0, 0, W, H + 20);
    self.message = title;
    self.leftTitle = leftBtn;
    self.rightTitle = rightBtn;
    
    [self createUI];

}

- (void)initWithTitle:(NSString*)title confirmBtn:(NSString*)confirmBtn
{
    CGFloat W = [[UIScreen mainScreen] bounds].size.width;
    CGFloat H = [[UIScreen mainScreen] bounds].size.height;
    self.frame =CGRectMake(0, 0, W, H + 20);
    self.message = title;
    self.confirmBtn = confirmBtn;
    
    [self createConfirmBtnUI];
    
}

- (void)initInputAlertWithTitle:(NSString*)title leftBtnTitle:(NSString*)leftBtn rightBtnTitle:(NSString*)rightBtn
{
    CGFloat W = [[UIScreen mainScreen] bounds].size.width;
    CGFloat H = [[UIScreen mainScreen] bounds].size.height;
    self.frame =CGRectMake(0, 0, W, H + 20);
    self.message = title;
    self.leftTitle = leftBtn;
    self.rightTitle = rightBtn;
    
    [self createInputUI];
    
}
- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

#pragma mark -- 构建单个按钮UI
- (void)createConfirmBtnUI
{
    
    [self removeAllSubviews];
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
    [backgroundView setBackgroundColor: MakeColorRGBA(0x2b2c32, 0.0)];
    [self addSubview:backgroundView];
    
    CGFloat messageWidth = 270 * VH_RATE_SCALE;
    
    CGSize messageSize = [self.message boundingRectWithSize:CGSizeMake(messageWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0f]} context:nil].size;
    
    CGFloat heightSize = 130 * VH_RATE_SCALE;
    
    if(messageSize.height > 20 * VH_RATE_SCALE) {
        heightSize = heightSize - 20 *VH_RATE_SCALE + messageSize.height;
    }
    
    
    
    VHClearBufferView *clearBufferView = [[VHClearBufferView alloc]initWithClearBufferViewFrame:CGRectMake((backgroundView.width - 270 * VH_RATE_SCALE) / 2.0, (self.height-heightSize)/2, 270 * VH_RATE_SCALE, heightSize) title:self.message  confirmBtn:self.confirmBtn];
    __weak __typeof(self) weakSelf = self;
    clearBufferView.block = ^ (NSInteger type){
      
            [weakSelf closeView];
            if (self.buttonClickBlock) {
                self.buttonClickBlock(1);
            }
            
        
    };
    clearBufferView.hidden = NO;
    clearBufferView.center = CGPointMake(backgroundView.center.x, backgroundView.center.y);
    [backgroundView addSubview:clearBufferView];
    [UIView animateWithDuration:0.25f animations:^{
        backgroundView.backgroundColor = MakeColorRGBA(0x2b2c32, 0.3);
    }];
    
    
    
}
#pragma mark -- 构建输入框UI
- (void)createInputUI
{
    
    [self removeAllSubviews];
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
    [backgroundView setBackgroundColor: MakeColorRGBA(0x2b2c32, 0.0)];
    [self addSubview:backgroundView];

    
    CGFloat heightSize = 120 * VH_RATE_SCALE;

  
    
    CGRect frame = CGRectMake((backgroundView.width - 270 * VH_RATE_SCALE) / 2.0, (self.height-heightSize)/2, 270 * VH_RATE_SCALE, heightSize);
    if (frame.origin.y+frame.size.height+50> backgroundView.height-KeyboardHeight) {
        frame.origin.y = frame.origin.y-(frame.origin.y+frame.size.height+50- (backgroundView.height-KeyboardHeight));
       
    }

    
    VHClearBufferView *clearBufferView = [[VHClearBufferView alloc]initWithInputAlertViewFrame:frame title:self.message leftBtn:self.leftTitle rightBtn:self.rightTitle];
    
    
      __weak VHClearBufferView * weakClearView = clearBufferView;
    __weak __typeof(self) weakSelf = self;
    clearBufferView.block = ^ (NSInteger type){
        
        
        if (type == 1) {
            
       
            [weakSelf closeView];
            if (weakSelf.buttonWithTextClickBlock) {
                weakSelf.buttonWithTextClickBlock(0,weakClearView.inputTextField.text);
            }

            
        }
        else
        {
            [weakSelf closeView];
            if (weakSelf.buttonWithTextClickBlock) {
                weakSelf.buttonWithTextClickBlock(1,weakClearView.inputTextField.text);
            }
            
        }
        
        
    };
    clearBufferView.hidden = NO;
    [backgroundView addSubview:clearBufferView];
    [clearBufferView.inputTextField becomeFirstResponder];

    [UIView animateWithDuration:0.25f animations:^{
        backgroundView.backgroundColor = MakeColorRGBA(0x2b2c32, 0.3);
    }];
    
    
    
}


#pragma mark -- 构建两个按钮UI
- (void)createUI
{
    
    [self removeAllSubviews];
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
    [backgroundView setBackgroundColor: MakeColorRGBA(0x2b2c32, 0.0)];
    [self addSubview:backgroundView];

    CGFloat messageWidth = 270 * VH_RATE_SCALE;

    CGSize messageSize = [self.message boundingRectWithSize:CGSizeMake(messageWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0f]} context:nil].size;
    
    CGFloat heightSize = 130 * VH_RATE_SCALE;

    if(messageSize.height > 20 * VH_RATE_SCALE) {
        heightSize = heightSize - 20 *VH_RATE_SCALE + messageSize.height;
    }


    
     VHClearBufferView *clearBufferView = [[VHClearBufferView alloc]initWithClearBufferViewFrame:CGRectMake((backgroundView.width - 270 * VH_RATE_SCALE) / 2.0, (self.height-heightSize)/2, 270 * VH_RATE_SCALE, heightSize) title:self.message  leftBtn:self.leftTitle rightBtn:self.rightTitle];
    __weak __typeof(self) weakSelf = self;
    clearBufferView.block = ^ (NSInteger type){
        if (type == 1) {
            
                [weakSelf closeView];
            if (self.buttonClickBlock) {
                self.buttonClickBlock(0);
            }
            
        }
        else {
            [weakSelf closeView];
            if (self.buttonClickBlock) {
                self.buttonClickBlock(1);
            }
            
        }
    };
    clearBufferView.hidden = NO;
    clearBufferView.center = CGPointMake(backgroundView.center.x, backgroundView.center.y);
    [backgroundView addSubview:clearBufferView];
    [UIView animateWithDuration:0.25f animations:^{
        backgroundView.backgroundColor = MakeColorRGBA(0x2b2c32, 0.3);
    }];
    
    

}
- (void)closeView
{
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.window endEditing:YES];
}




@end
static const int GapWidth = 20;
static const int InputTitleHeight = 0;
static const int ButtonHeight = 40;

typedef enum : NSUInteger {
    Alert_TwoButtonStyle,//普通的两个按钮的提示框
    Alert_OneButtonStyle,//一个按钮的提示框
    Alert_InputStyle,//带输入的提示框
} AlertView_Style;


@interface VHClearBufferView ()
{
    UILabel *_titleLabel;
    UIButton *_cannelBtn;
    UIButton *_sureBtn;
    NSString *_leftBtnName;
    NSString *_rightBtnName;
    NSString *_titleName;
    NSString * _confirmName;
    NSString * _placeHoldTitle;
    
}
@property (nonatomic,assign)AlertView_Style alertView_Style;
@end

@implementation VHClearBufferView

- (VHClearBufferView *)initWithClearBufferViewFrame:(CGRect )frame title:(NSString *)title leftBtn:(NSString *)leftBtn rightBtn:(NSString *)rightBtn
{
    if (self = [super initWithFrame:frame]) {
        self = [[VHClearBufferView alloc]initWithFrame:frame];
        self.alertView_Style = Alert_TwoButtonStyle;
        
        self.backgroundColor = MakeColorRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4 * VH_RATE_SCALE;
        _titleName = title;
        _leftBtnName = leftBtn;
        _rightBtnName = rightBtn;
        [self layoutUI];
    }
    return self;
}
- (VHClearBufferView *)initWithClearBufferViewFrame:(CGRect )frame title:(NSString *)title confirmBtn:(NSString*)confirmBtn {
    if (self = [super initWithFrame:frame]) {
        
        self = [[VHClearBufferView alloc]initWithFrame:frame];
        self.alertView_Style = Alert_OneButtonStyle;
        
        self.backgroundColor = MakeColorRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4 * VH_RATE_SCALE;
        _titleName = title;
        _confirmName = confirmBtn;
        
        [self layoutUI];
    }
    return self;
}

- (VHClearBufferView *)initWithInputAlertViewFrame:(CGRect )frame title:(NSString *)title leftBtn:(NSString *)leftBtn rightBtn:(NSString *)rightBtn
{
    if (self = [super initWithFrame:frame]) {
        
        
        self = [[VHClearBufferView alloc]initWithFrame:frame];
        self.alertView_Style = Alert_InputStyle;
        self.backgroundColor = MakeColorRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4 * VH_RATE_SCALE;
        _titleName = title;
        _leftBtnName = leftBtn;
        _rightBtnName = rightBtn;
        _placeHoldTitle = title;
        [self layoutUI];
        
    }
    return self;
}

- (void)layoutUI
{
    if (!_titleLabel) {
        
        if (self.alertView_Style==Alert_InputStyle) {
            /*
             _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 40)];
             _titleLabel.text = _titleName;
             _titleLabel.numberOfLines = 1;
             _titleLabel.font = [UIFont systemFontOfSize:17];
             _titleLabel.textColor = MakeColorRGB(0x2b2c32);
             _titleLabel.textAlignment = NSTextAlignmentCenter;
             [self addSubview:_titleLabel];
             UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, _titleLabel.bottom, self.width, 1)];
             line.backgroundColor = [UIColor lightGrayColor];
             [self addSubview:line];
             */
        }
        else
        {
            CGFloat messageWidth = self.bounds.size.width;
            CGFloat titleLabelHeight = 20 * VH_RATE_SCALE;
            CGSize messageSize = [_titleName boundingRectWithSize:CGSizeMake(messageWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0f]} context:nil].size;
            
            
            
            if(messageSize.height > titleLabelHeight) {
                titleLabelHeight = messageSize.height;
            }
            
            _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30 * VH_RATE_SCALE, self.width, titleLabelHeight)];
            _titleLabel.text = _titleName;
            _titleLabel.numberOfLines = 0;
            _titleLabel.font = [UIFont systemFontOfSize:17];
            _titleLabel.textColor = MakeColorRGB(0x2b2c32);
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_titleLabel];
            
        }
        
        
    }
    if (self.alertView_Style == Alert_OneButtonStyle) {
        if (!_sureBtn) {
            _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.height - ButtonHeight * VH_RATE_SCALE, self.width , ButtonHeight * VH_RATE_SCALE)];
            [_sureBtn setBackgroundImage:[VHTools imageWithColor:MakeColorRGBA(0xff3333, 1.0) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [_sureBtn setBackgroundImage:[VHTools imageWithColor:MakeColorRGBA(0xff3333, 0.90) size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
            [_sureBtn setBackgroundImage:[VHTools imageWithColor:MakeColorRGBA(0xff3333, 0.90) size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
            [_sureBtn setTitle:_confirmName forState:UIControlStateNormal];
            [_sureBtn setTitleColor:MakeColorRGB(0xffffff) forState:UIControlStateNormal];
            _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            _sureBtn.tag = 2;
            [_sureBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_sureBtn];
        }
        
    }
    else if (self.alertView_Style == Alert_TwoButtonStyle)
    {
        if (!_cannelBtn) {
            _cannelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.height - 40 * VH_RATE_SCALE, self.width / 2.0, 40 * VH_RATE_SCALE)];
            [_cannelBtn setBackgroundImage:[VHTools imageWithColor:MakeColorRGBA(0x9c9ca0, 1.0) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [_cannelBtn setBackgroundImage:[VHTools imageWithColor:MakeColorRGBA(0x9c9ca0, 0.8) size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
            [_cannelBtn setBackgroundImage:[VHTools imageWithColor:MakeColorRGBA(0x9c9ca0, 0.8) size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
            [_cannelBtn setTitle:_leftBtnName forState:UIControlStateNormal];
            [_cannelBtn setTitleColor:MakeColorRGB(0x2b2c32) forState:UIControlStateNormal];
            _cannelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            _cannelBtn.tag = 1;
            [_cannelBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_cannelBtn];
        }
        if (!_sureBtn) {
            _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(_cannelBtn.right, self.height - 40 * VH_RATE_SCALE, self.width / 2.0, 40 * VH_RATE_SCALE)];
            [_sureBtn setBackgroundImage:[VHTools imageWithColor:MakeColorRGBA(0xff3333, 1.0) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [_sureBtn setBackgroundImage:[VHTools imageWithColor:MakeColorRGBA(0xff3333, 0.90) size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
            [_sureBtn setBackgroundImage:[VHTools imageWithColor:MakeColorRGBA(0xff3333, 0.90) size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
            [_sureBtn setTitle:_rightBtnName forState:UIControlStateNormal];
            [_sureBtn setTitleColor:MakeColorRGB(0xffffff) forState:UIControlStateNormal];
            _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            _sureBtn.tag = 2;
            [_sureBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_sureBtn];
        }
        
    }
    else if (self.alertView_Style == Alert_InputStyle)
    {
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(GapWidth, (self.height-80*VH_RATE_SCALE)/2*VH_RATE_SCALE, self.width-2*GapWidth, 40*VH_RATE_SCALE)];
        view.layer.borderWidth = 1;
//        view.layer.borderColor = [VHThemeManager sharedManager].grayLineColor.CGColor;
        view.layer.cornerRadius = 3.f;
        view.layer.masksToBounds = YES;
        [self addSubview:view];
        
        
        _inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(11, 0, view.width-22,40*VH_RATE_SCALE)];
        _inputTextField.backgroundColor = [UIColor clearColor];
        _inputTextField.placeholder = _placeHoldTitle;
        [_inputTextField setValue:MakeColorRGB(0x707075) forKeyPath:@"_placeholderLabel.textColor"];
        [_inputTextField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
        _inputTextField.font = [UIFont systemFontOfSize:13];
        [view addSubview:_inputTextField];
        
        if (!_cannelBtn) {
            _cannelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.height - 40 * VH_RATE_SCALE, self.width / 2.0, 40 * VH_RATE_SCALE)];
            [_cannelBtn setBackgroundImage:[VHTools imageWithColor:MakeColorRGBA(0x9c9ca0, 1.0) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [_cannelBtn setBackgroundImage:[VHTools imageWithColor:MakeColorRGBA(0x9c9ca0, 0.8) size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
            [_cannelBtn setBackgroundImage:[VHTools imageWithColor:MakeColorRGBA(0x9c9ca0, 0.8) size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
            [_cannelBtn setTitle:_leftBtnName forState:UIControlStateNormal];
            [_cannelBtn setTitleColor:MakeColorRGB(0x2b2c32) forState:UIControlStateNormal];
            _cannelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            _cannelBtn.tag = 1;
            [_cannelBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_cannelBtn];
        }
        if (!_sureBtn) {
            _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(_cannelBtn.right, self.height - 40 * VH_RATE_SCALE, self.width / 2.0, 40 * VH_RATE_SCALE)];
            [_sureBtn setBackgroundImage:[VHTools imageWithColor:MakeColorRGBA(0xff3333, 1.0) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
            [_sureBtn setBackgroundImage:[VHTools imageWithColor:MakeColorRGBA(0xff3333, 0.90) size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
            [_sureBtn setBackgroundImage:[VHTools imageWithColor:MakeColorRGBA(0xff3333, 0.90) size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
            [_sureBtn setTitle:_rightBtnName forState:UIControlStateNormal];
            [_sureBtn setTitleColor:MakeColorRGB(0xffffff) forState:UIControlStateNormal];
            _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            _sureBtn.tag = 2;
            [_sureBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_sureBtn];
        }
        
    }
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)clickBtn:(UIButton *)button
{
    if (self.block) {
        self.block(button.tag);
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
