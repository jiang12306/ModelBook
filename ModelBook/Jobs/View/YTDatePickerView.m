//
//  YTDatePickerView.m
//  DatePicker
//
//  Created by zdjt on 2017/9/13.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "YTDatePickerView.h"
#import <Masonry.h>
#import "UIColor+Ext.h"
#import "Const.h"

@interface YTDatePickerView () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) NSDate *minDate;

@property (strong, nonatomic) NSDate *maxDate;

@property (strong, nonatomic) NSArray *yearList;

@property (strong, nonatomic) NSArray *monthList;

@property (strong, nonatomic) NSArray *dayList;

@property (strong, nonatomic) NSArray *hourList;

@property (assign, nonatomic) NSInteger minYear;

@property (assign, nonatomic) NSInteger maxYear;

@property (assign, nonatomic) NSInteger minMonth;

@property (assign, nonatomic) NSInteger maxMonth;

@property (assign, nonatomic) NSInteger minDay;

@property (assign, nonatomic) NSInteger maxDay;

@property (assign, nonatomic) NSInteger minHour;

@property (assign, nonatomic) NSInteger maxHour;

@property (assign, nonatomic) NSInteger yearRow;

@property (assign, nonatomic) NSInteger monthRow;

@property (assign, nonatomic) NSInteger dayRow;

@property (assign, nonatomic) NSInteger hourRow;

@end

@implementation YTDatePickerView

+ (YTDatePickerView *)datePickerViewWithMinDate:(NSDate *)minDate
{
    YTDatePickerView *view = [[NSBundle mainBundle] loadNibNamed:@"YTDatePickerView" owner:nil options:nil].firstObject;
    if (minDate) {
        view.minDate = minDate;
    }else {
        view.minDate = [NSDate date];
    }
    return view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.pickView.delegate = self;
    self.pickView.dataSource = self;
    
}

- (void)setMinDate:(NSDate *)minDate {
    _minDate = minDate;
    
    NSInteger year = [self getYearFromDate:self.minDate];
    self.maxDate = [self getDateFromString:[NSString stringWithFormat:@"%ld-01-01 12",year + 2]];
    
    [self setupValue];
    [self getDataArray];
    
    [self.pickView reloadAllComponents];
}

#pragma mark - date处理

// 初始化
- (void)setupValue
{
    self.minYear = [self getYearFromDate:self.minDate];
    self.maxYear = [self getYearFromDate:self.maxDate];
    self.minMonth = [self getMonthFromDate:self.minDate];
    self.maxMonth = [self getMonthFromDate:self.maxDate];
    self.minDay = [self getDayFromDate:self.minDate];
    self.maxDay = [self getDayFromDate:self.maxDate];
    self.minHour = [self getHourFromDate:self.minDate];
    self.maxHour = [self getHourFromDate:self.maxDate];
    
    self.yearRow = 0;
    self.monthRow = 0;
    self.dayRow = 0;
    self.hourRow = 0;
}

- (void)getDataArray
{
    self.yearList = [self getYearArrayFromdate:self.minDate ToDate:self.maxDate];
    self.monthList = [self getMonthArrayFromDate:self.minDate];
    self.dayList = [self getDayArrayFromDate:self.minDate];
    self.hourList = [self getHourArrayFromDate:self.minDate];
}

- (NSDate *)getDateFromString:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH"];
    return [dateFormatter dateFromString:dateStr];
}

- (NSDate *)getDateYearFromString:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    return [dateFormatter dateFromString:dateStr];
}

- (NSDate *)getDateYearMonthFromString:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    return [dateFormatter dateFromString:dateStr];
}

- (NSDate *)getDateYearMonthDayFromString:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter dateFromString:dateStr];
}

- (NSInteger )getYearFromDate:(NSDate *)date
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear fromDate:date];
    return comps.year;
}

- (NSInteger )getMonthFromDate:(NSDate *)date
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitMonth fromDate:date];
    return comps.month;
}

- (NSInteger )getDayFromDate:(NSDate *)date
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitDay fromDate:date];
    return comps.day;
}

- (NSInteger)getDaysFromDate:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    dateFormatter.dateFormat=@"yyyy-MM";
    NSDate *date = [dateFormatter dateFromString:dateStr];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSInteger dayNum = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    return dayNum;
}

- (NSInteger )getHourFromDate:(NSDate *)date
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitHour fromDate:date];
    return comps.hour;
}

- (NSArray *)getYearArrayFromdate:(NSDate *)beginDate ToDate:(NSDate *)endDate
{
    NSInteger beginYear = [self getYearFromDate:beginDate];
    NSInteger endYear = [self getYearFromDate:endDate];
    NSMutableArray *years = [NSMutableArray array];
    for (NSInteger i = beginYear; i <= endYear; i++) {
        [years addObject:[NSString stringWithFormat:@"%ld",i]];
    }
    return [years copy];
}

- (NSArray *)getMonthArrayFromDate:(NSDate *)date
{
    NSInteger year = [self getYearFromDate:date];
    NSInteger beginMonth = 0;
    NSInteger endMonth = 0;
    if (year == self.minYear) {
        beginMonth = self.minMonth;
        endMonth = 12;
    }else if (year == self.maxYear) {
        beginMonth = 1;
        endMonth = self.maxMonth;
    } else {
        beginMonth = 1;
        endMonth = 12;
    }
    NSMutableArray *months = [NSMutableArray array];
    for (NSInteger i = beginMonth; i <= endMonth; i++) {
        [months addObject:[NSString stringWithFormat:@"%02ld",i]];
    }
    return [months copy];
}

- (NSArray *)getDayArrayFromDate:(NSDate *)date
{
    NSInteger year = [self getYearFromDate:date];
    NSInteger month = [self getMonthFromDate:date];
    NSInteger beginDay = 0;
    NSInteger endDay = 0;
    if (year == self.minYear) {
        if (month == self.minMonth) {
            beginDay = self.minDay;
            endDay = [self getDaysFromDate:[NSString stringWithFormat:@"%ld-%02ld",year,month]];
        }else {
            beginDay = 1;
            endDay = [self getDaysFromDate:[NSString stringWithFormat:@"%ld-%02ld",year,month]];
        }
    }else if (year == self.maxYear) {
        if (month == self.maxMonth) {
            beginDay = 1;
            endDay = self.maxDay;
        }else {
            beginDay = 1;
            endDay = [self getDaysFromDate:[NSString stringWithFormat:@"%ld-%02ld",year,month]];
        }
    }else {
        beginDay = 1;
        endDay = [self getDaysFromDate:[NSString stringWithFormat:@"%ld-%02ld",year,month]];
    }
    NSMutableArray *days = [NSMutableArray array];
    for (NSInteger i = beginDay; i <= endDay; i++) {
        [days addObject:[NSString stringWithFormat:@"%02ld",i]];
    }
    return [days copy];
}

- (NSArray *)getHourArrayFromDate:(NSDate *)date
{
    NSInteger year = [self getYearFromDate:date];
    NSInteger month = [self getMonthFromDate:date];
    NSInteger day = [self getDayFromDate:date];
    NSInteger beginHour = 0;
    NSInteger endHour = 0;
    if (year == self.minYear) {
        if (month == self.minMonth) {
            if (day == self.minDay) {
                beginHour = self.minHour;
                endHour = 23;
            }else {
                beginHour = 0;
                endHour = 23;
            }
        }else {
            beginHour = 0;
            endHour = 23;
        }
    }else if (year == self.maxYear) {
        if (month == self.maxMonth) {
            if (day == self.maxDay) {
                beginHour = 0;
                endHour = self.maxHour;
            }
        }else {
            beginHour = 0;
            endHour = 23;
        }
    }else {
        beginHour = 0;
        endHour = 23;
    }
    NSMutableArray *hours = [NSMutableArray array];
    for (NSInteger i = beginHour; i <= endHour; i++) {
        [hours addObject:[NSString stringWithFormat:@"%02ld",i]];
    }
    return [hours copy];
}

/**
 *    NSCalendarUnitWeekday
 *     获取指定日期的年，月，日，星期，时,分,秒信息
 */
- (void)getDateInfo:(NSDate *)date
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    
    NSLog(@"年 = year = %ld",comps.year);
    NSLog(@"月 = month = %ld",comps.month);
    NSLog(@"日 = day = %ld",comps.day);
    NSLog(@"时 = hour = %ld",comps.hour);
}

#pragma mark - button事件

- (IBAction)cancleButtonEvent:(UIButton *)sender {
    [self dismiss];
}

- (IBAction)confirmButtonEvent:(UIButton *)sender {
    [self dismiss];
    if (self.valueBlock) self.valueBlock([NSString stringWithFormat:@"%@-%@-%@ %@:00",self.yearList[self.yearRow], self.monthList[self.monthRow], self.dayList[self.dayRow], self.hourList[self.hourRow]]);
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.yearList.count;
    }else if (component == 1) {
        return self.monthList.count;
    }else if (component == 2) {
        return self.dayList.count;
    }else{
        return self.hourList.count;
    }
}
#pragma  UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50.f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [NSString stringWithFormat:@"%@年",self.yearList[row]];
    }else if (component == 1) {
        return [NSString stringWithFormat:@"%@月",self.monthList[row]];
    }else if (component == 2) {
        return [NSString stringWithFormat:@"%@日",self.dayList[row]];
    }else {
        return [NSString stringWithFormat:@"%@时",self.hourList[row]];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.yearRow = row;
        
        NSString *yearStr = self.yearList[row];
        self.monthList = [self getMonthArrayFromDate:[self getDateYearFromString:yearStr]];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:yearStr];
        self.monthRow = 0;
        
        NSString *monthStr = self.monthList.firstObject;
        self.dayList = [self getDayArrayFromDate:[self getDateYearMonthFromString:[NSString stringWithFormat:@"%@-%@",yearStr,monthStr]]];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:yearStr];
        self.dayRow = 0;
        
        NSString *dayStr = self.dayList.firstObject;
        NSDate *date = [self getDateYearMonthDayFromString:[NSString stringWithFormat:@"%@-%@-%@",yearStr,monthStr,dayStr]];
        self.hourList = [self getHourArrayFromDate:date];
        [pickerView reloadComponent:3];
        [pickerView selectRow:0 inComponent:3 animated:yearStr];
        self.hourRow = 0;
    }else if (component == 1) {
        NSString *yearStr = self.yearList[self.yearRow];
        self.monthList = [self getMonthArrayFromDate:[self getDateYearFromString:yearStr]];
        [pickerView reloadComponent:1];
        self.monthRow = row;
        
        NSString *monthStr = self.monthList[row];
        self.dayList = [self getDayArrayFromDate:[self getDateYearMonthFromString:[NSString stringWithFormat:@"%@-%@",yearStr,monthStr]]];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:yearStr];
        self.dayRow = 0;
        
        NSString *dayStr = self.dayList.firstObject;
        NSDate *date = [self getDateYearMonthDayFromString:[NSString stringWithFormat:@"%@-%@-%@",yearStr,monthStr,dayStr]];
        self.hourList = [self getHourArrayFromDate:date];
        [pickerView reloadComponent:3];
        [pickerView selectRow:0 inComponent:3 animated:yearStr];
        self.hourRow = 0;
    }else if (component == 2) {
        self.dayRow = row;
        NSString *yearStr = self.yearList[self.yearRow];
        NSString *monthStr = self.monthList[self.monthRow];
        self.dayList = [self getDayArrayFromDate:[self getDateYearMonthFromString:[NSString stringWithFormat:@"%@-%@",yearStr,monthStr]]];
        [pickerView reloadComponent:2];
        
        NSString *dayStr = self.dayList[row];
        NSDate *date = [self getDateYearMonthDayFromString:[NSString stringWithFormat:@"%@-%@-%@",yearStr,monthStr,dayStr]];
        self.hourList = [self getHourArrayFromDate:date];
        [pickerView reloadComponent:3];
        [pickerView selectRow:0 inComponent:3 animated:yearStr];
        self.hourRow = 0;
    } else if (component == 3) {
        self.hourRow = row;
        NSString *yearStr = self.yearList[self.yearRow];
        NSString *monthStr = self.monthList[self.monthRow];
        NSString *dayStr = self.dayList[self.dayRow];
        NSDate *date = [self getDateYearMonthDayFromString:[NSString stringWithFormat:@"%@-%@-%@",yearStr,monthStr,dayStr]];
        self.hourList = [self getHourArrayFromDate:date];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [UILabel new];
    label.font = [UIFont fontWithName:pageFontName size:14.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHex:0x999999];
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.cancleButton setTitle:NSLocalizedString(@"Cancle", nil) forState:UIControlStateNormal];
    self.cancleButton.titleLabel.font = [UIFont fontWithName:pageFontName size:15.f];
    [self.cancleButton setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [self.confirmButton setTitle:NSLocalizedString(@"Confirm", nil) forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont fontWithName:pageFontName size:15.f];
    [self.confirmButton setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    
    self.lineHeightCons.constant = 0.5f;
}

@end
