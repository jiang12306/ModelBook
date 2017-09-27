//
//  YTDatePickerView.h
//  DatePicker
//
//  Created by zdjt on 2017/9/13.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTDatePickerView : UIView

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIPickerView *pickView;


@property (weak, nonatomic) IBOutlet UIButton *cancleButton;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeightCons;

@property (copy, nonatomic) void(^valueBlock)(NSString *dateStr);


+ (YTDatePickerView *)datePickerViewWithMinDate:(NSDate *)minDate;
- (void)show:(UIView *)parentView;
- (void)dismiss;

@end
