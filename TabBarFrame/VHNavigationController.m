//
//  VHNavigationController.m
//  VhallIphone
//
//  Created by hello on 15/5/24.
//  Copyright (c) 2015年 com.vhall.direct.ios. All rights reserved.
//

#import "VHNavigationController.h"

@interface VHNavigationController ()

@end

@implementation VHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"Heiti SC" size:21],
                                     NSForegroundColorAttributeName:MakeColor(230, 230, 230, 1.0),};
    
    //self.navigationBar.barTintColor = MakeColor(4, 33, 32, 1.0);
    
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackImg"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBackImg"] forBarMetrics:UIBarMetricsDefault ];
    
    [self.navigationBar setTitleTextAttributes:textAttributes];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault ];
    self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    if ([self.navigationBar respondsToSelector:@selector(shadowImage)])
    {
        [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    
    [self.navigationBar setBackgroundColor:[UIColor clearColor]];
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

- (bool)shouldAutorotate
{
    if([self.topViewController respondsToSelector:@selector(shouldAutorotate)])
        return [self.topViewController shouldAutorotate];
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if([self.topViewController respondsToSelector:@selector(supportedInterfaceOrientations)])
        return [self.topViewController supportedInterfaceOrientations];
    return [super supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if([self.topViewController respondsToSelector:@selector(preferredInterfaceOrientationForPresentation)])
        return [self.topViewController preferredInterfaceOrientationForPresentation];
    return [super preferredInterfaceOrientationForPresentation];
}

@end
