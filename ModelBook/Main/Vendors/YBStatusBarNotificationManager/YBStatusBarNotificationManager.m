//
//  YBStatusBarNotificationManager.m
//  cwstatusBar
//
//  Created by mahong on 16/3/4.
//  Copyright © 2016年 mahong. All rights reserved.
//

#import "YBStatusBarNotificationManager.h"
#import <JDStatusBarNotification.h>

static NSString * const YBStyle = @"YBStyle";

@interface YBStatusBarNotificationManager()


@end

@implementation YBStatusBarNotificationManager

+ (instancetype)shareManager
{
    static YBStatusBarNotificationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YBStatusBarNotificationManager alloc] init];
        [JDStatusBarNotification addStyleNamed:YBStyle prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
            style.barColor = [UIColor colorWithRed:0.1694 green:0.1653 blue:0.2204 alpha:1.0];
            style.textColor = [UIColor whiteColor];
            return style;
        }];
    });
    
    return manager;
}

- (void)displayWithText:(NSString *)text
{
    [JDStatusBarNotification showWithStatus:text dismissAfter:3 styleName:YBStyle];
}

- (void)displayWithText:(NSString *)text Duration:(NSTimeInterval)duration
{
    [JDStatusBarNotification showWithStatus:text dismissAfter:duration styleName:YBStyle];
}

- (void)dismiss
{
    [JDStatusBarNotification dismiss];
}


@end
