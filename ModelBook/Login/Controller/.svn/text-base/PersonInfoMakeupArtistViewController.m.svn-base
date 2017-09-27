//
//  PersonInfoMakeupArtistViewController.m
//  ModelBook
//
//  Created by zdjt on 2017/8/14.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "PersonInfoMakeupArtistViewController.h"
#import "PersonInfoAddressViewController.h"
#import "LoginFieldViewController.h"

@interface PersonInfoMakeupArtistViewController ()

@property (weak, nonatomic) IBOutlet MBTextField *addressTextField;
@property (weak, nonatomic) IBOutlet MBTextField *hourTextField;
@property (weak, nonatomic) IBOutlet MBTextField *dayTextField;
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *womanButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLeftImageViewLeftCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dayLeftImageViewLeftCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hourLeftImageViewLeftCons;

@property (strong, nonatomic) NSArray *professionArray;
@property (weak, nonatomic) UIButton *selectedButton;

@property (copy, nonatomic) NSString *sex;

@end

@implementation PersonInfoMakeupArtistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackItem];
    
    self.addressTextField.placeholder = NSLocalizedString(@"Address", nil);
    self.hourTextField.placeholder = NSLocalizedString(@"My Hour Rate", nil);
    self.dayTextField.placeholder = NSLocalizedString(@"My Day Rate", nil);
    
    self.addressTextField.font = [UIFont fontWithName:pageFontName size:15.f];
    self.hourTextField.font = [UIFont fontWithName:pageFontName size:15.f];
    self.dayTextField.font = [UIFont fontWithName:pageFontName size:15.f];
    
    self.addressLeftImageViewLeftCons.constant = Adapter_X(80.f);
    self.hourLeftImageViewLeftCons.constant = Adapter_X(80.f);
    self.dayLeftImageViewLeftCons.constant = Adapter_X(80.f);
    
    self.nextButton.layer.cornerRadius = 3.f;
    self.nextButton.layer.masksToBounds = YES;
    [self.nextButton setTitle:NSLocalizedString(@"introTextA", nil) forState:UIControlStateNormal];
    
    self.manButton.selected = YES;
    self.selectedButton = self.manButton;
    self.sex = @"m";
    
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

- (IBAction)addressButtonEvent:(UIButton *)sender {
    [self performSegueWithIdentifier:@"address" sender:nil];
}

- (IBAction)nextButtonEvent:(UIButton *)sender {
    [self performSegueWithIdentifier:@"field" sender:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 135.f;
    }else if (indexPath.row == 7) {
        return 120.f;
    }else {
        return 40.f;
    }
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"address"]) {
        PersonInfoAddressViewController *controller = segue.destinationViewController;
        controller.valueBlock = ^(NSString *text){
            self.addressTextField.text = text;
        };
    }else if ([segue.identifier isEqualToString:@"field"]) {
        LoginFieldViewController *controller = segue.destinationViewController;
        if (self.selectedButton == self.manButton) {
            controller.type = @"man";
            self.sex = @"m";
        }else {
            controller.type = @"woman";
            self.sex = @"f";
        }
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:self.params];
        dict[@"address"] = self.addressTextField.text;
        dict[@"hourRate"] = @(self.hourTextField.text.doubleValue);
        dict[@"dayRate"] = @(self.dayTextField.text.doubleValue);
        dict[@"sex"] = self.sex;
        controller.params = [dict copy];
    }
}

@end
