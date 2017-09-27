//
//  ChooseTimeViewController.m
//  ModelBook
//
//  Created by hinata on 2017/8/26.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ChooseTimeViewController.h"
#import "TriangleView.h"

@interface ChooseTimeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (weak, nonatomic) IBOutlet UIButton *timeOneButton;

@property (weak, nonatomic) IBOutlet UIButton *timeTwoButton;

@property (weak, nonatomic) IBOutlet UIButton *timeThreeButton;

@property (weak, nonatomic) IBOutlet UIButton *timeFourButton;

@property (weak, nonatomic) IBOutlet UIButton *timeFiveButton;

@property (weak, nonatomic) IBOutlet UIButton *amButton;

@property (weak, nonatomic) IBOutlet UIButton *pmButton;

@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@property (strong, nonatomic) NSMutableArray *dateArray;

@property (strong, nonatomic) UIButton *selectedButton;

@property (weak, nonatomic) IBOutlet TriangleView *triangleView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineOneHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTwoHeightCons;

@end

@implementation ChooseTimeViewController

- (NSMutableArray *)dateArray {
    if (!_dateArray) {
        _dateArray = [NSMutableArray array];
    }
    return _dateArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Choose Time", nil);
    
    [self setupBackItem];
    
    self.desLabel.text = NSLocalizedString(@"Book Day", nil);
    self.desLabel.font = [UIFont fontWithName:pageFontName size:15.f];
    
    self.lineOneHeightCons.constant = 0.5f;
    self.lineTwoHeightCons.constant = 0.5f;
    
    [self.amButton setTitle:NSLocalizedString(@"AM", nil) forState:UIControlStateNormal];
    self.amButton.titleLabel.font = [UIFont fontWithName:pageFontName size:14.f];
    [self.amButton setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [self.amButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.amButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.amButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x79AAF6]] forState:UIControlStateSelected];
    self.amButton.layer.cornerRadius = 3.f;
    self.amButton.layer.borderWidth = 0.5f;
    self.amButton.layer.borderColor = [UIColor colorWithHex:0x999999].CGColor;
    self.amButton.layer.masksToBounds = YES;
    
    [self.pmButton setTitle:NSLocalizedString(@"PM", nil) forState:UIControlStateNormal];
    [self.pmButton setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [self.pmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.pmButton.titleLabel.font = [UIFont fontWithName:pageFontName size:14.f];
    [self.pmButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.pmButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x79AAF6]] forState:UIControlStateSelected];
    self.pmButton.layer.cornerRadius = 3.f;
    self.pmButton.layer.borderWidth = 0.5f;
    self.pmButton.layer.borderColor = [UIColor colorWithHex:0x999999].CGColor;
    self.pmButton.layer.masksToBounds = YES;
    
    self.timeOneButton.titleLabel.numberOfLines = 0;
    self.timeOneButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.timeOneButton.titleLabel.font = [UIFont fontWithName:pageFontName size:13.f];
    [self.timeOneButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xd9d9d9]] forState:UIControlStateNormal];
    [self.timeOneButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x79AAF6]] forState:UIControlStateSelected];
    [self.timeOneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.timeOneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    self.timeTwoButton.titleLabel.numberOfLines = 0;
    self.timeTwoButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.timeTwoButton.titleLabel.font = [UIFont fontWithName:pageFontName size:13.f];
    [self.timeTwoButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xd9d9d9]] forState:UIControlStateNormal];
    [self.timeTwoButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x79AAF6]] forState:UIControlStateSelected];
    [self.timeTwoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.timeTwoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    self.timeThreeButton.titleLabel.numberOfLines = 0;
    self.timeThreeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.timeThreeButton.titleLabel.font = [UIFont fontWithName:pageFontName size:13.f];
    [self.timeThreeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xd9d9d9]] forState:UIControlStateNormal];
    [self.timeThreeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x79AAF6]] forState:UIControlStateSelected];
    [self.timeThreeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.timeThreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    self.timeFourButton.titleLabel.numberOfLines = 0;
    self.timeFourButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.timeFourButton.titleLabel.font = [UIFont fontWithName:pageFontName size:13.f];
    [self.timeFourButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xd9d9d9]] forState:UIControlStateNormal];
    [self.timeFourButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x79AAF6]] forState:UIControlStateSelected];
    [self.timeFourButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.timeFourButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    self.timeFiveButton.titleLabel.numberOfLines = 0;
    self.timeFiveButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.timeFiveButton.titleLabel.font = [UIFont fontWithName:pageFontName size:13.f];
    [self.timeFiveButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0xd9d9d9]] forState:UIControlStateNormal];
    [self.timeFiveButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x79AAF6]] forState:UIControlStateSelected];
    [self.timeFiveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.timeFiveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    self.continueButton.layer.cornerRadius = 3.f;
    self.continueButton.layer.masksToBounds = YES;
    self.continueButton.titleLabel.font = [UIFont fontWithName:pageFontName size:18.f];
    [self.continueButton setTitle:NSLocalizedString(@"Continue", nil) forState:UIControlStateNormal];
    
    for (int i = 0; i < 5; i++) {
        NSDate *tempDate = [self getPriousorLaterDateFromDate:[NSDate date] withDay:i];
        [self.dateArray addObject:tempDate];
    }
    
    [self.timeOneButton setTitle:[NSString stringWithFormat:@"%@\n%@",[self getWeekFromDate:self.dateArray[0]], [self getStringFromDate:self.dateArray[0]]] forState:UIControlStateNormal];
    [self.timeTwoButton setTitle:[NSString stringWithFormat:@"%@\n%@",[self getWeekFromDate:self.dateArray[1]], [self getStringFromDate:self.dateArray[1]]] forState:UIControlStateNormal];
    [self.timeThreeButton setTitle:[NSString stringWithFormat:@"%@\n%@",[self getWeekFromDate:self.dateArray[2]], [self getStringFromDate:self.dateArray[2]]] forState:UIControlStateNormal];
    [self.timeFourButton setTitle:[NSString stringWithFormat:@"%@\n%@",[self getWeekFromDate:self.dateArray[3]], [self getStringFromDate:self.dateArray[3]]] forState:UIControlStateNormal];
    [self.timeFiveButton setTitle:[NSString stringWithFormat:@"%@\n%@",[self getWeekFromDate:self.dateArray[4]], [self getStringFromDate:self.dateArray[4]]] forState:UIControlStateNormal];
    
    self.timeOneButton.selected = YES;
    self.selectedButton = self.timeOneButton;
    
    self.amButton.selected = YES;
    
}

#pragma mark - Event

- (IBAction)timeButtonEvent:(UIButton *)sender {
    [self onlyOneBtnSelected:sender];
    [UIView animateWithDuration:0.1f animations:^{
        self.triangleView.centerX = sender.centerX;
    }];
}

- (IBAction)amButtonEvent:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.pmButton.selected = !sender.selected;
    if (sender.selected) {
        sender.layer.cornerRadius = 3.f;
        sender.layer.borderWidth = 0.5f;
        sender.layer.borderColor = [UIColor whiteColor].CGColor;
        self.pmButton.layer.cornerRadius = 3.f;
        self.pmButton.layer.borderWidth = 0.5f;
        self.pmButton.layer.borderColor = [UIColor colorWithHex:0x999999].CGColor;
        self.pmButton.layer.masksToBounds = YES;
    }else {
        sender.layer.cornerRadius = 3.f;
        sender.layer.borderWidth = 0.5f;
        sender.layer.borderColor = [UIColor colorWithHex:0x999999].CGColor;
        self.pmButton.layer.cornerRadius = 3.f;
        self.pmButton.layer.borderWidth = 0.5f;
        self.pmButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.pmButton.layer.masksToBounds = YES;
    }
}

- (IBAction)pmButtonEvent:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.amButton.selected = !sender.selected;
    if (sender.selected) {
        sender.layer.cornerRadius = 3.f;
        sender.layer.borderWidth = 0.5f;
        sender.layer.borderColor = [UIColor whiteColor].CGColor;
        sender.layer.masksToBounds = YES;
        self.amButton.layer.cornerRadius = 3.f;
        self.amButton.layer.borderWidth = 0.5f;
        self.amButton.layer.borderColor = [UIColor colorWithHex:0x999999].CGColor;
        self.amButton.layer.masksToBounds = YES;
    }else {
        sender.layer.cornerRadius = 3.f;
        sender.layer.borderWidth = 0.5f;
        sender.layer.borderColor = [UIColor colorWithHex:0x999999].CGColor;
        sender.layer.masksToBounds = YES;
        self.amButton.layer.cornerRadius = 3.f;
        self.amButton.layer.borderWidth = 0.5f;
        self.amButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.amButton.layer.masksToBounds = YES;
    }
}

- (IBAction)continueButtonEvent:(UIButton *)sender {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [format stringFromDate:self.dateArray[self.selectedButton.tag - 1]];
    NSString *time = self.amButton.isSelected ? @"上午" : @"下午";
    if (self.valueBlock) self.valueBlock(time, date);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Func

- (NSString *)getStringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

- (NSString *)getWeekFromDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger weekday = [comps weekday];
    NSString *week = @"";
    switch (weekday) {
        case 1:
            week = @"星期日";
            break;
        case 2:
            week = @"星期一";
            break;
        case 3:
            week = @"星期二";
            break;
        case 4:
            week = @"星期三";
            break;
        case 5:
            week = @"星期四";
            break;
        case 6:
            week = @"星期五";
            break;
        case 7:
            week = @"星期六";
            break;
        default:
            break;
    }
    return week;
}

-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withDay:(NSInteger)day
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

/**
 *  选中状态,一个selected，其他normal
 *
 *  @param btn 当前选中的btn
 */
-(void)onlyOneBtnSelected:(UIButton *)btn{
    if (btn!=self.selectedButton) {
        self.selectedButton.selected = NO;
        self.selectedButton = btn;
    }
    self.selectedButton.selected=YES;
}

@end
