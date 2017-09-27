//
//  WalletViewController.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/27.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "WalletViewController.h"
#import "UIColor+Ext.h"
#import "Const.h"
#import "Macros.h"
#import "WalletRecordViewController.h"
#import "WalletResetPasswordViewController.h"
#import <UIImageView+WebCache.h>
#import "WalletTradeRecordModel.h"
#import "Handler.h"
#import "MBOrderPayModel.h"
#import "NSString+imgURL.h"

#define btnWidth (IS_IPHONE320?300:333)

static NSString * const tradeRecordURL = @"http://39.108.152.114/modeltest/dealrecord/query";

@interface WalletViewController ()

/* 显示区 */
@property(nonatomic, strong)UIView *headerView;
/* 支付历史 */
@property(nonatomic, strong)UIButton *recordBtn;
/* 提现按钮 */
@property(nonatomic, strong)UIButton *pickupBtn;
/* 设置支付密码 */
@property(nonatomic, strong)UIButton *modifyBtn;
/* 昵称 */
@property(nonatomic, strong)UILabel *titleLab;

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
}

- (void)initLayout
{
    [self requestWalletBalance];
    self.navigationItem.title = NSLocalizedString(@"wallet", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.pickupBtn];
    [self.view addSubview:self.recordBtn];
    [self.view addSubview:self.modifyBtn];
}

#pragma mark - network
- (void)requestWalletBalance
{
    WS(weakSelf);
    [[NetworkManager sharedManager] requestWithHTTPPath:@"http://39.108.152.114//modeltest/user/getbalance" parameters:@{@"userId":[NSString stringWithFormat:@"%ld",[UserInfoManager userID]]} constructingBody:nil progress:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([code isEqualToString:@"0"])
            {
                CGFloat money = [responseObject[@"object"] floatValue];
                weakSelf.titleLab.text = [NSString stringWithFormat:@"钱包  $%.2f",money];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
}

#pragma mark - action
//MARK: 支付历史
- (void)headerViewTapAction
{
    WalletRecordViewController *recordVC = [[WalletRecordViewController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (void)resetPassworldAction:(UIButton *)sender
{
    WalletResetPasswordViewController *resetpassword = [[WalletResetPasswordViewController alloc] init];
    [self.navigationController pushViewController:resetpassword animated:YES];
}

#pragma mark - lazy
- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 95)];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7.5, 80, 80)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[[UserInfoManager headpic] imgURLWithSize:imgView.frame.size]] placeholderImage:[UIImage imageNamed:@"addImage"]];
        [_headerView addSubview:imgView];
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+20, 32.5, CGRectGetWidth(self.view.frame)-(CGRectGetMaxX(imgView.frame)+20)-65, 30)];
        _titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleLab.font = [UIFont fontWithName:pageFontName size:14];
        _titleLab.text = @"钱包  $0";
        [_headerView addSubview:_titleLab];
        
        UIImageView *rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-30-10, (95-20)/2, 10, 20)];
        rightImgView.image = [UIImage imageNamed:@"arrow-right-1"];
        [_headerView addSubview:rightImgView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTapAction)];
        [_headerView addGestureRecognizer:tap];
    }
    return _headerView;
}

- (UIButton *)recordBtn
{
    if (!_recordBtn) {
        _recordBtn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-btnWidth)/2, CGRectGetMaxY(self.headerView.frame)+90, btnWidth, 50)];
        _recordBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:235/255.0 blue:184/255.0 alpha:1];
        [_recordBtn setTitle:NSLocalizedString(@"Payment history", nil) forState:UIControlStateNormal];
        [_recordBtn setTitleColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1] forState:UIControlStateNormal];
        _recordBtn.titleLabel.font = [UIFont fontWithName:buttonFontName size:14];
        [_recordBtn addTarget:self action:@selector(headerViewTapAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}

- (UIButton *)pickupBtn
{
    if (!_pickupBtn) {
        _pickupBtn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-btnWidth)/2, CGRectGetMaxY(self.headerView.frame)+25, btnWidth, 50)];
        _pickupBtn.backgroundColor = [UIColor colorWithHex:0xa7d7ff];
        [_pickupBtn setTitle:NSLocalizedString(@"withdraw", nil) forState:UIControlStateNormal];
        [_pickupBtn setTitleColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1] forState:UIControlStateNormal];
        _pickupBtn.titleLabel.font = [UIFont fontWithName:buttonFontName size:14];
    }
    return _pickupBtn;
}

- (UIButton *)modifyBtn
{
    if (!_modifyBtn) {
        _modifyBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.pickupBtn.frame), CGRectGetMaxY(self.recordBtn.frame)+15, CGRectGetWidth(self.pickupBtn.frame), CGRectGetHeight(self.pickupBtn.frame))];
        _modifyBtn.backgroundColor = [UIColor colorWithHex:0xa7d7ff];
        [_modifyBtn setTitle:NSLocalizedString(@"Setpaypassword", nil) forState:UIControlStateNormal];
        [_modifyBtn setTitleColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1] forState:UIControlStateNormal];
        _modifyBtn.titleLabel.font = [UIFont fontWithName:buttonFontName size:14];
        [_modifyBtn addTarget:self action:@selector(resetPassworldAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modifyBtn;
}

@end
