//
//  BaseViewController.m
//  ModelBook
//
//  Created by zdjt on 2017/8/8.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.navigationController.childViewControllers.count>1)
    {
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(0, 0, 50, 44);
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"icon_main_left_back"] forState:UIControlStateNormal];
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"icon_main_left_back"] forState:UIControlStateSelected];
        [_leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBtn];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        /**
         *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
         *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        negativeSpacer.width = -25;
        
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftItem,nil];
    }
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(0, 0, 44, 44);
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.hidden = YES;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    
    UIBarButtonItem *negativeSpacer1 = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                        target:nil action:nil];
    negativeSpacer1.width = -15;
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer1,rightItem];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f)
    {
        /** 设置navigationBar 半透明 */
        [self.navigationController.navigationBar setTranslucent:NO];
    }
}

#pragma mark -  左侧按钮事件
- (void)leftBtnAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -  右侧按钮事件
- (void)rightBtnAction:(UIButton *)btn
{
    
}

@end
