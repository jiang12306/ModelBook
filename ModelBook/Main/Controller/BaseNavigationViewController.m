//
//  BaseNavigationViewController.m
//  ModelBook
//
//  Created by zdjt on 2017/8/7.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "BaseNavigationViewController.h"
#import "UIImage+Ext.h"
#import "UIColor+Ext.h"
#import "Const.h"
#import "ProfileViewController.h"
#import "HomeViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage imageNamed:@"nav_line_l"]];
    [self.navigationBar setTranslucent:NO];
    
    // 设置tabBarItem
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:pageFontName size:14.f],NSForegroundColorAttributeName:[UIColor colorWithHex:0x999999]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithHex:0x000000]];
    
    // 设置tabBarTitle
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:pageFontName size:16.f],NSForegroundColorAttributeName:[UIColor colorWithHex:0x000000]}];
    
    // 开启侧滑
    self.interactivePopGestureRecognizer.delegate = self;
}

/**
 *  重写这个方法目的：能够拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        if ([self.viewControllers[0] isKindOfClass:[HomeViewController class]]&&[viewController isKindOfClass:[ProfileViewController class]]) {
            viewController.hidesBottomBarWhenPushed = NO;
            self.navigationBar.hidden = NO;
        }else{
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        [self hideTabBar];
        }
    }
    [super pushViewController:viewController animated:animated];
}

/**
 *  隐藏TabBar
 */
- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = YES;
    
}

@end
