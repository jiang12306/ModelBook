//
//  DatePickView.h
//  ModelBook
//
//  Created by zdjt on 2017/8/25.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickView : UIView

+ (id)dateView;
- (void)show:(UIView *)parentView;
- (void)dismiss;

@property (copy, nonatomic) void(^valueBlock)(NSString *text);

@property (strong, nonatomic) NSDate *beginDate;

@end
