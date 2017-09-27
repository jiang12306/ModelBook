//
//  PersonInfoCompanyViewController.m
//  ModelBook
//
//  Created by zdjt on 2017/8/14.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "PersonInfoCompanyViewController.h"
#import "PersonInfoAddressViewController.h"
#import "BaseTabBarViewController.h"
#import "AppDelegate.h"
#import <RongIMKit/RongIMKit.h>

@interface PersonInfoCompanyViewController ()

@property (weak, nonatomic) IBOutlet MBTextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *womanButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLeftImageViewLeftCons;

@property (weak, nonatomic) UIButton *selectedButton;

@property (copy, nonatomic) NSString *sex;

@end

@implementation PersonInfoCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackItem];
    
    self.addressTextField.placeholder = NSLocalizedString(@"Address", nil);
    
    self.addressTextField.font = [UIFont fontWithName:pageFontName size:15.f];
    
    self.addressLeftImageViewLeftCons.constant = Adapter_X(80.f);
    
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

- (IBAction)addressButtonEvent:(UIButton *)sender {
    [self performSegueWithIdentifier:@"address" sender:nil];
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
    if (self.selectedButton == self.manButton) {
        self.sex = @"m";
    }else {
        self.sex = @"f";
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:self.params];
    dict[@"address"] = self.addressTextField.text;
    dict[@"sex"] = self.sex;
    dict[@"userId"] = @([UserInfoManager userID]);
    [self networkWithPath:@"user/register" parameters:dict success:^(id responseObject) {
        NSNumber *code = responseObject[@"code"];
        if (code.intValue == 0) {
            NSDictionary *objDict = responseObject[@"object"];
            NSDictionary *userDict = objDict[@"user"];
            NSDictionary *tokenDict = objDict[@"token"];
            if ([userDict isKindOfClass:[NSDictionary class]]) {
                NSNumber *uid = userDict[@"userId"];
                NSString *username = userDict[@"username"];
                NSString *nick = userDict[@"nickname"];
                NSString *headpic = userDict[@"headpic"];
                [UserInfoManager setUserID:uid.longValue];
                [UserInfoManager setUserName:username];
                [UserInfoManager setNickName:nick];
                [UserInfoManager setHeadpic:headpic];
            }
            if ([tokenDict isKindOfClass:[NSDictionary class]]) {
                NSString *token = tokenDict[@"token"];
                [UserInfoManager setToken:token];
            }
            [[RCIM sharedRCIM] connectWithToken:[UserInfoManager token] success:^(NSString *userId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[RCIM sharedRCIM] setCurrentUserInfo:[[RCUserInfo alloc] initWithUserId:userId name:[UserInfoManager userName] portrait:[UserInfoManager headpic]]];
                });
            } error:^(RCConnectErrorCode status) {
                
            } tokenIncorrect:^{
                
            }];
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate switchRootViewController];
        }
        [CustomHudView showWithTip:responseObject[@"msg"]];
    } failure:^(NSError *error) {
        
    }];
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
    }
}

@end
