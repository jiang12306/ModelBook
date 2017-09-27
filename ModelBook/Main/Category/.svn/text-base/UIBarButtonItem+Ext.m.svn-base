//
//  UIBarButtonItem+Ext.m
//  TeacherClientProject
//
//  Created by 袁涛 on 16/5/28.
//  Copyright © 2016年 zdjt. All rights reserved.
//

#import "UIBarButtonItem+Ext.h"
#import "UIView+Frame.h"

@implementation UIBarButtonItem (Ext)

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    // 设置尺寸
    btn.size = btn.currentBackgroundImage.size;
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
