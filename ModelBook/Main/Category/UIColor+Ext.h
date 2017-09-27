//
//  UIColor+Ext.h
//  Networking
//
//  Created by zdjt on 2017/1/9.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Ext)

/**
 十六进制颜色

 @param hex 十六进制颜色值
 @return 颜色
 */
+ (UIColor *)colorWithHex:(NSInteger)hex;

/**
 十六进制颜色

 @param hex 十六进制颜色值
 @param alpha 透明度
 @return 颜色
 */
+ (UIColor *)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha;

/**
 十六进制颜色

 @param color 十六进制颜色值
 @return 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

/**
 十六进制颜色

 @param color 十六进制颜色值
 @param alpha 透明度
 @return 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
