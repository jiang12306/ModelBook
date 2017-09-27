//
//  PersonInfoAViewController.m
//  ModelBook
//
//  Created by zdjt on 2017/8/10.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "HcdDateTimePickerView.h"
#import "PersonInfoCompanyViewController.h"
#import "PersonInfoModelViewController.h"
#import "PersonInfoCompanyViewController.h"
#import "PersonInfoMakeupArtistViewController.h"

@interface PersonInfoViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet MBTextField *userNameTextField;
@property (weak, nonatomic) IBOutlet MBTextField *pwdTextField;
@property (weak, nonatomic) IBOutlet MBTextField *rePwdTextField;
@property (weak, nonatomic) IBOutlet MBTextField *identifierTextField;
@property (weak, nonatomic) IBOutlet MBTextField *identifierNameTextField;
@property (weak, nonatomic) IBOutlet MBTextField *birthTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *professionPickView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameLeftImageViewLeftCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pwdLeftImageViewLeftCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rePwdLeftImageVeiwLeftCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *identifierLeftImageLeftCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *identifierNameLeftImageViewLeftCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *birthLeftImageViewLeftCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *professionLeftImageViewLeftCons;

@property (strong, nonatomic) NSArray *professionArray;

@property (strong, nonatomic) NSArray *idArray;

@property (strong, nonatomic) HcdDateTimePickerView * dateTimePickerView;

@property (assign, nonatomic) int selectedIndex;

@end

@implementation PersonInfoViewController

+ (PersonInfoViewController *)instantiatePersonInfoViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:@"InfoVCSBID"];
}

+ (BaseNavigationViewController *)instantiateNavigationController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:@"InfoNavSBID"];
}

- (HcdDateTimePickerView *)dateTimePickerView {
    if (!_dateTimePickerView) {
        _dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000]];
        [_dateTimePickerView setMinYear:1980];
        [_dateTimePickerView setMaxYear:2017];
        __weak typeof(self) weakSelf = self;
        _dateTimePickerView.clickedOkBtn = ^(NSString * datetimeStr){
            weakSelf.birthTextField.text = datetimeStr;
        };
    }
    [self.navigationController.view addSubview:_dateTimePickerView];
    [_dateTimePickerView showHcdDateTimePicker];
    return _dateTimePickerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackItem];
    
    self.userNameTextField.placeholder = NSLocalizedString(@"loginUserNamePlaceholder", nil);
    self.pwdTextField.placeholder = NSLocalizedString(@"loginPwdPlaceholder", nil);
    self.rePwdTextField.placeholder = NSLocalizedString(@"infoRePwdPlaceholder", nil);
    self.identifierTextField.placeholder = NSLocalizedString(@"infoIDNumPlaceholder", nil);
    self.identifierNameTextField.placeholder = NSLocalizedString(@"infoIDNamePlaceholder", nil);
    self.birthTextField.placeholder = NSLocalizedString(@"infoDOBPlaceholder", nil);
    
    self.userNameTextField.font = [UIFont fontWithName:pageFontName size:15.f];
    self.pwdTextField.font = [UIFont fontWithName:pageFontName size:15.f];
    self.rePwdTextField.font = [UIFont fontWithName:pageFontName size:15.f];
    self.identifierTextField.font = [UIFont fontWithName:pageFontName size:15.f];
    self.identifierNameTextField.font = [UIFont fontWithName:pageFontName size:15.f];
    self.birthTextField.font = [UIFont fontWithName:pageFontName size:15.f];
    
    self.nextButton.layer.cornerRadius = 3.f;
    self.nextButton.layer.masksToBounds = YES;
    [self.nextButton setTitle:NSLocalizedString(@"introTextA", nil) forState:UIControlStateNormal];
    
    self.professionPickView.delegate = self;
    self.professionArray = @[NSLocalizedString(@"infoAModel", nil),NSLocalizedString(@"infoACompany", nil), NSLocalizedString(@"P&MakeUp", nil), NSLocalizedString(@"infoAIndividul", nil)];
    self.idArray = @[@3,@5,@1,@6];
    [self.professionPickView selectRow:0 inComponent:0 animated:YES];
    self.selectedIndex = 0;
    
    self.userNameTextField.delegate = self;
    self.pwdTextField.delegate = self;
    self.rePwdTextField.delegate = self;
    self.identifierTextField.delegate = self;
    self.identifierNameTextField.delegate = self;
    self.birthTextField.delegate = self;
    
    self.userNameLeftImageViewLeftCons.constant = Adapter_X(80.f);
    self.pwdLeftImageViewLeftCons.constant = Adapter_X(80.f);
    self.rePwdLeftImageVeiwLeftCons.constant = Adapter_X(80.f);
    self.identifierLeftImageLeftCons.constant = Adapter_X(80.f);
    self.identifierNameLeftImageViewLeftCons.constant = Adapter_X(80.f);
    self.birthLeftImageViewLeftCons.constant = Adapter_X(80.f);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    [self.tableView addGestureRecognizer:tap];
    
}

#pragma mark - ButtonEvent

- (void)tapEvent:(UIGestureRecognizer *)sender {
    [self.view endEditing:YES];
    [self.tableView setContentInset:UIEdgeInsetsZero];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView setContentInset:UIEdgeInsetsZero];
    });
}

- (IBAction)nextButtonEvent:(UIButton *)sender {
    if ([self.controllerFrom isEqualToString:@"wechat"]) {
        if (self.birthTextField.text.length > 0) {
            switch (self.selectedIndex) {
                case 0:
                    [self performSegueWithIdentifier:@"model" sender:nil];
                    break;
                case 1:
                    [self performSegueWithIdentifier:@"company" sender:nil];
                    break;
                case 2:
                    [self performSegueWithIdentifier:@"MakeupArtist" sender:nil];
                    break;
                case 3:
                    [self performSegueWithIdentifier:@"MakeupArtist" sender:nil];
                    break;
                case 4:
                    [self performSegueWithIdentifier:@"company" sender:nil];
                    break;
                default:
                    break;
            }
        }else {
            [CustomHudView showWithTip:@"请选择出生日期"];
        }
    }else {
        if (self.userNameTextField.text.length > 0
            && self.pwdTextField.text.length > 0
            && self.rePwdTextField.text.length > 0
            && self.birthTextField.text.length > 0) {
            if (![self checkPassWord:self.pwdTextField.text]) {
                [CustomHudView showWithTip:@"字母+数字，不低于6位数"];
                return;
            }
            if (![self.pwdTextField.text isEqualToString:self.rePwdTextField.text]) {
                [CustomHudView showWithTip:@"两次密码不一致"];
                return;
            }
            
            switch (self.selectedIndex) {
                case 0:
                    [self performSegueWithIdentifier:@"model" sender:nil];
                    break;
                case 1:
                    [self performSegueWithIdentifier:@"company" sender:nil];
                    break;
                case 2:
                    [self performSegueWithIdentifier:@"MakeupArtist" sender:nil];
                    break;
                case 3:
                    [self performSegueWithIdentifier:@"MakeupArtist" sender:nil];
                    break;
                case 4:
                    [self performSegueWithIdentifier:@"company" sender:nil];
                    break;
                default:
                    break;
            }
        }else {
            [CustomHudView showWithTip:@"请完善信息"];
        }
    }
    
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.professionArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.professionArray[row];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectedIndex = (int)row;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [UILabel new];
    label.font = [UIFont fontWithName:pageFontName size:15.f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHex:0x999999];
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 25.0f;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.userNameTextField || textField == self.pwdTextField || textField == self.rePwdTextField) {
        [self.tableView setContentInset:UIEdgeInsetsMake(-(135), 0, 0, 0)];
    }else if (textField == self.identifierTextField || textField == self.identifierNameTextField) {
        [self.tableView setContentInset:UIEdgeInsetsMake(-(135 + 40 * 3), 0, 0, 0)];
    }else {
        [self.tableView setContentInset:UIEdgeInsetsMake(-(135 + 40 * 3), 0, 0, 0)];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.birthTextField) {
        [self.view endEditing:YES];
        [self dateTimePickerView];
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 135.f;
    }else if (indexPath.row == 7) {
        return 100.f;
    }else if (indexPath.row == 8) {
        return 120.f;
    }else if (indexPath.row ==4 || indexPath.row == 5) {
        return 0.f;
    }else if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
        if ([self.controllerFrom isEqualToString:@"wechat"]) {
            return 0.f;
        }else {
            return 40.f;
        }
    }else {
        return 40.f;
    }
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"model"]) {
        PersonInfoModelViewController *controller = segue.destinationViewController;
        if (self.phone.length > 0) {
            controller.params = @{
                                  @"phone" : self.phone,
                                  @"username":self.userNameTextField.text,
                                  @"password":self.pwdTextField.text,
                                  @"birthday":self.birthTextField.text,
                                  @"userTypeId":self.idArray[self.selectedIndex]
                                  };
        }else {
            controller.params = @{
                                  @"username":self.userNameTextField.text,
                                  @"password":self.pwdTextField.text,
                                  @"birthday":self.birthTextField.text,
                                  @"userTypeId":self.idArray[self.selectedIndex]
                                  };
        }
        
    }else if ([segue.identifier isEqualToString:@"company"]) {
        PersonInfoCompanyViewController *controller = segue.destinationViewController;
        if (self.phone.length > 0) {
            controller.params = @{
                                  @"phone" : self.phone,
                                  @"username":self.userNameTextField.text,
                                  @"password":self.pwdTextField.text,
                                  @"birthday":self.birthTextField.text,
                                  @"userTypeId":self.idArray[self.selectedIndex]
                                  };
        }else {
            controller.params = @{
                                  @"username":self.userNameTextField.text,
                                  @"password":self.pwdTextField.text,
                                  @"birthday":self.birthTextField.text,
                                  @"userTypeId":self.idArray[self.selectedIndex]
                                  };
        }
        
    }else if ([segue.identifier isEqualToString:@"MakeupArtist"]) {
        PersonInfoMakeupArtistViewController *controller = segue.destinationViewController;
        if (self.phone.length > 0) {
            controller.params = @{
                                  @"phone" : self.phone,
                                  @"username":self.userNameTextField.text,
                                  @"password":self.pwdTextField.text,
                                  @"birthday":self.birthTextField.text,
                                  @"userTypeId":self.idArray[self.selectedIndex]
                                  };
        }else {
            controller.params = @{
                                  @"username":self.userNameTextField.text,
                                  @"password":self.pwdTextField.text,
                                  @"birthday":self.birthTextField.text,
                                  @"userTypeId":self.idArray[self.selectedIndex]
                                  };
        }
        
    }
}

-(BOOL)checkPassWord:(NSString *)password
{
    //6-20位数字和字母组成
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

@end
