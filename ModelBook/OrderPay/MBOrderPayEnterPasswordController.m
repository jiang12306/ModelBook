//
//  MBOrderPayEnterPasswordController.m
//  ModelBook
//
//  Created by 高昇 on 2017/9/1.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "MBOrderPayEnterPasswordController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "TPPasswordTextView.h"
#import "UserInfoManager.h"
#import "ProgressHUD.h"
#import "WalletResetPasswordViewController.h"
#import "MBOrderPaySuccessController.h"
#import "ProfileViewController.h"

static NSString * const payPasswordURL = @"http://39.108.152.114/modeltest/pay/match_paypassword";

@interface MBOrderPayEnterPasswordController ()<UIAlertViewDelegate>

/* topView */
@property(nonatomic, strong)UIButton *topView;
/* title */
@property(nonatomic, strong)UILabel *titleLabel;
/* code */
@property(nonatomic, strong)TPPasswordTextView *codeView;
/* password */
@property(nonatomic, strong)UIButton *forgetPasswordBtn;

@end

@implementation MBOrderPayEnterPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
}

- (void)initLayout
{
    self.navigationItem.title = NSLocalizedString(@"Payment", nil);
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.codeView];
    [self.view addSubview:self.forgetPasswordBtn];
}

- (void)verifyPayPassword:(NSString *)password
{
    [ProgressHUD showLoadingText:@"请稍后..."];
    NSDictionary *md = @{@"userId":[NSString stringWithFormat:@"%ld",[UserInfoManager userID]],@"payPassword":password};
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:payPasswordURL parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
        [ProgressHUD hide];
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                [weakSelf payOrder];
                return;
            }
            else if ([code isEqualToString:@"60166"])
            {
                [weakSelf handlerVerifyPayPassword:NO];
                [weakSelf.codeView clearPassword];
                return;
            }
            else if ([code isEqualToString:@"60107"])
            {
                [ProgressHUD showText:@"userId错误"];
                [weakSelf.codeView clearPassword];
                return;
            }
        }
        [weakSelf handlerVerifyPayPassword:YES];
        [weakSelf.codeView clearPassword];
    } failure:^(NSError *error) {
        [ProgressHUD showText:@"当前网络有问题"];
        [weakSelf.codeView clearPassword];
    }];
}

- (void)payOrder
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    [md setValue:[NSString stringWithFormat:@"%.2f",_orderModel.totalFee] forKey:@"totalPrice"];
    [md setValue:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]] forKey:@"userId"];
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:@"http://39.108.152.114/modeltest/pay/bybalance" parameters:md constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:alipayOrderPaySuccessNotification object:nil userInfo:@{@"resultStatus":@"9999"}];
            }
            else
            {
                [ProgressHUD showText:@"支付失败"];
                [weakSelf.codeView clearPassword];
            }
        }
        else
        {
            [ProgressHUD showText:@"支付失败"];
            [weakSelf.codeView clearPassword];
        }
    } failure:^(NSError *error) {
        [ProgressHUD showText:@"支付失败"];
        [weakSelf.codeView clearPassword];
    }];
}

- (void)handlerVerifyPayPassword:(BOOL)errorPassword
{
    if (!errorPassword)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"支付失败" message:@"您当前暂未设置支付密码" delegate:self cancelButtonTitle:@"完成" otherButtonTitles:@"设置支付密码", nil];
        alertView.tag = 1;
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"支付失败" message:@"密码有误，请您重新输入密码" delegate:self cancelButtonTitle:@"重来" otherButtonTitles:@"取消订单", nil];
        alertView.tag = 2;
        [alertView show];
    }
}

#pragma mark - alertView - delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        /* 密码错误 */
        if (buttonIndex == 1)
        {
            /* 重来 */
            [self resetPassword];
        }
        else
        {
            [self.codeView hideKeyboard];
            /* 取消订单 */
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        /* 密码错误 */
        if (buttonIndex == 1)
        {
            [self.codeView hideKeyboard];
            /* 取消订单 */
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            /* 重来 */
            [self.codeView clearPassword];
            [self.codeView showKeyboard];
        }
    }
}

#pragma mark - action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.codeView hideKeyboard];
}

- (void)resetPassword
{
    /* 设置支付密码 */
    [self.codeView clearPassword];
    [self.codeView hideKeyboard];
    WalletResetPasswordViewController *resetPasswordVC = [[WalletResetPasswordViewController alloc] init];
    [self.navigationController pushViewController:resetPasswordVC animated:YES];
}

#pragma mark - lazy
- (UIButton *)topView
{
    if (!_topView) {
        _topView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50)];
        _topView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
        [_topView setTitle:@"Enter Password" forState:UIControlStateNormal];
        [_topView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _topView.titleLabel.font = [UIFont fontWithName:buttonFontName size:14];
    }
    return _topView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame)+10, CGRectGetWidth(self.view.frame), 40)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _titleLabel.text = @"输入支付密码，以完成支付";
        _titleLabel.font = [UIFont fontWithName:pageFontName size:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (TPPasswordTextView *)codeView
{
    if (!_codeView)
    {
        _codeView = [[TPPasswordTextView alloc] initWithFrame:CGRectMake((screenWidth-300)/2, CGRectGetMaxY(self.titleLabel.frame), 300, 44.f)];
        _codeView.elementCount = 6;
        _codeView.elementBorderColor = [UIColor colorWithHexString:@"#666666"];
        [_codeView showKeyboard];
        WS(weakSelf);
        _codeView.passwordDidChangeBlock = ^(NSString *password) {
            if (password.length == 6) [weakSelf verifyPayPassword:password];
        };
    }
    return _codeView;
}

- (UIButton *)forgetPasswordBtn
{
    if (!_forgetPasswordBtn) {
        _forgetPasswordBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-80, CGRectGetMaxY(self.codeView.frame)+20, 80, 30)];
        [_forgetPasswordBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetPasswordBtn setTitleColor:[UIColor colorWithHex:0xa7d7ff] forState:UIControlStateNormal];
        _forgetPasswordBtn.titleLabel.font = [UIFont fontWithName:buttonFontName size:12];
        [_forgetPasswordBtn addTarget:self action:@selector(resetPassword) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPasswordBtn;
}

@end
