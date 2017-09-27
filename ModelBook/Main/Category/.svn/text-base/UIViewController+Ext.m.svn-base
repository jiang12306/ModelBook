//
//  UIViewController+Ext.m
//  OrderTracking
//
//  Created by zdjt on 2017/4/5.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "UIViewController+Ext.h"

@implementation UIViewController (Ext)

/** 设置返回按钮 */
- (void)setupBackItem
{
//    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"backpage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backItemOnClick:)];
//    self.navigationItem.leftBarButtonItem = backItem;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 50, 44);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"icon_main_left_back"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"icon_main_left_back"] forState:UIControlStateSelected];
    [leftBtn addTarget:self action:@selector(backItemOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
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

/** 返回按钮点击响应 */
- (void)backItemOnClick:(UIBarButtonItem *)item
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
