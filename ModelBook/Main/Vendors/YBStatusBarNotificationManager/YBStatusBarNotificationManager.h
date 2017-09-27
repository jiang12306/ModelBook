
/**
 *! 文件基本描述信息
 
 * @header YBStatusBarNotificationManager.h
 
 * @project cwstatusBar
 
 * @abstract 通知栏
 
 * @author Created by mahong on 16/3/4.
 
   Copyright © 2016年 mahong. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface YBStatusBarNotificationManager : NSObject

+ (instancetype)shareManager;

- (void)displayWithText:(NSString *)text;

- (void)displayWithText:(NSString *)text Duration:(NSTimeInterval)duration;

- (void)dismiss;

@end
