//
//  UIView+Frame.h
//  Networking
//
//  Created by zdjt on 2017/1/6.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)
/**
 *  originX
 */
@property(nonatomic,assign)CGFloat x;
/**
 *  originY
 */
@property(nonatomic,assign)CGFloat y;
/**
 *  sizeW
 */
@property(nonatomic,assign)CGFloat width;
/**
 *  sizeH
 */
@property(nonatomic,assign)CGFloat height;
/**
 *  size
 */
@property(nonatomic,assign)CGSize size;
/**
 *  orign
 */
@property(nonatomic,assign)CGPoint origin;
/**
 *  centerX
 */
@property(nonatomic,assign)CGFloat centerX;
/**
 *  centerY
 */
@property(nonatomic,assign)CGFloat centerY;

//- (CGFloat)x;
//- (void)setX:(CGFloat)x;
/** 在分类中声明@property, 只会生成方法的声明, 不会生成方法的实现和带有_下划线的成员变量*/
@end
