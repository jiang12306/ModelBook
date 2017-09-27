//
//  Handler.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Handler : NSObject

/**
 根据内容获取文字宽度
 
 @param string 文本内容
 @param width 最大宽度
 @param font 字体
 @return 文字宽度
 */
+ (CGFloat)widthForString:(NSString *)string width:(CGFloat)width FontSize:(UIFont *)font;

/**
 获取文本高度
 
 @param string 文本
 @param width 最大宽度
 @param font 字体
 @return 文本高度
 */
+ (CGFloat)heightForString:(NSString *)string width:(CGFloat)width FontSize:(UIFont *)font;

/**
 时间戳转日期字符串

 @param timeStamp 时间戳
 @param format 显示格式
 @return 日期字符串
 */
+ (NSString *)dateStrFromCstampTime:(NSString *)timeStamp withDateFormat:(NSString *)format;

+ (NSString *)datestrFromDate:(NSDate *)date
               withDateFormat:(NSString *)format;

/**
 处理工作时长

 @param beginTime 开始时间
 @param endTime 结束时间
 @return 时长
 */

/**
 处理工作时长

 @param beginTime 开始时间
 @param endTime 结束时间
 @param chargeType 类型：时薪/日薪
 @return 时长
 */
+ (int)handlerJobTime:(NSString *)beginTime endTime:(NSString *)endTime chargeType:(NSString *)chargeType;

/**
 处理显示用户类型（摄影师/化妆师=12，模特=3，网红=4）

 @param userType 用户类型字符串
 @return 处理过后的字符串
 */
+ (NSString *)handlerUserTypeStr:(NSString *)userType;

/* 获取当前屏幕显示的viewcontroller */
+ (UIViewController *)topViewController;

+ (NSString *)generateTradeNO;

/**
 *  将数组转化为json字符串
 *
 *  @return json字符串
 */
- (NSString *)convertToJson:(NSArray *)array;

+ (NSData*)imageCompress:(UIImage*)image;

@end
