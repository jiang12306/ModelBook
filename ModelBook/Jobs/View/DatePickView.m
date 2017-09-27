//
//  DatePickView.m
//  ModelBook
//
//  Created by zdjt on 2017/8/25.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "DatePickView.h"
#import "Const.h"
#import "UIColor+Ext.h"
#import "Masonry.h"

@interface DatePickView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *cancleButton;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet UIPickerView *pickView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeightCons;

@property (strong, nonatomic) NSMutableArray *dateArray;

@property (copy, nonatomic) NSString *dateStr;

@end

@implementation DatePickView

- (NSMutableArray *)dateArray {
    if (!_dateArray) {
        _dateArray = [NSMutableArray array];
    }
    return _dateArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.dateArray removeAllObjects];
    for (int i = 0; i < 31; i++) {
        NSDate *tempDate = [self getPriousorLaterDateFromDate:[NSDate date] withDay:i];
        [self.dateArray addObject:[self getStringFromDate:tempDate]];
    }
    [self.pickView reloadAllComponents];
    [self.pickView selectRow:0 inComponent:0 animated:YES];
    self.dateStr = self.dateArray[0];
}

- (NSString *)getStringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withDay:(NSInteger)day
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.cancleButton setTitle:NSLocalizedString(@"Cancle", nil) forState:UIControlStateNormal];
    self.cancleButton.titleLabel.font = [UIFont fontWithName:buttonFontName size:15.f];
    [self.cancleButton setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [self.confirmButton setTitle:NSLocalizedString(@"Confirm", nil) forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont fontWithName:buttonFontName size:15.f];
    [self.confirmButton setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    
    self.lineViewHeightCons.constant = 0.5f;
    
}

+ (id)dateView
{
    DatePickView *view = [[NSBundle mainBundle] loadNibNamed:@"DatePickView" owner:nil options:nil].firstObject;
    return view;
}
- (void)show:(UIView *)parentView
{
    [parentView addSubview:self];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(parentView);
    }];
    
    //显示动画
    self.contentView.transform = CGAffineTransformTranslate(self.bgView.transform, 0, CGRectGetHeight(self.frame));
    self.bgView.alpha = 0.0f;
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
        self.bgView.alpha = 0.5;
        [self layoutIfNeeded];
    }];
}
- (void)dismiss
{
    self.contentView.transform = CGAffineTransformIdentity;
    self.bgView.alpha = 0.5;
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.3f animations:^{
        self.contentView.transform = CGAffineTransformTranslate(self.bgView.transform, 0, CGRectGetHeight(self.frame));
        self.bgView.alpha = 0.0f;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    [self.pickView selectRow:0 inComponent:0 animated:YES];
}

- (IBAction)cancleButtonEvent:(UIButton *)sender {
    [self dismiss];
}

- (IBAction)confirmButtonEvent:(UIButton *)sender {
    if (self.valueBlock) self.valueBlock(self.dateStr);
    [self dismiss];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dateArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dateArray[row];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.dateStr = self.dateArray[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [UILabel new];
    label.font = [UIFont fontWithName:pageFontName size:14.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHex:0x999999];
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 45.0f;
}

@end
