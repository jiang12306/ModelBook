//
//  NSString+Size.m
//  Networking
//
//  Created by zdjt on 2017/1/9.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

/**
 根据字体大小计算字符串size
 
 @param font 字体大小
 @return 字符串size
 */
-(CGSize)sizeWithFont:(UIFont *)font{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}

/**
 根据字体大小计算字符串size
 
 @param font 字体大小
 @param maxW 字符串显示最大长度
 @return 字符串size
 */
-(CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW{
    return [self sizeWithFont:font maxW:maxW maxH:MAXFLOAT];
}

/**
 根据字体大小计算字符串size
 
 @param font 字体大小
 @param maxW 字符串显示最大长度
 @param maxH 字符串显示最大高度
 @return 字符串size
 */
-(CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW maxH:(CGFloat)maxH{
    NSMutableDictionary *attrs=[NSMutableDictionary dictionary];
    attrs[NSFontAttributeName]=font;
    CGSize maxSize=CGSizeMake(maxW, maxH);
    //获得系统版本
    if (SVersion>=7.0) {
        return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        
    }else{
        return [self sizeWithFont:font constrainedToSize:maxSize];
    }
}

@end
