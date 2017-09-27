//
//  JobCreateViewController.m
//  ModelBook
//
//  Created by zdjt on 2017/8/23.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "JobCreateViewController.h"
#import "SZTextView.h"
#import "HcdDateTimePickerView.h"
#import "PersonInfoAddressViewController.h"
#import "NeedView.h"
#import "PriceView.h"
#import "PhotoPickerViewController.h"
#import "DatePickView.h"
#import "ChooseTimeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "PriceTypeView.h"
#import "ProfileViewController.h"
#import "PhotoWallView.h"
#import "MBOrderPayController.h"
#import "Handler.h"
#import "MBOrderPaySuccessController.h"
#import "ProgressHUD.h"
#import "WalletViewController.h"
#import "MBProfileMyJobsDetailController.h"
#import "YTDatePickerView.h"
#import "Handler.h"
#import "UpYunFormUploader.h"
#import "MBPayHandler.h"

@interface JobCreateViewController () <UITextFieldDelegate,PhotoPickerViewControllerDelegate, CLLocationManagerDelegate, PhotoPickerViewControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *postButton;

@property (weak, nonatomic) UITextField *beginTextField;
@property (weak, nonatomic) UITextField *endTextField;
@property (weak, nonatomic) UITextField *locationTextField;
@property (weak, nonatomic) UITextField *priceTextField;
@property (weak, nonatomic) UITextField *nameTextField;
@property (weak, nonatomic) UITextField *needTextField;
@property (weak, nonatomic) UITextField *numTextField;
@property (weak, nonatomic) UILabel *numLabel;
@property (weak, nonatomic) SZTextView *desTextView;

@property (strong, nonatomic) HcdDateTimePickerView * dateTimePickerView;

@property (weak, nonatomic) UITextField *choosedTextField;

@property (strong, nonatomic) NeedView *needView;

@property (strong, nonatomic) PriceView *priceView;

@property (strong, nonatomic) DatePickView *dateView;

@property (copy, nonatomic) NSString *type;

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (nonatomic, strong) CLGeocoder *geoC;
@property (strong, nonatomic) CLLocation *location;

@property (weak, nonatomic) UIImageView *typeImageView;

@property (weak, nonatomic) UILabel *typeLabel;
@property (strong, nonatomic) PriceTypeView *typeView;

@property (copy, nonatomic) NSString *ratetype;

@property (strong, nonatomic) PhotoWallView *photoView;

@property (strong, nonatomic) NSArray *dataSource;

/* 当前订单号 */
@property(nonatomic, strong)NSString *tradeNO;

@property (assign, nonatomic) CGFloat totalPrice;

@property (assign, nonatomic) int picCount;

@property (weak, nonatomic) UIButton *typeButton;

@end

@implementation JobCreateViewController

+ (JobCreateViewController *)instantiateJobCreateViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Jobs" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:@"JobCreateVCSBID"];
}

- (PriceTypeView *)typeView {
    if (!_typeView) {
        _typeView = [PriceTypeView typeView];
    }
    return _typeView;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

-(CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}

- (NeedView *)needView {
    if (!_needView) {
        _needView = [NeedView needView];
    }
    return _needView;
}

- (PriceView *)priceView {
    if (!_priceView) {
        _priceView = [PriceView priceView];
    }
    return _priceView;
}

- (DatePickView *)dateView {
    if (!_dateView) {
        _dateView = [DatePickView dateView];
    }
    return _dateView;
}

- (HcdDateTimePickerView *)dateTimePickerView {
    if (!_dateTimePickerView) {
        _dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateHourMode defaultDateTime:[NSDate date]];
        [_dateTimePickerView setMinYear:[self getYearFromDate:[NSDate date]]];
        [_dateTimePickerView setMaxYear:[self getYearFromDate:[NSDate date]] + 5];
    }
    [self.navigationController.view addSubview:_dateTimePickerView];
    [_dateTimePickerView showHcdDateTimePicker];
    return _dateTimePickerView;
}
- (NSComparisonResult)compareDateWithBeginDate:(NSString *)beginStr EndDate:(NSString *)endStr
{
    // 时间字符串
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH";
    NSDate *beginDate = [fmt dateFromString:beginStr];
    NSDate *endDate = [fmt dateFromString:endStr];
    NSComparisonResult result = [beginDate compare:endDate];
    return result;
}

- (NSInteger)getYearFromDate:(NSDate *)date
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    return comps.year;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    tLabel.textAlignment = NSTextAlignmentCenter;
    tLabel.font = [UIFont fontWithName:pageFontName size:16.f];
    tLabel.text = NSLocalizedString(@"Create Job", nil);
    self.navigationItem.titleView = tLabel;
    
    [self setupBackItem];
    
    [self setupContent];
    
    self.postButton.layer.cornerRadius = 3.f;
    self.postButton.layer.masksToBounds = YES;
    [self.postButton setTitle:NSLocalizedString(@"Post", nil) forState:UIControlStateNormal];
    self.postButton.titleLabel.font = [UIFont fontWithName:buttonFontName size:18.f];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    [self.scrollView addGestureRecognizer:tap];
    
    self.ratetype = @"1";
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderPaySuccessNotification:) name:alipayOrderPaySuccessNotification object:nil];
}

- (void)setupContent
{
    CGFloat textFieldW = 120.f;
    CGFloat space = -30.f;
    
    UITextField *nameTextField = [UITextField new];
    self.nameTextField = nameTextField;
    nameTextField.placeholder = NSLocalizedString(@"Job Name", nil);
    nameTextField.font = [UIFont fontWithName:pageFontName size:12.f];
    nameTextField.textColor = [UIColor colorWithHex:0x999999];
    nameTextField.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:nameTextField];
    [nameTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView.mas_centerX);
        make.top.equalTo(self.scrollView.mas_top).offset(10.f);
        make.height.mas_equalTo(30.f);
        make.width.mas_equalTo(textFieldW);
    }];
    
    UILabel *locationLabel = [UILabel new];
    locationLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    locationLabel.textColor = [UIColor blackColor];
    locationLabel.text = NSLocalizedString(@"Location", nil);
    [self.scrollView addSubview:locationLabel];
    [locationLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top).offset(55.f);
        make.left.equalTo(self.scrollView.mas_left).offset(40.f);
        make.height.equalTo(nameTextField.mas_height);
    }];
    UITextField *locationTextField = [UITextField new];
    self.locationTextField = locationTextField;
    locationTextField.placeholder = NSLocalizedString(@"Location", nil);
    locationTextField.font = [UIFont fontWithName:pageFontName size:12.f];
    locationTextField.textColor = [UIColor colorWithHex:0x999999];
    [self.scrollView addSubview:locationTextField];
    [locationTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [locationTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(locationLabel);
        make.left.equalTo(self.scrollView.mas_centerX).offset(space);
        make.width.mas_equalTo(textFieldW);
        make.height.equalTo(nameTextField.mas_height);
    }];
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationButton setImage:[UIImage imageNamed:@"loca"] forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(getLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:locationButton];
    [locationButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(locationTextField.mas_centerY);
        make.left.equalTo(locationTextField.mas_right);
        make.size.mas_equalTo(CGSizeMake(30.f, 20.f));
    }];
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setImage:[UIImage imageNamed:@"arrow-right"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(locationEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:nextButton];
    [nextButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(locationTextField);
        make.left.equalTo(locationButton.mas_right);
        make.size.mas_equalTo(CGSizeMake(20.f, 20.f));
    }];
    
    UILabel *beginLabel = [UILabel new];
    beginLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    beginLabel.textColor = [UIColor blackColor];
    beginLabel.text = NSLocalizedString(@"Start", nil);
    [self.scrollView addSubview:beginLabel];
    [beginLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [beginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(locationLabel.mas_bottom);
        make.left.equalTo(locationLabel.mas_left);
        make.height.equalTo(locationLabel.mas_height);
    }];
    UITextField *beginTextField = [UITextField new];
    self.beginTextField = beginTextField;
    beginTextField.placeholder = NSLocalizedString(@"Start", nil);
    beginTextField.font = [UIFont fontWithName:pageFontName size:12.f];
    beginTextField.textColor = [UIColor colorWithHex:0x999999];
    beginTextField.delegate = self;
    [self.scrollView addSubview:beginTextField];
    [beginTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [beginTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(beginLabel);
        make.left.equalTo(self.scrollView.mas_centerX).offset(space);
        make.width.mas_equalTo(textFieldW);
        make.height.equalTo(nameTextField.mas_height);
    }];
    
    UILabel *endLabel = [UILabel new];
    endLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    endLabel.textColor = [UIColor blackColor];
    endLabel.text = NSLocalizedString(@"End", nil);
    [self.scrollView addSubview:endLabel];
    [endLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(beginLabel.mas_bottom);
        make.left.equalTo(beginLabel.mas_left);
        make.height.equalTo(beginLabel.mas_height);
    }];
    UITextField *endTextField = [UITextField new];
    self.endTextField = endTextField;
    endTextField.placeholder = NSLocalizedString(@"End", nil);
    endTextField.font = [UIFont fontWithName:pageFontName size:12.f];
    endTextField.textColor = [UIColor colorWithHex:0x999999];
    endTextField.delegate = self;
    [self.scrollView addSubview:endTextField];
    [endTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [endTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(endLabel);
        make.left.equalTo(self.scrollView.mas_centerX).offset(space);
        make.width.mas_equalTo(textFieldW);
        make.height.equalTo(nameTextField.mas_height);
    }];
    
    UILabel *needLabel = [UILabel new];
    needLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    needLabel.textColor = [UIColor blackColor];
    needLabel.text = NSLocalizedString(@"Category", nil);
    [self.scrollView addSubview:needLabel];
    [needLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [needLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(endLabel.mas_bottom);
        make.left.equalTo(endLabel.mas_left);
        make.height.equalTo(endLabel.mas_height);
    }];
    UITextField *needTextField = [UITextField new];
    self.needTextField = needTextField;
    needTextField.placeholder = NSLocalizedString(@"Category", nil);
    needTextField.font = [UIFont fontWithName:pageFontName size:12.f];
    needTextField.textColor = [UIColor colorWithHex:0x999999];
    needTextField.delegate = self;
    [self.scrollView addSubview:needTextField];
    [needTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [needTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(needLabel);
        make.left.equalTo(self.scrollView.mas_centerX).offset(space);
        make.width.mas_equalTo(textFieldW);
        make.height.equalTo(nameTextField.mas_height);
    }];
    
    UILabel *numLabel = [UILabel new];
    self.numLabel = numLabel;
    numLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    numLabel.textColor = [UIColor blackColor];
    numLabel.text = NSLocalizedString(@"Numbers", nil);
    [self.scrollView addSubview:numLabel];
    [numLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(needLabel.mas_bottom);
        make.left.equalTo(needLabel.mas_left);
        make.height.equalTo(needLabel.mas_height);
    }];
    UITextField *numTextField = [UITextField new];
    self.numTextField = numTextField;
    numTextField.keyboardType = UIKeyboardTypeNumberPad;
    numTextField.placeholder = NSLocalizedString(@"Number of Girls needed", nil);
    numTextField.font = [UIFont fontWithName:pageFontName size:12.f];
    numTextField.textColor = [UIColor colorWithHex:0x999999];
    numTextField.delegate = self;
    [self.scrollView addSubview:numTextField];
    [numTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [numTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numLabel);
        make.left.equalTo(self.scrollView.mas_centerX).offset(space);
        make.width.mas_equalTo(textFieldW);
        make.height.equalTo(nameTextField.mas_height);
    }];
    
    UILabel *priceLabel = [UILabel new];
    priceLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    priceLabel.textColor = [UIColor blackColor];
    priceLabel.text = NSLocalizedString(@"Rate", nil);
    [self.scrollView addSubview:priceLabel];
    [priceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([self.controllerFrom isEqualToString:@"profile"]) {
            make.top.equalTo(needLabel.mas_bottom);
        }else {
            make.top.equalTo(needLabel.mas_bottom).offset(30);
        }
        make.left.equalTo(needLabel.mas_left);
        make.height.equalTo(needLabel.mas_height);
    }];
    UITextField *priceTextField = [UITextField new];
    self.priceTextField = priceTextField;
    priceTextField.keyboardType = UIKeyboardTypeNumberPad;
    priceTextField.delegate = self;
    priceTextField.placeholder = NSLocalizedString(@"Rate", nil);
    priceTextField.font = [UIFont fontWithName:pageFontName size:12.f];
    priceTextField.textColor = [UIColor colorWithHex:0x999999];
    [self.scrollView addSubview:priceTextField];
    [priceTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [priceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceLabel);
        make.left.equalTo(self.scrollView.mas_centerX).offset(space);
        make.width.mas_equalTo(textFieldW * 0.5 + 30);
        make.height.equalTo(nameTextField.mas_height);
    }];
    UILabel *typeLabel = [UILabel new];
    self.typeLabel = typeLabel;
    typeLabel.textColor = [UIColor colorWithHex:0x999999];
    typeLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.text = NSLocalizedString(@"Day Rate", nil);
    [self.scrollView addSubview:typeLabel];
    [typeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceTextField.mas_centerY);
        make.left.equalTo(priceTextField.mas_right);
        make.size.mas_equalTo(CGSizeMake(60.f, 20.f));
    }];
    UIImageView *typeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downarrow"]];
    self.typeImageView = typeImageView;
    [self.scrollView addSubview:typeImageView];
    [typeImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceLabel.mas_centerY);
        make.left.equalTo(typeLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(12.f, 12.f));
    }];
    UIButton *typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.typeButton = typeButton;
    [typeButton addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:typeButton];
    [typeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [typeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceLabel.mas_centerY);
        make.left.equalTo(priceTextField.mas_right);
        make.size.mas_equalTo(CGSizeMake(55.f, 20.f));
    }];
    UILabel *plabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    plabel.font = [UIFont fontWithName:pageFontName size:12.f];
    plabel.textColor = [UIColor colorWithHex:0x999999];
    plabel.text = @"元";
    plabel.textAlignment = NSTextAlignmentCenter;
    priceTextField.rightView = plabel;
    priceTextField.rightViewMode = UITextFieldViewModeAlways;
    
    UILabel *desLabel = [UILabel new];
    desLabel.font = [UIFont fontWithName:pageFontName size:12.f];
    desLabel.textColor = [UIColor blackColor];
    desLabel.text = NSLocalizedString(@"Description", nil);
    [self.scrollView addSubview:desLabel];
    [desLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceLabel.mas_bottom);
        make.left.equalTo(priceLabel.mas_left);
        make.height.equalTo(priceLabel.mas_height);
    }];
    SZTextView *desTextView = [[SZTextView alloc] init];
    self.desTextView = desTextView;
    desTextView.delegate = self;
    desTextView.placeholder = NSLocalizedString(@"Description", nil);
    desTextView.font = [UIFont fontWithName:pageFontName size:12.f];
    desTextView.textColor = [UIColor colorWithHex:0x999999];
    [self.scrollView addSubview:desTextView];
    [desTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [desTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(desLabel.mas_left);
        make.top.equalTo(desLabel.mas_bottom);
        make.width.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds) - 35 * 2);
        make.height.mas_equalTo(140.f);
    }];
    desTextView.layer.borderColor = [UIColor colorWithHex:0x999999 alpha:0.5f].CGColor;
    desTextView.layer.borderWidth = 0.5f;
    
    UILabel *photoLabel = [UILabel new];
    photoLabel.font = [UIFont fontWithName:pageFontName size:14.f];
    photoLabel.textColor = [UIColor colorWithHex:0x999999];
    photoLabel.text = NSLocalizedString(@"Photos of Event", nil);
    [self.scrollView addSubview:photoLabel];
    [photoLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [photoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView.mas_centerX);
        make.top.equalTo(desTextView.mas_bottom);
        make.height.mas_equalTo(40.f);
    }];
    
    CGFloat padding = 10;
    CGFloat itemW = (CGRectGetWidth([UIScreen mainScreen].bounds) - padding * 4) / 3;
    
    self.photoView = [[PhotoWallView alloc] init];
    self.photoView.modeltype = ModelTypeImage;
    self.photoView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.photoView];
    [self.photoView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoLabel.mas_bottom);
        make.left.equalTo(self.scrollView.mas_left).offset(10.f);
        make.height.mas_equalTo(itemW);
        make.width.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds));
    }];
    
    UIImage *image = [UIImage imageNamed:@"addImage"];
    self.photoView.dataSource = @[image, image, image];
    __weak typeof(self) weakSelf = self;
    self.photoView.didSelectItemBlock = ^(NSInteger row) {
        PhotoPickerViewController *picker = [[PhotoPickerViewController alloc] initWithMaxCount:9 selectArray:[NSMutableArray array]];
        picker.resourceType = SelectResourceTypePhoto;
        picker.delegate = weakSelf;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
        [weakSelf presentViewController:nav animated:YES completion:nil];
    };
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 55.f + 7 * 30.f + 140 + 40.f + itemW);
    
    if ([self.controllerFrom isEqualToString:@"profile"]) {
        self.numTextField.text = @"1";
        self.numTextField.userInteractionEnabled = NO;
        self.numLabel.hidden = YES;
        self.numTextField.hidden = YES;
        
        self.needTextField.text = self.userTypeName;
        self.needTextField.userInteractionEnabled = NO;
        
    }else {
        self.numTextField.userInteractionEnabled = YES;
        self.needTextField.userInteractionEnabled = YES;
    }
}

#pragma mark - Event

- (void)locationEvent
{
    PersonInfoAddressViewController *controller = [PersonInfoAddressViewController instantiatePersonInfoAddressViewController];
    controller.valueBlock = ^(NSString *text){
        self.locationTextField.text = text;
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)chooseType:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        self.scrollView.scrollEnabled = NO;
        
        self.typeImageView.transform = CGAffineTransformRotate(self.typeImageView.transform, M_PI);
        __weak typeof(self) weakSelf = self;
        [self.typeView showFrom:sender];
        self.typeView.selectBlock = ^(NSString *idStr, NSString *text) {
            weakSelf.ratetype = idStr;
            weakSelf.typeLabel.text = text;
            
            weakSelf.scrollView.scrollEnabled = YES;
            weakSelf.typeButton.selected = NO;
            
        };
        self.typeView.dismissBlock = ^{
            weakSelf.typeImageView.transform = CGAffineTransformRotate(weakSelf.typeImageView.transform, M_PI);
        };
    }else {
        [self.typeView dismiss];
        self.scrollView.scrollEnabled = YES;
    }
    
    
}

- (void)getLocation
{
    [self.locationManager startUpdatingLocation];
}

- (void)tapEvent:(UIGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    
    if (self.typeButton.isSelected) {
        [self.typeView dismiss];
        self.scrollView.scrollEnabled = YES;
        self.typeButton.selected = NO;
    }
    
    //    self.scrollView.contentOffset = CGPointZero;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.priceTextField) {
//        self.scrollView.contentOffset = CGPointMake(0, 175.f);
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    
    [self.typeView dismiss];
    self.scrollView.scrollEnabled = YES;
    self.typeButton.selected = NO;
    
    if (textField == self.beginTextField) {
        [self.view endEditing:YES];
        self.choosedTextField = self.beginTextField;
        NSInteger year = [self getYearFromDate:[NSDate dateWithTimeIntervalSinceNow:3600]];
        NSInteger month = [self getMonthFromDate:[NSDate dateWithTimeIntervalSinceNow:3600]];
        NSInteger day = [self getDayFromDate:[NSDate dateWithTimeIntervalSinceNow:3600]];
        NSInteger hour = [self getHourFromDate:[NSDate dateWithTimeIntervalSinceNow:3600]];
        YTDatePickerView *view = [YTDatePickerView datePickerViewWithMinDate:[self getDateFromString:[NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld",year,month,day,hour]]];
        __weak typeof(self) weakSelf = self;
        view.valueBlock = ^(NSString *dateStr) {
            weakSelf.choosedTextField.text = dateStr;
        };
        [view show:self.navigationController.view];
        return NO;
    }else if (textField == self.endTextField) {
        [self.view endEditing:YES];
        self.choosedTextField = self.endTextField;
        if (self.beginTextField.text.length == 0) {
            [CustomHudView showWithTip:NSLocalizedString(@"Please Choose Start Date", nil)];
            return NO;
        }
        NSDate *beginDate = [self getDateYearMonthDayHourMinFromString:self.beginTextField.text];
        NSDate *endDate = [NSDate dateWithTimeInterval:3600 sinceDate:beginDate];
        YTDatePickerView *view = [YTDatePickerView datePickerViewWithMinDate:endDate];
        __weak typeof(self) weakSelf = self;
        view.valueBlock = ^(NSString *dateStr) {
            weakSelf.choosedTextField.text = dateStr;
        };
        [view show:self.navigationController.view];
        return NO;
    }else if (textField == self.needTextField) {
        if ([self.controllerFrom isEqualToString:@"profile"]) {
            return YES;
        }else {
            [self.view endEditing:YES];
            [self.needView show:self.navigationController.view];
            __weak typeof(self) weakSelf = self;
            self.needView.valueBlock = ^(NSString *type) {
                if ([type isEqualToString:NSLocalizedString(@"P&MakeUp", nil)]) {
                    weakSelf.type = @"1";
                }else if ([type isEqualToString:NSLocalizedString(@"Model", nil)]) {
                    weakSelf.type = @"3";
                }else if ([type isEqualToString:NSLocalizedString(@"KOL", nil)]) {
                    weakSelf.type = @"4";
                }
                textField.text = [NSString stringWithFormat:@"%@",type];
            };
        }
        return NO;
    }
    return YES;
}

#pragma mark - PhotoPickerViewControllerDelegate

- (void)PhotoPickerViewControllerDidSelectPhoto:(NSMutableArray<AssetModel  *> *)selectArray
{
    if (selectArray.count == 0) {
        UIImage *image = [UIImage imageNamed:@"addImage"];
        self.photoView.dataSource = @[image, image, image];
    }else {
        NSMutableArray *imageArray = [NSMutableArray array];
        for (AssetModel *model in selectArray)
        {
            UIImage *image = [UIImage imageWithCGImage:[model.asset.defaultRepresentation fullScreenImage]];
            NSData *data = UIImagePNGRepresentation(image);
            if (data)
            {
                [imageArray addObject:image];
            }
        }
        self.dataSource = [imageArray copy];
        self.photoView.dataSource = self.dataSource;
    }
}

- (IBAction)postEvent:(UIButton *)sender {
    if (self.nameTextField.text.length == 0) {
        [CustomHudView showWithTip:@"请输入活动名称"];
        return;
    }
    if (self.locationTextField.text.length == 0) {
        [CustomHudView showWithTip:@"请输入位置信息"];
        return;
    }
    if (self.beginTextField.text == 0) {
        [CustomHudView showWithTip:@"请选择开始时间"];
        return;
    }
    if (self.endTextField.text.length == 0) {
        [CustomHudView showWithTip:@"请选择结束时间"];
        return;
    }
    if (self.priceTextField.text.length == 0) {
        [CustomHudView showWithTip:@"请输入价格"];
        return;
    }
    if (self.needTextField.text.length == 0) {
        [CustomHudView showWithTip:@"请选择需要的类型"];
        return;
    }
    if (self.numTextField.text.length == 0) {
        [CustomHudView showWithTip:@"请输入需要的人数"];
        return;
    }
    if (self.desTextView.text.length == 0) {
        [CustomHudView showWithTip:@"请输入详细信息"];
        return;
    }
    if (self.dataSource.count == 0) {
        [CustomHudView showWithTip:@"请选择图片"];
        return;
    }
    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm";
    // 截止时间data格式
    NSDate *endDate = [dateFomatter dateFromString:self.endTextField.text];
    // 当前时间data格式
    NSDate *beginDate = [dateFomatter dateFromString:self.beginTextField.text];
    
    NSTimeInterval value = [endDate timeIntervalSinceDate:beginDate];
    
    CGFloat hourf = value / 3600;
    if (self.ratetype.intValue == 1) { // 日薪
        self.totalPrice = ceilf(hourf/24) * self.numTextField.text.intValue *self.priceTextField.text.intValue;
    }else {
        self.totalPrice = ceilf(hourf) * self.numTextField.text.intValue *self.priceTextField.text.intValue;
    }
    
    if ([self.controllerFrom isEqualToString:@"profile"]) {
        _tradeNO = [Handler generateTradeNO];
        MBOrderPayModel *orderModel = [[MBOrderPayModel alloc] init];
        orderModel.body = @"预约工作订金";
        orderModel.subject = @"预约工作订金";
        orderModel.totalFee = self.totalPrice * 0.2;
        orderModel.tradeNO = _tradeNO;
        MBOrderPayController *payVC = [[MBOrderPayController alloc] init];
        payVC.orderModel = orderModel;
        [self.navigationController pushViewController:payVC animated:YES];
    }else {
        __block NSString *picStr = @"";
        for (int i = 0; i < self.dataSource.count; i++) {
            //生成文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
            NSString *random= [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg",random];
            
            UIImage *image = self.dataSource[i];
            
            UpYunFormUploader *up = [[UpYunFormUploader alloc] init];
            [up uploadWithBucketName:@"modelbook1" operator:@"modelbook" password:@"m12345678" fileData:[self imageCompress:image] fileName:nil saveKey:fileName otherParameters:nil success:^(NSHTTPURLResponse *response, NSDictionary *responseBody) {
                NSString *urlStr = responseBody[@"url"];
                picStr = [NSString stringWithFormat:@"%@,%@",picStr, urlStr];
                self.picCount++;
                if (self.picCount == self.dataSource.count) {
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    params[@"createUserId"] = @([UserInfoManager userID]);
                    params[@"targetUserId"] = self.bookTargetId;
                    params[@"jobName"] = self.nameTextField.text;
                    params[@"jobAddress"] = self.locationTextField.text;
                    params[@"beginTime"] = self.beginTextField.text;
                    params[@"endTime"] = self.endTextField.text;
                    params[@"userType"] = self.type;
                    params[@"chargePrice"] = @(self.priceTextField.text.doubleValue);
                    params[@"chargeType"] = self.ratetype;
                    params[@"jobContent"] = self.desTextView.text;
                    params[@"userNumber"] = self.numTextField.text;
                    params[@"chargeTotalPrice"] = @(self.totalPrice);
                    params[@"jobImage"] = [picStr substringFromIndex:1];
                    
                    [self networkWithPath:@"job/insert" parameters:params success:^(id responseObject) {
                        NSNumber *code = responseObject[@"code"];
                        if (code.intValue == 0) {
                            BaseTabBarViewController *controller = (BaseTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                            [controller showMainTabBarController:SectionTypeJobs];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadJobs" object:nil];
                        }
                        [CustomHudView showWithTip:responseObject[@"msg"]];
                    } failure:^(NSError *error) {
                        
                    }];
                }
            } failure:^(NSError *error, NSHTTPURLResponse *response, NSDictionary *responseBody) {
                NSLog(@"error-----");
            } progress:^(int64_t completedBytesCount, int64_t totalBytesCount) {
                //NSLog(@"-----%lld",completedBytesCount/totalBytesCount);
            }];
        }
    }
}

-(NSData*)imageCompress:(UIImage*)image
{
    
    NSData * imageData = UIImageJPEGRepresentation(image,1);
    
    float size=[imageData length]/1024;
    if (size<=200)
    {
        return UIImageJPEGRepresentation(image, 1) ;
    }
    else if (size>=200&&size<=1000)
    {
        return UIImageJPEGRepresentation(image, 0.5) ;
    }
    else if(size>1000)
    {
        return UIImageJPEGRepresentation(image, 0.05) ;
    }
    return nil;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"time"]) {
        ChooseTimeViewController *controller = segue.destinationViewController;
        controller.valueBlock = ^(NSString *text, NSString *date) {
            self.beginTextField.text = [NSString stringWithFormat:@"%@ %@",date, text];
        };
    }
}

- (void)backItemOnClick:(UIBarButtonItem *)item
{
    BaseTabBarViewController *controller = (BaseTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([self.controllerFrom isEqualToString:@"profile"]) {
        BaseTabBarViewController *controller = (BaseTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        BaseNavigationViewController *selectedController = (BaseNavigationViewController *)[controller showMainTabBarController:SectionTypeProfile];
        ProfileViewController *profileVC = [[ProfileViewController alloc] initWithUserId:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]]];
        profileVC.initialTabPage = InitialTabPageJobs;
        [selectedController setViewControllers:@[profileVC]];
    }else {
        [controller showMainTabBarController:SectionTypeJobs];
    }
    
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[WalletViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[MBProfileMyJobsDetailController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // 1.获取用户位置的对象
    self.location = [locations lastObject];
    
    [self.geoC reverseGeocodeLocation:self.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error == nil)
        {
            CLPlacemark *firstPlacemark=[placemarks firstObject];
            self.locationTextField.text=firstPlacemark.name;
        }else
        {
            [CustomHudView showWithTip:@"地理反编码失败,稍后重试"];
        }
    }];
    
    // 2.停止定位
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}

- (void)paySuccessRequest
{
    __block NSString *picStr = @"";
    for (int i = 0; i < self.dataSource.count; i++) {
        //生成文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
        NSString *random= [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",random];
        
        UIImage *image = self.dataSource[i];
        
        UpYunFormUploader *up = [[UpYunFormUploader alloc] init];
        [up uploadWithBucketName:@"modelbook1" operator:@"modelbook" password:@"m12345678" fileData:[self imageCompress:image] fileName:nil saveKey:fileName otherParameters:nil success:^(NSHTTPURLResponse *response, NSDictionary *responseBody) {
            NSString *urlStr = responseBody[@"url"];
            picStr = [NSString stringWithFormat:@"%@,%@",picStr, urlStr];
            self.picCount++;
            if (self.picCount == self.dataSource.count) {
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                if ([self.controllerFrom isEqualToString:@"profile"]) {
                    params[@"createUserId"] = @([UserInfoManager userID]);
                    params[@"targetUserId"] = self.bookTargetId;
                    params[@"jobName"] = self.nameTextField.text;
                    params[@"jobAddress"] = self.locationTextField.text;
                    params[@"beginTime"] = self.beginTextField.text;
                    params[@"endTime"] = self.endTextField.text;
                    params[@"userType"] = self.userTypeId;
                    params[@"chargePrice"] = @(self.priceTextField.text.doubleValue);
                    params[@"chargeType"] = self.ratetype;
                    params[@"jobContent"] = self.desTextView.text;
                    params[@"userNumber"] = self.numTextField.text;
                    params[@"chargeTotalPrice"] = @(self.totalPrice);
                    params[@"jobImage"] = [picStr substringFromIndex:1];
                    [self networkWithPath:@"job/book/create" parameters:params success:^(id responseObject) {
                        NSNumber *code = responseObject[@"code"];
                        if (code.intValue == 0) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:reloadMyJobsNotification object:nil];
                        }
                        [[NSNotificationCenter defaultCenter] removeObserver:self];
                        [CustomHudView showWithTip:responseObject[@"msg"]];
                    } failure:^(NSError *error) {
                        [[NSNotificationCenter defaultCenter] removeObserver:self];
                    }];
                }
            }
        } failure:^(NSError *error, NSHTTPURLResponse *response, NSDictionary *responseBody) {
            NSLog(@"error-----");
        } progress:^(int64_t completedBytesCount, int64_t totalBytesCount) {
            //NSLog(@"-----%lld",completedBytesCount/totalBytesCount);
        }];
    }
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

- (NSInteger )getHourFromDate:(NSDate *)date
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitHour fromDate:date];
    return comps.hour;
}

- (NSDate *)getDateFromString:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH"];
    return [dateFormatter dateFromString:dateStr];
}

- (NSDate *)getDateYearMonthDayHourMinFromString:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter dateFromString:dateStr];
}

#pragma mark - notification
- (void)orderPaySuccessNotification:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.userInfo;
    if ([[userInfo objectForKey:@"resultStatus"] isEqualToString:@"8000"] || [[userInfo objectForKey:@"resultStatus"] isEqualToString:@"9000"] || [[userInfo objectForKey:@"resultStatus"] isEqualToString:@"9999"])
    {
        /* 支付记录 */
        NSString *dealMoneySource = @"0";
        if ([[userInfo objectForKey:@"resultStatus"] isEqualToString:@"9999"]) dealMoneySource = @"1";
        NSMutableDictionary *md = [NSMutableDictionary dictionary];
        //TODO:recorld,及对应money数据
        [md setValue:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]] forKey:@"currentUserId"];
        [md setValue:[NSString stringWithFormat:@"%f",self.totalPrice*0.2] forKey:@"totalPrice"];
        [md setValue:_tradeNO forKey:@"tradeno"];
        [md setValue:dealMoneySource forKey:@"dealMoneySource"];
        [md setValue:[NSString stringWithFormat:@"预约支付定金---%@",_bookTargetId] forKey:@"dealTypeContent"];
        /* 支付定金成功 */
        [MBPayHandler handlerPayRecord:md payState:payStateNomal comupted:^(BOOL success) {
            NSLog(@"");
        }];
        [self paySuccessRequest];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.typeView dismiss];
    self.scrollView.scrollEnabled = YES;
    self.typeButton.selected = NO;
    
    return YES;
}


@end
