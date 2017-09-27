//
//  UIView+Frame.m
//  Networking
//
//  Created by zdjt on 2017/1/6.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
/**
 *  originX
 */
- (void)setX:(CGFloat)x {
    CGRect frame=self.frame;
    frame.origin.x=x;
    self.frame=frame;
}
- (CGFloat)x {
    return self.frame.origin.x;
}

/**
 *  originY
 */
- (void)setY:(CGFloat)y {
    CGRect frame=self.frame;
    frame.origin.x=y;
    self.frame=frame;
}
- (CGFloat)y {
    return self.frame.origin.y;
}

/**
 *  sizeW
 */
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)width {
    return self.frame.size.width;
}

/**
 *  sizeH
 */
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)height {
    return self.frame.size.height;
}

/**
 *  size
 */
-(void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)size {
    return self.frame.size;
}

/**
 *  orign
 */
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)origin {
    return self.frame.origin;
}

/**
 *  centerX
 */
- (void)setCenterX:(CGFloat)centerX {
    CGPoint center=self.center;
    center.x=centerX;
    self.center=center;
}
- (CGFloat)centerX {
    return self.center.x;
}

/**
 *  centerY
 */
- (void)setCenterY:(CGFloat)centerY {
    CGPoint center=self.center;
    center.y=centerY;
    self.center=center;
}
- (CGFloat)centerY {
    return self.center.y;
}

@end
