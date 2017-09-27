//
//  ResetViewController.m
//  ModelBook
//
//  Created by zdjt on 2017/9/8.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ResetViewController.h"

@interface ResetViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoImageViewTopCons;

@property (weak, nonatomic) IBOutlet UILabel *passwordDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *againDesLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *againTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation ResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackItem];
    
    self.logoImageViewTopCons.constant = Adapter_Y(60.f);
    
    self.passwordDesLabel.font = [UIFont fontWithName:pageFontName size:15.f];
    self.passwordDesLabel.textColor = [UIColor colorWithHex:0x999999];
    self.passwordDesLabel.text = NSLocalizedString(@"input new password", nil);
    
    self.againDesLabel.font = [UIFont fontWithName:pageFontName size:15.f];
    self.againDesLabel.textColor = [UIColor colorWithHex:0x999999];
    self.againDesLabel.text = NSLocalizedString(@"input again", nil);
    
    self.passwordTextField.font = [UIFont fontWithName:pageFontName size:15.f];
    self.passwordTextField.textColor = [UIColor colorWithHex:0x999999];
    self.passwordTextField.placeholder = NSLocalizedString(@"input new password", nil);
    
    self.againTextField.font = [UIFont fontWithName:pageFontName size:15.f];
    self.againTextField.textColor = [UIColor colorWithHex:0x999999];
    self.againTextField.placeholder = NSLocalizedString(@"input again", nil);
    
    self.commitButton.layer.cornerRadius = 3.f;
    self.commitButton.layer.masksToBounds = YES;
    [self.commitButton setTitle:NSLocalizedString(@"Confirm", nil) forState:UIControlStateNormal];
    
    
}

- (void)backItemOnClick:(UIBarButtonItem *)item
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)commitButtonEvent:(UIButton *)sender {
    if (self.passwordTextField.text.length == 0) {
        [CustomHudView showWithTip:@"请输入密码"];
        return;
    }else if (![self.againTextField.text isEqualToString:self.passwordTextField.text]) {
        [CustomHudView showWithTip:@"两次密码不一致"];
        return;
    }
    
    [self networkWithPath:@"user/backpwd/phone" parameters:@{@"phone":self.phone, @"password":self.passwordTextField.text} success:^(id responseObject) {
        NSNumber *code = responseObject[@"code"];
        if (code.intValue == 0){
            [UserInfoManager setPassword:self.passwordTextField.text];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        [CustomHudView showWithTip:responseObject[@"msg"]];
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
