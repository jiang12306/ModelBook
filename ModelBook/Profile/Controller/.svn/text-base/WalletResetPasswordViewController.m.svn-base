//
//  WalletResetPasswordViewController.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/28.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "WalletResetPasswordViewController.h"
#import "Macros.h"
#import "Const.h"
#import "ProgressHUD.h"

static NSString * const resetPasswordURL = @"http://39.108.152.114/modeltest/user/update";

@interface WalletResetPasswordViewController ()

/* 原始密码 */
@property(nonatomic, strong)UITextField *password1;
/* 新密码 */
@property(nonatomic, strong)UITextField *password2;
/* 再次输入密码 */
@property(nonatomic, strong)UITextField *password3;
/* 提交 */
@property(nonatomic, strong)UIButton *submitBtn;


@end

@implementation WalletResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
}

- (void)initLayout
{
    self.navigationItem.title = NSLocalizedString(@"Profilesetpassword", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.password1];
    [self.view addSubview:self.password2];
    [self.view addSubview:self.submitBtn];
}

#pragma mark - action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)textFieldAction:(UITextField *)textField
{
    if (textField.text.length>6) textField.text = [textField.text substringToIndex:6];
    if (textField == _password1 && textField.text.length == 6)
    {
        [_password2 becomeFirstResponder];
    }
    if (_password1.text.length == 6 && _password2.text.length == 6 && [_password1.text isEqualToString:_password2.text])
    {
        _submitBtn.userInteractionEnabled = YES;
        _submitBtn.backgroundColor = [UIColor colorWithHex:0xa7d7ff];
    }
    else
    {
        _submitBtn.userInteractionEnabled = NO;
        _submitBtn.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    }
}

- (void)submitAction:(UIButton *)sender
{
    [ProgressHUD showLoadingText:NSLocalizedString(@"Is setting", nil)];
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    [md setValue:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]] forKey:@"userId"];
    [md setValue:_password1.text forKey:@"payPassword"];
    
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:resetPasswordURL parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                [ProgressHUD showText:NSLocalizedString(@"Set up to pay the password successfully", nil) block:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }
            else
            {
                [ProgressHUD showText:NSLocalizedString(@"Set up to pay the password failure", nil)];
            }
        }
        else
        {
            [ProgressHUD showText:NSLocalizedString(@"Set up to pay the password failure", nil)];
        }
    } failure:^(NSError *error) {
        [ProgressHUD showText:NSLocalizedString(@"Set up to pay the password failure", nil)];
    }];
}

#pragma mark - lazy
- (UITextField *)password1
{
    if (!_password1) {
        _password1 = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, CGRectGetWidth(self.view.frame)-40, 44)];
        _password1.layer.borderColor = [UIColor colorWithHexString:@"#eeeeee"].CGColor;
        _password1.layer.borderWidth = 1;
        _password1.placeholder = NSLocalizedString(@"The new password", nil);
        _password1.textColor = [UIColor colorWithHexString:@"#333333"];
        _password1.font = [UIFont fontWithName:pageFontName size:14];
        _password1.layer.cornerRadius = 3;
        _password1.keyboardType = UIKeyboardTypeNumberPad;
        _password1.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 40)];
        _password1.leftViewMode = UITextFieldViewModeAlways;
        [_password1 addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    }
    return _password1;
}

- (UITextField *)password2
{
    if (!_password2) {
        _password2 = [[UITextField alloc] initWithFrame:CGRectMake(20, 20+CGRectGetMaxY(self.password1.frame), CGRectGetWidth(self.view.frame)-40, 44)];
        _password2.layer.borderColor = [UIColor colorWithHexString:@"#eeeeee"].CGColor;
        _password2.layer.borderWidth = 1;
        _password2.placeholder = NSLocalizedString(@"Confirm new password", nil);
        _password2.textColor = [UIColor colorWithHexString:@"#333333"];
        _password2.font = [UIFont fontWithName:pageFontName size:14];
        _password2.layer.cornerRadius = 3;
        _password2.keyboardType = UIKeyboardTypeNumberPad;
        _password2.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 40)];
        _password2.leftViewMode = UITextFieldViewModeAlways;
        [_password2 addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    }
    return _password2;
}

- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20+CGRectGetMaxY(self.password2.frame), CGRectGetWidth(self.view.frame)-40, 44)];
        [_submitBtn setTitle:NSLocalizedString(@"Confirm to submit", nil) forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitBtn.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        _submitBtn.titleLabel.font = [UIFont fontWithName:buttonFontName size:14];
        _submitBtn.layer.cornerRadius = 3;
        _submitBtn.userInteractionEnabled = NO;
        [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

@end
