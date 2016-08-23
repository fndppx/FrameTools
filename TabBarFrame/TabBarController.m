//
//  TabBarController.m
//  FrameTools
//
//  Created by keyan on 16/8/23.
//  Copyright © 2016年 ky. All rights reserved.
//

#import "TabBarController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourViewController.h"
@interface TabBarController ()<UINavigationControllerDelegate,UIScrollViewDelegate>
{
    UIView   *_tabbarView;
    UIButton *_button0;//首页
    UILabel  *_label0;
    UIButton *_button1;//发现
    UILabel  *_label1;
    
    UIButton *_button2;//消息
    UILabel  *_label2;
    
    UIButton *_button3;//我
    UILabel  *_label3;
    
    UIButton *_liveButton;
    NSInteger _childViewControllerscount;
    NSInteger _viewControllersCount;
    NSString        *_pboardUserID;
    UIImageView    *_redPointImageView;

}
@property(nonatomic,strong)FirstViewController  *firstVC;
@property(nonatomic,strong)SecondViewController   *secondVC;
@property(nonatomic,strong)ThirdViewController *thirdVC;
@property(nonatomic,strong)FourViewController *fourVC;
@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithViewController];
    _tabbarHeight = 49;
    [self setSelectedIndex:0];
    
    int w = (int)VH_SW;
    switch (w) {
        case 320:
            [self initUI];
            break;
        case 375:
            [self initUI6P:YES];
            break;
        case 414:
            [self initUI6P:NO];
            break;
            
        default:
            [self initUI];
            break;
    }
    //状态栏高度变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameChange:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//创建子控制器
- (void)initWithViewController
{
    //1.三级控制器
    _firstVC = [[FirstViewController alloc] init];//关注
    _secondVC = [[SecondViewController alloc] init]; //发现
    _thirdVC = [[ThirdViewController alloc]init];//个人中心
    _fourVC = [[FourViewController alloc]init];//消息
    
    NSArray *ViewCtr = @[_firstVC,_secondVC,_thirdVC,_fourVC];
    
    NSMutableArray *veiwControllers = [NSMutableArray arrayWithCapacity:ViewCtr.count];
    for (int i=0; i<ViewCtr.count; i++) {
        UIViewController *viewController = ViewCtr[i];
        viewController.hidesBottomBarWhenPushed = NO;
        
        VHNavigationController *navigation = [[VHNavigationController alloc] initWithRootViewController:viewController];
        
        navigation.delegate = self;
        [veiwControllers addObject:navigation];
        navigation = nil;
    }
    //3.将二级控制器交给一级控制器管理
    self.viewControllers = veiwControllers;
}
- (void)initUI
{
    self.tabBar.backgroundColor = [UIColor clearColor];
    
    self.tabBar.hidden = YES;
    float itemW = 68*VH_RATE_SCALE;
    float liveW = 74*VH_RATE_SCALE;
    
    _tabbarView = [[UIView alloc] initWithFrame:[self resetTabBarFrame]];
    _tabbarView.backgroundColor = [UIColor whiteColor];
    UIView*t_view = [[UIView alloc] initWithFrame:CGRectMake(0, 9, VH_SW, 40)];
    t_view.backgroundColor = MakeColor(25, 24, 29, 1);
    //  [_tabbarView addSubview:t_view];
    [self.view addSubview:_tabbarView];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, -0.1, VH_SW, 0.5)];
    line.backgroundColor=[UIColor redColor];
    [_tabbarView addSubview:line];
    
    //关注**************
    NSString *narmal_image1 = @"tabbar_focus_normal";
    NSString *high_image1   = @"tabbar_focus_selected";
    _label0 = [[UILabel alloc]initWithFrame:CGRectMake(0, 26, itemW, 25)];
    _label0.text = @"关注";
    _label0.textAlignment = NSTextAlignmentCenter;
    _label0.font = [UIFont systemFontOfSize:11];
    
    
    _button0 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button0.frame = CGRectMake(12, 0, itemW, 49);
    _button0.tag = 0;
    [_button0 setImage:[UIImage imageNamed:narmal_image1] forState:UIControlStateNormal];
    [_button0 setImage:[UIImage imageNamed:high_image1] forState:UIControlStateHighlighted];
    [_button0 setImage:[UIImage imageNamed:high_image1] forState:UIControlStateSelected];
    [_button0 addTarget:self action:@selector(selectedTabbar:) forControlEvents:UIControlEventTouchUpInside];
    [_button0 setImageEdgeInsets: UIEdgeInsetsMake(-15, 0, 0, 0)];
    [_tabbarView addSubview:_button0];
    [_button0 addSubview:_label0];
    
    //发现**************************
    NSString *narmal_image3 = @"tabbar_find_normal";
    NSString *high_image3   = @"tabbar_find_selected";
    _label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 26, itemW, 25)];
    _label1.text = @"发现";
    _label1.textAlignment = NSTextAlignmentCenter;
    _label1.font = [UIFont systemFontOfSize:11];
    // [_tabbarView addSubview:_label1];
    
    _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button1.frame = CGRectMake(_button0.frame.origin.x+_button0.frame.size.width,0, itemW, 49);
    _button1.tag = 1;
    [_button1 setImage:[UIImage imageNamed:narmal_image3] forState:UIControlStateNormal];
    [_button1 setImage:[UIImage imageNamed:high_image3] forState:UIControlStateHighlighted];
    [_button1 setImage:[UIImage imageNamed:high_image3] forState:UIControlStateSelected];
    [_button1 addTarget:self action:@selector(selectedTabbar:) forControlEvents:UIControlEventTouchUpInside];
    [_button1 setImageEdgeInsets: UIEdgeInsetsMake(-15, 0, 0, 0)];
    [_tabbarView addSubview:_button1];
    [_button1 addSubview:_label1];
    
    //发直播********************
    NSString *narmal_image2 = @"tabbar_live_normal";
    NSString *high_image2   = @"tabbar_live_selected";
    
    _liveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _liveButton.frame = CGRectMake(_button1.frame.origin.x+_button1.frame.size.width+3,-14, liveW, 64*VH_RATE_SCALE);
    _liveButton.tag = 4;
    [_liveButton setImage:[UIImage imageNamed:narmal_image2] forState:UIControlStateNormal];
    [_liveButton setImage:[UIImage imageNamed:high_image2] forState:UIControlStateHighlighted];
    [_liveButton setImage:[UIImage imageNamed:high_image2] forState:UIControlStateSelected];
    [_liveButton addTarget:self action:@selector(selectedTabbar:) forControlEvents:UIControlEventTouchUpInside];
    [_tabbarView addSubview:_liveButton];
    
    //消息********************
    NSString *narmal_image4 =@"tabbar_message_normal";
    NSString *high_image4 = @"tabbar_message_selected";
    _label2=[[UILabel alloc] initWithFrame:CGRectMake(0, 26, itemW, 25)];
    _label2.text=@"消息";
    _label2.textAlignment=NSTextAlignmentCenter;
    _label2.font=[UIFont systemFontOfSize:11];
    [_tabbarView addSubview:_label2];
    _button2=[UIButton buttonWithType:UIButtonTypeCustom];
    _button2.frame=CGRectMake(_liveButton.frame.origin.x+_liveButton.frame.size.width, 0, itemW, 49);
    _button2.tag=2;
    [_button2 setImage:[UIImage imageNamed:narmal_image4] forState:UIControlStateNormal];
    [_button2 setImage:[UIImage imageNamed:high_image4] forState:UIControlStateHighlighted];
    [_button2 setImage:[UIImage imageNamed:high_image4] forState:UIControlStateSelected];
    [_button2 addTarget:self action:@selector(selectedTabbar:) forControlEvents:UIControlEventTouchUpInside];
    [_button2 setImageEdgeInsets: UIEdgeInsetsMake(-15, 0, 0, 0)];
    [_tabbarView addSubview:_button2];
    [_button2 addSubview:_label2];
    
    _redPointImageView=[[UIImageView alloc] initWithFrame:CGRectMake(35, 4,8*VH_RATE_SCALE, 8*VH_RATE_SCALE)];
    [_redPointImageView setImage:[UIImage  imageNamed:@"newMessage"]];
    _redPointImageView.hidden=YES;
    [_button2 addSubview:_redPointImageView];
    
    //我************************
    NSString *narmal_image5=@"tabbar_my_normal";
    NSString *high_image5=@"tabbar_my_selected";
    _label3=[[UILabel alloc]initWithFrame:CGRectMake(0, 26, itemW, 25)];
    _label3.text=@"我的";
    _label3.textAlignment=NSTextAlignmentCenter;
    _label3.font=[UIFont systemFontOfSize:11];
    
    _button3=[UIButton buttonWithType:UIButtonTypeCustom];
    _button3.frame=CGRectMake(_button2.origin.x+_button2.size.width+3, 0, itemW, 49);
    _button3.tag=3;
    
    [_button3 setImage:[UIImage imageNamed:narmal_image5] forState:UIControlStateNormal];
    [_button3 setImage:[UIImage imageNamed:high_image5] forState:UIControlStateHighlighted];
    [_button3 setImage:[UIImage imageNamed:high_image5] forState:UIControlStateSelected];
    [_button3 addTarget:self action:@selector(selectedTabbar:) forControlEvents:UIControlEventTouchUpInside];
    [_button3 setImageEdgeInsets: UIEdgeInsetsMake(-15, 0, 0, 0)];
    [_tabbarView addSubview:_button3];
    [_button3 addSubview:_label3];
    [self selectTabAtIndex:self.selectedIndex];
    
}

- (void)initUI6P:(BOOL)is6
{
    self.tabBar.backgroundColor = [UIColor clearColor];
    float rate = VH_RATE_SCALE;
    self.tabBar.hidden = YES;
    float itemW = 68*rate;
    float liveW = 74*rate;
    
    // _tabbarHeight = 49-3/rate;
    
    _tabbarView = [[UIView alloc] initWithFrame:[self resetTabBarFrame]];
    _tabbarView.backgroundColor = [UIColor whiteColor];
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, -0.1, VH_SW, 0.5)];
    line.backgroundColor=[UIColor redColor];
    [_tabbarView addSubview:line];
    
    
    [self.view addSubview:_tabbarView];
    //关注***************************
    
    NSString *narmal_image1 = @"tabbar_focus_normal";
    NSString *high_image1   = @"tabbar_focus_selected";
    _label0 = [[UILabel alloc]initWithFrame:CGRectMake(0, 26, itemW, 25)];
    _label0.text = @"1";
    _label0.textColor=[UIColor blackColor];
    _label0.textAlignment = NSTextAlignmentCenter;
    _label0.font = [UIFont systemFontOfSize:11];
    
    
    _button0 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button0.frame = CGRectMake(12, 0, itemW, 49);
    _button0.tag = 0;
    [_button0 setImage:[UIImage imageNamed:narmal_image1] forState:UIControlStateNormal];
    [_button0 setImage:[UIImage imageNamed:high_image1] forState:UIControlStateHighlighted];
    [_button0 setImage:[UIImage imageNamed:high_image1] forState:UIControlStateSelected];
    [_button0 addTarget:self action:@selector(selectedTabbar:) forControlEvents:UIControlEventTouchUpInside];
    
    [_button0 setImageEdgeInsets: UIEdgeInsetsMake(is6?-15:-18, 0, 0, 0)];
    [_tabbarView addSubview:_button0];
    [_button0 addSubview:_label0];
    
    //发现********************************************
    NSString *narmal_image3 = @"tabbar_find_normal";
    NSString *high_image3   = @"tabbar_find_selected";
    _label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 26, itemW, 25)];
    _label1.textColor=[UIColor blackColor];
    _label1.text = @"2";
    _label1.textAlignment = NSTextAlignmentCenter;
    _label1.font = [UIFont systemFontOfSize:11];
    
    _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button1.frame = CGRectMake(_button0.origin.x+_button0.width,0, itemW, 49);
    _button1.tag = 1;
    [_button1 setImage:[UIImage imageNamed:narmal_image3] forState:UIControlStateNormal];
    [_button1 setImage:[UIImage imageNamed:high_image3] forState:UIControlStateHighlighted];
    [_button1 setImage:[UIImage imageNamed:high_image3] forState:UIControlStateSelected];
    [_button1 addTarget:self action:@selector(selectedTabbar:) forControlEvents:UIControlEventTouchUpInside];
    [_button1 setImageEdgeInsets: UIEdgeInsetsMake(is6?-15:-18, 0, 0, 0)];
    [_tabbarView addSubview:_button1];
    [_button1 addSubview:_label1];
    
    //发直播****************************************
    NSString *narmal_image2 = @"tabbar_live_normal";
    NSString *high_image2   = @"tabbar_live_selected";
    
    _liveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _liveButton.frame = CGRectMake(_button1.origin.x+_button1.width+3,-17.5, liveW, 64*VH_RATE_SCALE);
    if(is6)
    {
        _liveButton.frame = CGRectMake(_button1.origin.x+_button1.width+3,-15.5, liveW, 64*VH_RATE_SCALE);
        if(iPhone6plus)
            _liveButton.frame = CGRectMake(_button1.origin.x+_button1.width+3,-13, liveW, 64*VH_RATE_SCALE);
    }
    _liveButton.tag = 4;
    [_liveButton setImage:[UIImage imageNamed:narmal_image2] forState:UIControlStateNormal];
    [_liveButton setImage:[UIImage imageNamed:high_image2] forState:UIControlStateHighlighted];
    [_liveButton setImage:[UIImage imageNamed:high_image2] forState:UIControlStateSelected];
    [_liveButton addTarget:self action:@selector(selectedTabbar:) forControlEvents:UIControlEventTouchUpInside];
    [_tabbarView addSubview:_liveButton];
    
    //消息****************************************
    NSString *narmal_image4 = @"tabbar_message_normal";
    NSString *high_image4   = @"tabbar_message_selected";
    _label2=[[UILabel alloc] initWithFrame:CGRectMake(0, 26, itemW, 25)];
    _label2.text=@"3";
    _label2.textColor=[UIColor blackColor];
    _label2.textAlignment=NSTextAlignmentCenter;
    _label2.font=[UIFont systemFontOfSize:11];
    
    _button2=[UIButton buttonWithType:UIButtonTypeCustom];
    _button2.frame=CGRectMake(_liveButton.origin.x+_liveButton.width, 0, itemW, 49);
    _button2.tag=2;
    [_button2 setImage:[UIImage imageNamed:narmal_image4] forState:UIControlStateNormal];
    [_button2 setImage:[UIImage imageNamed:high_image4] forState:UIControlStateHighlighted];
    [_button2 setImage:[UIImage imageNamed:high_image4] forState:UIControlStateSelected];
    [_button2 addTarget:self action:@selector(selectedTabbar:) forControlEvents:UIControlEventTouchUpInside];
    //  [t_view addSubview:_button2];
    [_button2 setImageEdgeInsets:UIEdgeInsetsMake(is6?-15:-18, 0, 0, 0)];
    [_tabbarView addSubview:_button2];
    [_button2 addSubview:_label2];
    
    _redPointImageView=[[UIImageView alloc] initWithFrame:CGRectMake(42*VH_RATE_SCALE, 5, 6*VH_RATE_SCALE, 6*VH_RATE_SCALE)];
    [_redPointImageView setImage:[UIImage imageNamed:@"newMessage"]];
    _redPointImageView.hidden=YES;
    [_button2 addSubview:_redPointImageView];
    
    //我************************************************
    NSString *narmal_image5 = @"tabbar_my_normal";
    NSString *high_image5   = @"tabbar_my_selected";
    _label3=[[UILabel alloc] initWithFrame:CGRectMake(0, 26, itemW, 25)];
    _label3.text=@"4";
    _label3.textAlignment=NSTextAlignmentCenter;
    _label3.font=[UIFont systemFontOfSize:11];
    
    _button3=[UIButton buttonWithType:UIButtonTypeCustom];
    _button3.frame=CGRectMake(_button2.origin.x+_button2.width+3, 0, itemW, 49);
    _button3.tag=3;
    [_button3 setImage:[UIImage imageNamed:narmal_image5] forState:UIControlStateNormal];
    [_button3 setImage:[UIImage imageNamed:high_image5] forState:UIControlStateHighlighted];
    [_button3 setImage:[UIImage imageNamed:high_image5] forState:UIControlStateSelected];
    [_button3 addTarget:self action:@selector(selectedTabbar:) forControlEvents:UIControlEventTouchUpInside];
    
    [_button3 setImageEdgeInsets:UIEdgeInsetsMake(is6?-15:-18, 0, 0, 0)];
    [_tabbarView addSubview:_button3];
    [_button3 addSubview:_label3];
    
    [self selectTabAtIndex:self.selectedIndex];
}


- (void)selectTabAtIndex:(NSInteger)index
{
    if(index == 0)
    {
        _button0.selected = YES;
//        _label0.textColor = [VHThemeManager sharedManager].redColor;
        
        _button1.selected = NO;
        _label1.textColor =MakeColorRGB(0x46464b);
        _button2.selected = NO;
        _label2.textColor =MakeColorRGB(0x46464b);
        _button3.selected = NO;
        _label3.textColor = MakeColorRGB(0x46464b);
     
    }
    else if (index ==1)
    {
        
        _button0.selected = NO;
        _label0.textColor = MakeColorRGB(0x46464b);
        
        _button2.selected = NO;
        _label2.textColor =  MakeColorRGB(0x46464b);
        
        _button3.selected = NO;
        _label3.textColor =  MakeColorRGB(0x46464b);
        
        _button1.selected = YES;
         }else if (index==3){
        _button2.selected=NO;
        _label2.textColor=MakeColorRGB(0x46464b);
        
        _button0.selected = NO;
        _label0.textColor = MakeColorRGB(0x46464b);
        
        _button1.selected = NO;
        _label1.textColor = MakeColorRGB(0x46464b);
        
        _button3.selected = YES;
             
    }else if (index==2)
    {
        _button3.selected=NO;
        _label3.textColor=MakeColorRGB(0x46464b);
        
        _button0.selected = NO;
        _label0.textColor = MakeColorRGB(0x46464b);
        
        _button1.selected = NO;
        _label1.textColor = MakeColorRGB(0x46464b);
        
        _button2.selected = YES;
        
    }
 
}
#pragma mark - action
- (void)selectedTabbar:(UIButton *)button
{
    
        [self selectTabAtIndex:button.tag];
        self.selectedIndex = button.tag;
    
}

- (void)statusBarFrameChange:(NSNotification *)noti
{
    
    NSDictionary * dic = noti.userInfo;
    NSArray * dicKeys = [dic allKeys];
    if ([dicKeys containsObject:@"tabbarInfo"] && [dic objectForKey:@"tabbarInfo"] ) {//从播放页面或者个人中心返回首页／预约界面返回首页／直播结束后返回首页
        [self tabBarViewAnimate];
        return;
    }
    if (_childViewControllerscount==1 && _viewControllersCount ==0) {//在首页／发现页面 tabbar才需要调整位置
        if (_tabbarView.frame.origin.x < 0) {//tabbar隐藏的界面，不做任何处理
            return;
        }
        
        [self tabBarViewAnimate];
    }
}

- (CGRect)resetTabBarFrame{
    if ([VHTools statusBarHeighrIsNormal]) {
        return  CGRectMake(_tabbarView.left, VH_SH-49  , VH_SW, 49);
    }else{
        return CGRectMake(_tabbarView.left, VH_SH-69 , VH_SW, 49);
    }
}

- (void)tabBarViewAnimate
{
    [UIView animateWithDuration:0.3f animations:^{
        _tabbarView.frame = [self resetTabBarFrame];
    }];
}


- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    //子控制器的个数
    _childViewControllerscount = navigationController.viewControllers.count;
    _viewControllersCount = viewController.childViewControllers.count;
    if (_childViewControllerscount == 1 && _viewControllersCount == 0) {
        [self hiddenTabbar:NO Animated:YES];
    } else {
        [self hiddenTabbar:YES Animated:YES];
    }
    
//    if ([viewController isKindOfClass:[VHMessageViewController class]]) {
//        [self hiddenTabbar:NO Animated:YES];
//    }
    self.tabBar.hidden = YES;
}
//是否显示工具栏
- (void)hiddenTabbar:(BOOL)hidden Animated:(BOOL)animated
{
    if(animated)
    {
        CGRect newframe = _tabbarView.frame;
        newframe.origin.x = hidden?-VH_SW:0;
        [UIView beginAnimations:Nil context:NULL];
        [UIView setAnimationDuration:0.2];
        _tabbarView.frame = newframe;
        [UIView commitAnimations];
    }
    else
    {
        CGRect newframe = _tabbarView.frame;
        newframe.origin.x = hidden?-VH_SW:0;
        _tabbarView.frame = newframe;
    }
    self.tabBar.hidden = YES;
}
- (BOOL)shouldAutorotate
{
    if([self.selectedViewController respondsToSelector:@selector(shouldAutorotate)])
        return [self.selectedViewController shouldAutorotate];
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if([self.selectedViewController respondsToSelector:@selector(supportedInterfaceOrientations)])
        return [self.selectedViewController supportedInterfaceOrientations];
    return [super supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if([self.selectedViewController respondsToSelector:@selector(preferredInterfaceOrientationForPresentation)])
        return [self.selectedViewController preferredInterfaceOrientationForPresentation];
    return [super preferredInterfaceOrientationForPresentation];
}


@end
