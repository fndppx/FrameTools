//
//  VHAlertTipView.m
//  test
//
//  Created by vhall on 16/4/14.
//  Copyright © 2016年 vhall. All rights reserved.
//

#import "VHAlertTipView.h"
#import "AppDelegate.h"

#define kDefaultHideViewTimer 1.5f  //默认自动隐藏时间
#define kDefaultAnimateTime   0.25f //默认动画时间

@interface VHAlertTipView()
@property (atomic,strong) UIViewController *topVC;//屏幕旋转时过渡
@property (atomic,strong) UIView   *alertBgView;
@property (atomic,strong) UIImageView *leftImageView;
@property (atomic,strong) UILabel  *alertLabel;
@property (atomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) NSString *message;
@property (assign,atomic) CGFloat minShowTimer;//显示与隐藏的动画时间
@property (assign,nonatomic) CGFloat delayTimer;//延时消失的时间
@property (assign,nonatomic) BOOL isAutomaticHide;
@property (assign,nonatomic) BOOL isBothHide;//可点击可自动隐藏标志
@property (assign,nonatomic) BOOL isShow;
@property (assign,nonatomic) BOOL isAlertView;//弹窗还是提示
@end

@implementation VHAlertTipView

@synthesize alertBgView;
@synthesize alertLabel;
@synthesize closeBtn;


+ (void)showWithTitle:(NSAttributedString *)title message:(NSAttributedString *)message  delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle
{
    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    VHAlertTipView * VHView = [[VHAlertTipView alloc] initWithAlertViewFrame:appDelegate.window.bounds title:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitle];
    [appDelegate.window addSubview:VHView];
}

+ (void)showVHAlertTipViewWithMessage:(NSString *)message
{
    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    VHAlertTipView * VHView = [[VHAlertTipView alloc] initWithView:appDelegate.window isExternalView:NO];
    [VHView setMessage:message];
    [VHView setIsBothHide:YES];
    [appDelegate.window addSubview:VHView];
}

+ (void)showVHAlertTipViewWithMessage:(NSString *)message isAutomaticHide:(BOOL)isAutomaticHide
{
    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    VHAlertTipView * VHView = [[VHAlertTipView alloc] initWithView:appDelegate.window isExternalView:NO];
    [VHView setMessage:message];
    [VHView setIsAutomaticHide:isAutomaticHide];
    [appDelegate.window addSubview:VHView];
}

+ (void)showVHAlertTipViewWithMessage:(NSString *)message hideViewDelay:(CGFloat)timer
{
    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    VHAlertTipView * VHView = [[VHAlertTipView alloc] initWithView:appDelegate.window isExternalView:NO];
    [VHView setDelayTimer:timer];
    [VHView setMessage:message];
    [appDelegate.window addSubview:VHView];
}

+ (void)showVHAlertTipViewWithView:(UIView *)view
{
    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    VHAlertTipView * VHView = [[VHAlertTipView alloc] initWithView:appDelegate.window isExternalView:YES];
    view.center = VHView.center;
    [VHView addSubview:view];
    [appDelegate.window addSubview:VHView];
}

+ (void)hideVHAlertTipView
{
    NSArray *wins=[UIApplication sharedApplication].windows;
    VHAlertTipView * VHAlert = [VHAlertTipView VHAlertForView:[wins objectAtIndex:0]];
    if (VHAlert) 
        [VHAlert removeFromSuperview];
}

+ (VHAlertTipView *)VHAlertForView:(UIView *)view
{
    VHAlertTipView * VHAlert = nil;
    NSArray *subviews = view.subviews;
    Class hudClass = [VHAlertTipView class];
    for (UIView *aView in subviews) {
        if ([aView isKindOfClass:hudClass]) {
            VHAlert = (VHAlertTipView *)aView;
        }
    }
    return VHAlert;
}

#pragma mark instance View
- (id)initWithView:(UIView *)view isExternalView:(BOOL)isExternalView{
    NSAssert(view, @"View must not be nil.");
    id me = [self initWithViewFrame:view.bounds isExternalView:isExternalView];
    return me;
}

- (instancetype)initWithViewFrame:(CGRect)frame isExternalView:(BOOL)isExternalView
{
    if (self = [super initWithFrame:frame]) {
        self = [[VHAlertTipView alloc]initWithFrame:frame];
        self.backgroundColor = [UIColor clearColor];
        _isAlertView = NO;
        if (!_isShow)
            self.frame = [self getRootViewControllerViewBounds];
        if (!isExternalView)
            [self layoutUIAlertTipView];
    }
    return self;
}

#pragma mark  alertViewInit
- (instancetype)initWithAlertViewFrame:(CGRect)frame title:(NSAttributedString *)title message:(NSAttributedString *)message  delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle
{
    if (self = [super initWithFrame:frame]) {
        self = [[VHAlertTipView alloc]initWithFrame:frame];
        self.backgroundColor = [UIColor clearColor];
        _isAlertView = YES;
        self.frame = [self getRootViewControllerViewBounds];
        //弹窗UI
        if (!self.alertBgView) {
            self.alertBgView = [[UIView alloc]initWithFrame:CGRectMake( 45 * VH_RATE_SCALE,
                                                                       VH_SH / 2.0 - 72 * VH_RATE_SCALE,
                                                                       VH_SW - 90 *VH_RATE_SCALE,
                                                                       144 * VH_RATE_SCALE)];
            self.alertBgView.center = self.center;
            self.alertBgView.backgroundColor = [UIColor colorWithRed:195 green:195 blue:195 alpha:1];
            self.alertBgView.layer.masksToBounds = YES;
            self.alertBgView.layer.cornerRadius = self.alertBgView.frame.size.height / 31.0;
            //title
            UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                                            5 * VH_RATE_SCALE,
                                                                            self.alertBgView.width,
                                                                            35 * VH_RATE_SCALE)];
            titleLabel.attributedText = title;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [alertBgView addSubview:titleLabel];
            
            //message
            UILabel * messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                                              titleLabel.bottom + 5 * VH_RATE_SCALE,
                                                                              self.alertBgView.width,
                                                                              60 * VH_RATE_SCALE)];
            messageLabel.attributedText = message;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.numberOfLines = 2;
            [self.alertBgView addSubview:messageLabel];
            
            UILabel *  bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                                             messageLabel.bottom,
                                                                             messageLabel.width,
                                                                             0.5)];
            bottomLine.backgroundColor = MakeColor(180, 160, 160, 1.0);
            [self.alertBgView addSubview:bottomLine];
            
            UIButton * cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,
                                                                             bottomLine.bottom,
                                                                             self.alertBgView.width / 2.0 - 0.25,
                                                                             self.alertBgView.height - bottomLine.origin.y - bottomLine.height)];
            [cancelBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cancelBtn setBackgroundImage:[VHTools imageWithColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:0.3] size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
            cancelBtn.tag = 0;
            [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertBgView addSubview:cancelBtn];
            
            UIButton * otherBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.alertBgView.width / 2.0 + 0.25,
                                                                            cancelBtn.origin.y,
                                                                            cancelBtn.width,
                                                                            cancelBtn.height)];
            [otherBtn setTitle:otherButtonTitle forState:UIControlStateNormal];
            [otherBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [otherBtn setBackgroundImage:[VHTools imageWithColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:0.3] size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
            otherBtn.tag = 1;
            [otherBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertBgView addSubview:otherBtn];
            
            UILabel * centerLine = [[UILabel alloc]initWithFrame:CGRectMake(cancelBtn.right, bottomLine.origin.y + bottomLine.height, 0.5, cancelBtn.size.height)];
            centerLine.backgroundColor = MakeColor(180, 160, 160, 1.0);
            [self.alertBgView addSubview:centerLine];
            
            self.delegate = delegate;
            [self addSubview:self.alertBgView];
        }
    }
    return self;
}

- (void)btnClick:(UIButton *)btn
{
    if (btn.tag == 0)
        [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(VHAlertView:clickedButtonAtIndex:)] ) {
        [self.delegate  VHAlertView:self clickedButtonAtIndex:btn.tag];
        [self removeFromSuperview];
    }
}


//提示UI
- (void)layoutUIAlertTipView
{
    if (!self.alertBgView) {
        self.alertBgView = [[UIView alloc]initWithFrame:CGRectMake(0, -30, self.frame.size.width, 30 * VH_RATE_SCALE)];
        self.alertBgView.backgroundColor = MakeColor(1, 1, 1, 1.0);
        [self addSubview:self.alertBgView];
    }
    if (_isShow) {
        self.alertBgView.frame = CGRectMake(0, 20, self.frame.size.width, 30 * VH_RATE_SCALE);
    }
    
    if (!self.leftImageView) {
        self.leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15 * VH_RATE_SCALE, self.alertBgView.height/2.0 - 8.75 * VH_RATE_SCALE, 17.5 * VH_RATE_SCALE, 17.5 * VH_RATE_SCALE)];
        self.leftImageView.image = [UIImage imageNamed:@"提示"];
        [self.alertBgView addSubview:self.leftImageView];
    }
    self.leftImageView.frame = CGRectMake(15 * VH_RATE_SCALE, self.alertBgView.height/2.0 - 8.75 * VH_RATE_SCALE, 17.5 * VH_RATE_SCALE, 17.5 * VH_RATE_SCALE);
    
    if (!self.alertLabel) {
        self.alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.leftImageView.right + 5 * VH_RATE_SCALE, self.alertBgView.height/2.0 - 12.5 *VH_RATE_SCALE,  300 * VH_RATE_SCALE, 25 * VH_RATE_SCALE)];
        self.alertLabel.backgroundColor = [UIColor clearColor];
        self.alertLabel.font = [UIFont systemFontOfSize:13];
        self.alertLabel.textAlignment = NSTextAlignmentLeft;
        self.alertLabel.textColor = [UIColor whiteColor];
        [self.alertBgView addSubview:self.alertLabel];
    }
    self.alertLabel.frame = CGRectMake(self.leftImageView.right + 5 * VH_RATE_SCALE, self.alertBgView.height/2.0 - 12.5 *VH_RATE_SCALE,  300 * VH_RATE_SCALE, 25 * VH_RATE_SCALE);
    self.alertLabel.text = self.message;
    
    if (!self.closeBtn) {
        self.closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.alertBgView.frame.size.width - 50 * VH_RATE_SCALE, self.alertBgView.height/ 2.0 - 25 * VH_RATE_SCALE, 50 * VH_RATE_SCALE, 50 * VH_RATE_SCALE)];
        [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
        [self.closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.alertBgView addSubview:self.closeBtn];
    }
    self.closeBtn.frame = CGRectMake(self.alertBgView.frame.size.width - 50 * VH_RATE_SCALE, self.alertBgView.height/ 2.0 - 25 * VH_RATE_SCALE, 50 * VH_RATE_SCALE, 50 * VH_RATE_SCALE);
    self.closeBtn.hidden = _isAutomaticHide;
}

#pragma mark 获取当前rootVC的bounds
- (CGRect)getRootViewControllerViewBounds
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    _topVC = appRootVC;
    while (_topVC.presentedViewController)
        _topVC = _topVC.presentedViewController;
    [self addKVO];
    return _topVC.view.bounds;
}

#pragma mark KVO
- (void)addKVO
{
    [_topVC.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew |
    NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
     self.frame = [[change objectForKey:NSKeyValueChangeNewKey]CGRectValue];
    if (_isAlertView)
        self.alertBgView.center = CGPointMake(self.width/2.0, self.height/2.0);
    else
        [self layoutUIAlertTipView];
}

- (void)dealloc
{
    [_topVC.view removeObserver:self forKeyPath:@"frame" context:nil];
}

#pragma mark setter方法
- (void)setMessage:(NSString *)message
{
    _message = message;
    if (_message){
        [self layoutUIAlertTipView];
        [self showAnimate:YES];
    }
}

- (void)setIsAutomaticHide:(BOOL)isAutomaticHide
{
    _isAutomaticHide = isAutomaticHide;
    self.closeBtn.hidden = _isAutomaticHide;
}

- (void)setIsBothHide:(BOOL)isBothHide
{
    _isBothHide = isBothHide;
    self.closeBtn.hidden = NO;
}

- (void)setIsShow:(BOOL)isShow
{
    _isShow = isShow;
}

- (void)setDelayTimer:(CGFloat)delayTimer
{
    _delayTimer = delayTimer;
    self.closeBtn.hidden = (_delayTimer > 0) ? YES : NO;
}

#pragma mark closeBtnAction
- (void)closeBtnClick
{
    [self showAnimate:NO];
}

#pragma mark 动画显示
- (void)showAnimate:(BOOL)isShow
{
    [self setIsShow:isShow];
    CGFloat showTime;
    if (self.minShowTimer == 0)
        showTime = kDefaultAnimateTime;
    else
        showTime = self.minShowTimer;
    BOOL isDelayTimer = (self.delayTimer > 0) ? YES : NO;
    
   [UIView animateWithDuration:showTime animations:^{
       self.alertBgView.frame = CGRectMake(0,isShow ? 20 : -30 * VH_RATE_SCALE, self.alertBgView.frame.size.width, self.alertBgView.frame.size.height);
       self.backgroundColor = isShow ? MakeColor(1, 1, 1, 0.1) :  MakeColor(0, 0, 0, 0);
   } completion:^(BOOL finished) {
       if (_isAutomaticHide || _isBothHide || isDelayTimer) {
           [NSTimer scheduledTimerWithTimeInterval:isDelayTimer ? self.delayTimer : kDefaultHideViewTimer target:self selector:@selector(closeBtnClick) userInfo:nil repeats:NO];
           _isAutomaticHide = NO;
       }
       if (!isShow){
           [self removeFromSuperview];
       }
   }];
}

@end
