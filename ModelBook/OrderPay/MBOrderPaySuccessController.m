//
//  MBOrderPaySuccessController.m
//  ModelBook
//
//  Created by 高昇 on 2017/9/1.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "MBOrderPaySuccessController.h"
#import "Macros.h"
#import "UIColor+Ext.h"
#import "Const.h"
#import "WalletViewController.h"
#import "MBProfileMyJobsDetailController.h"
#import "ProfileViewController.h"
#import "JobCreateViewController.h"

@interface MBOrderPaySuccessController ()

/* button */
@property(nonatomic, strong)UIButton *backBtn;
/* label */
@property(nonatomic, strong)UILabel *label;

@end

@implementation MBOrderPaySuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)initLayout
{
    self.navigationItem.title = NSLocalizedString(@"Complete", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.label];
}

- (void)leftBtnAction:(UIButton *)btn
{
    [self backAction:btn];
}

- (void)backAction:(UIButton *)sender
{
    BaseTabBarViewController *controller = (BaseTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    controller.selectedIndex = SectionTypeProfile;
    BaseNavigationViewController *selectedController = (BaseNavigationViewController *)[controller showMainTabBarController:SectionTypeProfile];
    ProfileViewController *profileVC = [[ProfileViewController alloc] initWithUserId:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]]];
    profileVC.initialTabPage = InitialTabPageJobs;
    [selectedController setViewControllers:@[profileVC]];
}

#pragma mark - lazy
- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-250)/2, screenHeight-100-topBarHeight, 250, 50)];
        _backBtn.backgroundColor = [UIColor colorWithHex:0xa7d7ff];
        _backBtn.layer.cornerRadius = 3;
        [_backBtn setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _backBtn.titleLabel.font = [UIFont fontWithName:buttonFontName size:14];
        [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, CGRectGetWidth(self.view.frame), 30)];
        _label.text = NSLocalizedString(@"Pay Succeed", nil);
        _label.textColor = [UIColor blackColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont fontWithName:pageFontName size:14];
    }
    return _label;
}

@end
