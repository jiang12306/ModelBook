//
//  UIImage+Ext.m
//  Networking
//
//  Created by zdjt on 2017/1/9.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "UIImage+Ext.h"

@implementation UIImage (Ext)

/**
 根据图片绘制图片
 
 @param color 图片颜色
 @return 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color {
    // 描述矩形
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}

/**
 裁剪图片（圆形头像）

 @param imageName 图片名称
 @param imageSize 裁剪图片大小
 @return 裁剪后的圆形图片
 */
+ (UIImage *)clipImageWithName:(NSString *)imageName size:(CGSize)imageSize {
    UIImage *image = [UIImage imageNamed:imageName];
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGRect rect = (CGRect){CGPointZero,imageSize};
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    [clipPath addClip];
    [image drawInRect:rect];
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return clipImage;
}
@end
