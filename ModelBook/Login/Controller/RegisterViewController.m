//
//  RegisterViewController.m
//  ModelBook
//
//  Created by zdjt on 2017/8/8.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "RegisterViewController.h"
#import "VerCodeViewController.h"
#import "ForgetViewController.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *phoneLeftImageView;
@property (weak, nonatomic) IBOutlet MBTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoImageViewTopCons;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *phoneLeftImageViewTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerButtonTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerButtonHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneLeftImageViewLeftCons;

@end

@implementation RegisterViewController

+ (RegisterViewController *)instantiateRegisterViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:@"RegisterVCSBID"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setupBackItem];
    
    self.phoneTextField.placeholder = NSLocalizedString(@"registerPhonePlaceholder", nil);
    if ([self.controllerFrom isEqualToString:@"Forget"]) {
        [self.registerButton setTitle:NSLocalizedString(@"introTextA", nil) forState:UIControlStateNormal];
    }else {
        [self.registerButton setTitle:NSLocalizedString(@"loginButtonTextC", nil) forState:UIControlStateNormal];
    }
    
    self.registerButton.layer.cornerRadius = 3.f;
    self.registerButton.layer.masksToBounds = YES;
    
    self.logoImageViewTopCons.constant = Adapter_Y(60.f);
    self.phoneLeftImageViewTopCons.constant = Adapter_Y(100.f);
    self.phoneLeftImageViewLeftCons.constant = Adapter_X(100.f);
    if (IS_IPHONE5) {
        self.registerButtonTopCons.constant = 170.f;
    }
    
    self.phoneTextField.font = [UIFont fontWithName:pageFontName size:15.f];
    self.registerButton.titleLabel.font = [UIFont fontWithName:buttonFontName size:18.f];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - ButtonEvent

- (IBAction)registerButtonEvent:(UIButton *)sender {
    if (self.phoneTextField.text.length == 0) {
        [CustomHudView showWithTip:@"请输入手机号"];
        return;
    }
    
    if ([self.controllerFrom isEqualToString:@"Forget"]) {
        // 2.发送注册验证码
        [self networkWithPath:@"user/backpwd" parameters:@{@"phone" : self.phoneTextField.text} success:^(id responseObject) {
            NSNumber *code = responseObject[@"code"];
            if (code.intValue == 0) {
                NSNumber *vercode = responseObject[@"object"];
                [self performSegueWithIdentifier:@"forget" sender:[NSString stringWithFormat:@"%@",vercode]];
            }else {
                [CustomHudView showWithTip:responseObject[@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }else {
        // 1.检查手机号是否已注册
        [self networkWithPath:@"user/check_phone" parameters:@{@"phone" : self.phoneTextField.text} success:^(id responseObject) {
            NSNumber *code = responseObject[@"code"];
            if (code.intValue == 0) {
                // 2.发送注册验证码
                [self networkWithPath:@"user/register/send_code" parameters:@{@"phone" : self.phoneTextField.text} success:^(id responseObject) {
                    NSNumber *code = responseObject[@"code"];
                    if (code.intValue == 0) {
                        NSNumber *vercode = responseObject[@"object"];
                        [self performSegueWithIdentifier:@"vercode" sender:vercode];
                    }else {
                        [CustomHudView showWithTip:responseObject[@"msg"]];
                    }
                } failure:^(NSError *error) {
                    
                }];
            }else {
                [CustomHudView showWithTip:responseObject[@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
    
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"vercode"]) {
        VerCodeViewController *controller = segue.destinationViewController;
        controller.phone = self.phoneTextField.text;
        controller.vercode = sender;
    }else if ([segue.identifier isEqualToString:@"forget"]) {
        ForgetViewController *controller = segue.destinationViewController;
        controller.phone = self.phoneTextField.text;
        controller.vercode = sender;
    }
}

@end
