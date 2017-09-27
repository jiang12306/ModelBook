//
//  TriangleView.m
//  ModelBook
//
//  Created by hinata on 2017/8/26.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "TriangleView.h"
#import "UIView+Frame.h"
#import "UIColor+Ext.h"

@implementation TriangleView

- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // 1.获取图形上下文
    CGContextRef ctx =  UIGraphicsGetCurrentContext();
    // 2. 绘制三角形
    // 设置起点
    CGContextMoveToPoint(ctx, self.width * 0.5 , 0);
    // 设置第二个点
    CGContextAddLineToPoint(ctx, self.width, self.height);
    // 设置第三个点
    CGContextAddLineToPoint(ctx, 0, self.height);
    // 关闭起点和终点
    CGContextClosePath(ctx);
    // 填充颜色
    if (self.fillColor) {
        CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
    }else {
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithHex:0x79AAF6].CGColor);
    }
    // 3.渲染图形到layer上
    CGContextFillPath(ctx);
}

@end
