//
//  PersonInfoBViewController.m
//  ModelBook
//
//  Created by zdjt on 2017/8/10.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "PersonInfoBViewController.h"
#import "LoginFieldViewController.h"

@interface PersonInfoBViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet MBTextField *addressTextField;
@property (weak, nonatomic) IBOutlet MBTextField *heightTextField;
@property (weak, nonatomic) IBOutlet MBTextField *weightTextField;
@property (weak, nonatomic) IBOutlet MBTextField *hourTextField;
@property (weak, nonatomic) IBOutlet MBTextField *dayTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *professionPickView;
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *womanButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLeftImageViewLeftCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLeftImageViewLeftCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weightLeftImageViewLeftCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dayLeftImageViewLeftCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hourLeftImageViewLeftCons;

@property (strong, nonatomic) NSArray *professionArray;
@property (weak, nonatomic) UIButton *selectedButton;

@end

@implementation PersonInfoBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackItem];
    
    self.addressTextField.placeholder = NSLocalizedString(@"Address", nil);
    self.heightTextField.placeholder = NSLocalizedString(@"Height", nil);
    self.weightTextField.placeholder = NSLocalizedString(@"Weight", nil);
    self.hourTextField.placeholder = NSLocalizedString(@"My Hour Rate", nil);
    self.dayTextField.placeholder = NSLocalizedString(@"My Day Rate", nil);
    
    self.addressTextField.font = [UIFont fontWithName:pageFontName size:15.f];
    self.heightTextField.font = [UIFont fontWithName:pageFontName size:15.f];
    self.weightTextField.font = [UIFont fontWithName:pageFontName size:15.f];
    self.hourTextField.font = [UIFont fontWithName:pageFontName size:15.f];
    self.dayTextField.font = [UIFont fontWithName:pageFontName size:15.f];
    
    self.addressTextField.delegate = self;
    self.heightTextField.delegate = self;
    self.weightTextField.delegate = self;
    self.hourTextField.delegate = self;
    self.dayTextField.delegate = self;
    
    self.addressLeftImageViewLeftCons.constant = Adapter_X(80.f);
    self.heightLeftImageViewLeftCons.constant = Adapter_X(80.f);
    self.weightLeftImageViewLeftCons.constant = Adapter_X(80.f);
    self.hourLeftImageViewLeftCons.constant = Adapter_X(80.f);
    self.dayLeftImageViewLeftCons.constant = Adapter_X(80.f);
    
    self.professionPickView.delegate = self;
    self.professionArray = @[@"中模", @"外模", @"网红"];
    [self.professionPickView selectRow:0 inComponent:0 animated:YES];
    
    self.nextButton.layer.cornerRadius = 3.f;
    self.nextButton.layer.masksToBounds = YES;
    [self.nextButton setTitle:NSLocalizedString(@"introTextA", nil) forState:UIControlStateNormal];
    
    self.womanButton.selected = YES;
    self.selectedButton = self.womanButton;
    
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

- (IBAction)manButtonEvent:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        self.selectedButton = sender;
    }else {
        self.selectedButton = self.womanButton;
    }
    self.womanButton.selected = !sender.isSelected;
}

- (IBAction)womanButtonEvent:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        self.selectedButton = sender;
    }else {
        self.selectedButton = self.manButton;
    }
    self.manButton.selected = !sender.isSelected;
}

- (IBAction)nextButtonEvent:(UIButton *)sender {
    [self performSegueWithIdentifier:@"field" sender:nil];
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
    NSLog(@"-----%@",self.professionArray[row]);
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 135.f;
    }else if (indexPath.row == 6) {
        return 100.f;
    }else if (indexPath.row == 8) {
        return 120.f;
    }else {
        return 40.f;
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.addressTextField || textField == self.heightTextField || textField == self.weightTextField) {
        [self.tableView setContentInset:UIEdgeInsetsMake(-(135), 0, 0, 0)];
    }else if (textField == self.hourTextField || textField == self.dayTextField) {
        [self.tableView setContentInset:UIEdgeInsetsMake(-(135 + 40 * 3), 0, 0, 0)];
    }
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"field"]) {
        LoginFieldViewController *controller = segue.destinationViewController;
        if (self.selectedButton == self.manButton) {
            controller.type = @"man";
        }else {
            controller.type = @"woman";
        }
    }
}

@end
