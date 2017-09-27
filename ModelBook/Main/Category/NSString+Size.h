//
//  NSString+Size.h
//  Networking
//
//  Created by zdjt on 2017/1/9.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SVersion [[UIDevice currentDevice].systemVersion doubleValue]

@interface NSString (Size)

/**
 根据字体大小计算字符串size
 
 @param font 字体大小
 @return 字符串size
 */
-(CGSize)sizeWithFont:(UIFont *)font;

/**
 根据字体大小计算字符串size

 @param font 字体大小
 @param maxW 字符串显示最大长度
 @return 字符串size
 */
-(CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

/**
 根据字体大小计算字符串size

 @param font 字体大小
 @param maxW 字符串显示最大长度
 @param maxH 字符串显示最大高度
 @return 字符串size
 */
-(CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW maxH:(CGFloat)maxH;

@end
