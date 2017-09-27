//
//  UIViewController+Ext.h
//  OrderTracking
//
//  Created by zdjt on 2017/4/5.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Ext)

/** 设置返回按钮 */
- (void)setupBackItem;

/** 返回按钮点击响应 */
- (void)backItemOnClick:(UIBarButtonItem *)item;

@end
