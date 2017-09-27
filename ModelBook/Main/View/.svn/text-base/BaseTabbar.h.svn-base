//
//  BaseTabbar.h
//  ModelBook
//
//  Created by Lee on 2017/9/26.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseTabbar;

//MyTabBar的代理必须实现addButtonClick，以响应中间按钮的点击事件
@protocol MyTabBarDelegate <NSObject>
-(void)addButtonClick:(BaseTabbar *)tabBar;
@end

@interface BaseTabbar : UITabBar
//代理
@property (nonatomic,weak) id<MyTabBarDelegate> myTabBarDelegate;
@end
