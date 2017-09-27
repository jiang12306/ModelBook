//
//  LoginViewController.m
//  ModelBook
//
//  Created by zdjt on 2017/8/7.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "LoginViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "AppDelegate.h"
#import <RongIMKit/RongIMKit.h>
#import "PersonInfoViewController.h"
#import "RegisterViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMessage.h"

@interface LoginViewController () <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userNameLeftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pwdLeftImageView;
@property (weak, nonatomic) IBOutlet MBTextField *userNameTextField;
@property (weak, nonatomic) IBOutlet MBTextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *wechatLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoImageViewTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameLeftImageViewTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pwdLeftImageViewTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wechatLoginButtonHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerButtonHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wechatLoginButtonTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerButtonTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameLeftImageLeftCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pwdLeftImageViewLeftCons;

@property (weak, nonatomic) IBOutlet UIButton *forgetButton;

@property (copy, nonatomic) NSString *temp;

@end

@implementation LoginViewController

+ (BaseNavigationViewController *)instantiateNavigationController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:@"LoginNavSBID"];
}
+ (LoginViewController *)instantiateLoginViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:@"LoginVCSBID"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 去掉线 changed by gaosheng */
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.loginButton.layer.cornerRadius = 3.f;
    self.loginButton.layer.masksToBounds = YES;
    self.wechatLoginButton.layer.cornerRadius = 3.f;
    self.wechatLoginButton.layer.masksToBounds = YES;
    self.registerButton.layer.cornerRadius = 3.f;
    self.registerButton.layer.masksToBounds = YES;
    
    self.userNameTextField.placeholder = NSLocalizedString(@"loginUserNamePlaceholder", nil);
    self.pwdTextField.placeholder = NSLocalizedString(@"loginPwdPlaceholder", nil);
    [self.loginButton setTitle:NSLocalizedString(@"loginButtonTextA", nil) forState:UIControlStateNormal];
    [self.wechatLoginButton setTitle:NSLocalizedString(@"loginButtonTextB", nil) forState:UIControlStateNormal];
    [self.wechatLoginButton setImage:[[UIImage imageNamed:@"login_wechat"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    if (IS_IPHONE5) {
        [self.wechatLoginButton setImageEdgeInsets:UIEdgeInsetsMake(0, -Adapter_X(70.f), 0, 0)];
    }else {
        [self.wechatLoginButton setImageEdgeInsets:UIEdgeInsetsMake(0, -Adapter_X(110.f), 0, 0)];
    }
    [self.registerButton setTitle:NSLocalizedString(@"loginButtonTextC", nil) forState:UIControlStateNormal];
    
    self.logoImageViewTopCons.constant = Adapter_Y(60.f);
    self.userNameLeftImageViewTopCons.constant = Adapter_Y(50.f);
    self.userNameLeftImageLeftCons.constant = Adapter_X(100.f);
    self.pwdLeftImageViewTopCons.constant = Adapter_Y(40.f);
    self.pwdLeftImageViewLeftCons.constant = Adapter_X(100.f);
    self.logoImageViewTopCons.constant = Adapter_Y(20.f);
    self.loginButtonTopCons.constant = Adapter_Y(50.f);
    self.wechatLoginButtonTopCons.constant = Adapter_Y(20.f);
    self.registerButtonTopCons.constant = Adapter_Y(20.f);
    
    self.loginButton.titleLabel.font = [UIFont fontWithName:buttonFontName size:18.f];
    self.wechatLoginButton.titleLabel.font = [UIFont fontWithName:buttonFontName size:18.f];
    self.registerButton.titleLabel.font = [UIFont fontWithName:buttonFontName size:18.f];
    self.userNameTextField.font = [UIFont fontWithName:pageFontName size:15.f];
    self.pwdTextField.font = [UIFont fontWithName:pageFontName size:15.f];
    self.forgetButton.titleLabel.font = [UIFont fontWithName:pageFontName size:13.f];
    
    self.userNameTextField.text = [UserInfoManager userName];
    self.pwdTextField.text = [UserInfoManager password];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - ButtonEvent

- (IBAction)loginButtonEvent:(UIButton *)sender {
    if (self.userNameTextField.text.length == 0 || self.pwdTextField.text.length == 0) {
        [CustomHudView showWithTip:@"请完善登录信息"];
        return;
    }
    [self networkWithPath:@"user/login"
               parameters:@{
                            @"username" : self.userNameTextField.text,
                            @"password" : self.pwdTextField.text
                            }
                  success:^(id responseObject) {
                      NSNumber *code = responseObject[@"code"];
                      if (code.intValue == 0) {
                          // 已登录
                          [UserInfoManager setIsLogin:@"1"];
                          
                          NSDictionary *objDict = responseObject[@"object"];
                          NSDictionary *userDict = objDict[@"user"];
                          NSDictionary *tokenDict = objDict[@"token"];
                          if ([userDict isKindOfClass:[NSDictionary class]]) {
                              NSNumber *uid = userDict[@"userId"];
                              NSString *username = userDict[@"username"];
                              NSString *pwd = self.pwdTextField.text;
                              NSString *nick = userDict[@"nickname"];
                              NSString *headpic = userDict[@"headpic"];
                              [UserInfoManager setUserID:uid.longValue];
                              [UserInfoManager setUserName:username];
                              [UserInfoManager setPassword:pwd];
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
                          
                          // 设置别名
                          [UMessage setAlias:[NSString stringWithFormat:@"%ld",[UserInfoManager userID]] type:@"modelbook" response:^(id responseObject, NSError *error) {
                              if (error) {
                                  NSLog(@"error----%@",error);
                              }else {
                                  NSLog(@"success-----");
                              }
                          }];
                          [self switchEvent];
                      }else {
                          [CustomHudView showWithTip:responseObject[@"msg"]];
                      }
                  }
                  failure:^(NSError *error) {
                      NSLog(@"-----%@",error);
                  }];
}

- (IBAction)wechatButtonEvent:(UIButton *)sender {
    [self getAuthWithUserInfoFromWechat];
}

- (IBAction)registerButtonEvent:(UIButton *)sender {
    self.temp = @"Register";
    [self performSegueWithIdentifier:@"register" sender:nil];
}

- (void)getAuthWithUserInfoFromWechat
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            [self networkWithPath:@"user/login/wechat" parameters:@{@"openid":resp.openid,@"headpic":resp.originalResponse[@"headimgurl"]} success:^(id responseObject) {
                NSNumber *code = responseObject[@"code"];
                if (code.intValue == 0) {
                    // 已登录
                    [UserInfoManager setIsLogin:@"1"];
                    
                    NSDictionary *objDict = responseObject[@"object"];
                    NSDictionary *tokenDict = objDict[@"token"];
                    NSString *token = tokenDict[@"token"];
                    NSDictionary *userDict = objDict[@"user"];
                    NSNumber *uid = userDict[@"userId"];
                    NSString *username = userDict[@"username"];
                    [UserInfoManager setUserID:uid.longValue];
                    [UserInfoManager setHeadpic:userDict[@"headpic"]];
                    [UserInfoManager setToken:token];
                    [[RCIM sharedRCIM] connectWithToken:[UserInfoManager token] success:^(NSString *userId) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[RCIM sharedRCIM] setCurrentUserInfo:[[RCUserInfo alloc] initWithUserId:userId name:username portrait:[UserInfoManager headpic]]];
                        });
                    } error:^(RCConnectErrorCode status) {
                        
                    } tokenIncorrect:^{
                        
                    }];
                    // 设置别名
                    [UMessage setAlias:[NSString stringWithFormat:@"%@",uid] type:@"modelbook" response:^(id responseObject, NSError *error) {
                        if (error) {
                            NSLog(@"error----%@",error);
                        }else {
                            NSLog(@"success-----");
                        }
                    }];
                    [self switchEvent];
                }else if (code.intValue == 60156) {
                    PersonInfoViewController *controller = [PersonInfoViewController instantiatePersonInfoViewController];
                    controller.controllerFrom = @"wechat";
                    [self.navigationController pushViewController:controller animated:YES];
                }
            } failure:^(NSError *error) {
                
            }];
            
            // 授权信息
            //            NSLog(@"Wechat uid: %@", resp.uid);
            //            NSLog(@"Wechat openid: %@", resp.openid);
            //            NSLog(@"Wechat unionid: %@", resp.unionId);
            //            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            //            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            //            NSLog(@"Wechat expiration: %@", resp.expiration);
            //
            //            // 用户信息
            //            NSLog(@"Wechat name: %@", resp.name);
            //            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            //            NSLog(@"Wechat gender: %@", resp.unionGender);
            //
            //            // 第三方平台SDK源数据
            //            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
        }
    }];
}

- (void)switchEvent
{
    NSString *targetid = [UserInfoManager targetid];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (targetid.length == 0) {
        [delegate switchRootViewController];
    }else {
        [delegate switchRootViewControllerWithSection:SectionTypeChat];
    }
}

- (IBAction)forgetButtonEvent:(UIButton *)sender {
    self.temp = @"Forget";
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"找回密码", nil];
    [sheet showInView:self.navigationController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:@"register" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"register"]) {
        RegisterViewController *controller = segue.destinationViewController;
        controller.controllerFrom = self.temp;
    }
}

@end
