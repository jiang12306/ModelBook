//
//  VerCodeViewController.m
//  ModelBook
//
//  Created by zdjt on 2017/8/8.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "VerCodeViewController.h"
#import "MQVerCodeInputView.h"
#import "Masonry.h"
#import "TTTAttributedLabel.h"
#import "UIColor+Ext.h"
#import <POP.h>
#import "PersonInfoViewController.h"
#import "WLUnitField.h"

@interface VerCodeViewController () <TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *desLabelA;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoImageViewTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *desLabelTopCons;

@property (weak, nonatomic) TTTAttributedLabel *desLabelB;
@property (weak, nonatomic) WLUnitField *textField;

@end

@implementation VerCodeViewController

+ (VerCodeViewController *)instantiateVerCodeViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:@"CodeVCSBID"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self setupBackItem];
    
    self.desLabelA.text = NSLocalizedString(@"verCodeDesA", nil);
    
    self.logoImageViewTopCons.constant = Adapter_Y(60.f);
    self.desLabelTopCons.constant = Adapter_Y(50.f);
    self.desLabelA.font = [UIFont fontWithName:pageFontName size:15.f];
    
    UIView *codeBackgroundView = [[UIView alloc] init];
    [self.view addSubview:codeBackgroundView];
    [codeBackgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [codeBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desLabelA.mas_bottom).offset(10.f);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(55.f);
    }];
    
    WLUnitField *textField = [[WLUnitField alloc] initWithInputUnitCount:4];
    self.textField = textField;
    textField.frame = CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds) - 250.f) * 0.5, 0.f, 250.f, 55.f);
    textField.unitSpace = 10.f;
    textField.textFont = [UIFont fontWithName:pageFontName size:25.f];
    textField.borderWidth = 0.5f;
    textField.trackTintColor = [UIColor colorWithHex:0xc6c6c6];
    textField.tintColor = [UIColor whiteColor];
    textField.textColor = [UIColor whiteColor];
    textField.cursorColor = [UIColor whiteColor];
    textField.backgroundColor = [UIColor colorWithHex:0xc6c6c6];
    [textField sizeToFit];
    [textField addTarget:self action:@selector(valueChangedEvent:) forControlEvents:UIControlEventEditingChanged];
    [codeBackgroundView addSubview:textField];
    
    for (int i  = 0; i < 3; i++) {
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake((i + 1) * 55 + i * 10, 0, 10, 55)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [textField addSubview:whiteView];
    }
    
    // 验证码输入框
//    MQVerCodeInputView *verView = [[MQVerCodeInputView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 55.f)];
//    verView.maxLenght = 4;
//    verView.viewColor = [UIColor whiteColor];
//    verView.viewColorHL = [UIColor whiteColor];
//    verView.keyBoardType = UIKeyboardTypeNumberPad;
//    [verView mq_verCodeViewWithMaxLenght];
//    verView.block = ^(NSString *text){
//        NSLog(@"text = %@",text);
//        if (text.length == 4) {
//            // 验证码校验
//            if (text.intValue == self.vercode.intValue) {
//                //                [self networkWithPath:@"user/register" parameters:@{@"phone":self.phone} success:^(id responseObject) {
//                //                    NSNumber *code = responseObject[@"code"];
//                //                    NSDictionary *objDict = responseObject[@"object"];
//                //                    NSDictionary *tokenDict = objDict[@"token"];
//                //                    NSString *token = tokenDict[@"token"];
//                //                    NSDictionary *userDict = objDict[@"user"];
//                //                    NSNumber *uid = userDict[@"userId"];
//                //                    [UserInfoManager setUserID:uid.longValue];
//                //                    [UserInfoManager setHeadpic:userDict[@"headpic"]];
//                //                    [UserInfoManager setToken:token];
//                //                    if (code.intValue == 0) {
//                PersonInfoViewController *controller = [PersonInfoViewController instantiatePersonInfoViewController];
//                controller.phone = self.phone;
//                [self.navigationController pushViewController:controller animated:YES];
//                //                    }else {
//                //                        [CustomHudView showWithTip:responseObject[@"msg"]];
//                //                    }
//                //                } failure:^(NSError *error) {
//                //
//                //                }];
//                
//            }else {
//                [CustomHudView showWithTip:@"验证码错误"];
//            }
//        }
//    };
//    [codeBackgroundView addSubview:verView];
    
    TTTAttributedLabel *desLabelB = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.desLabelB = desLabelB;
    desLabelB.textColor = [UIColor colorWithHex:0x999999];
    desLabelB.font            = [UIFont fontWithName:pageFontName size:11.f];
    desLabelB.numberOfLines   = 0;
    desLabelB.textAlignment = NSTextAlignmentCenter;
    desLabelB.linkAttributes       = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0x999999],
                                       NSFontAttributeName:[UIFont fontWithName:pageFontName size:11.f]};
    desLabelB.activeLinkAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0x999999],
                                       NSFontAttributeName:[UIFont fontWithName:pageFontName size:11.f]};
    desLabelB.delegate = self;
    [self.view addSubview:desLabelB];
    [desLabelB setTranslatesAutoresizingMaskIntoConstraints:NO];
    [desLabelB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeBackgroundView.mas_bottom).offset(15.f);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    [self createCountdown];
}

- (void)createCountdown
{
    self.desLabelB.enabled = NO;
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"countdown" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            int second = (int)values[0];
            if (second == 0) {
                self.desLabelB.enabled = YES;
                [self.desLabelB pop_removeAnimationForKey:@"countdown"];
                NSString *temp = [NSString stringWithFormat:@"%@%d%@",NSLocalizedString(@"verCodeDesBPartA", nil),0, NSLocalizedString(@"verCodeDesBPartB", nil)];
                NSRange serviceRange = [temp rangeOfString:NSLocalizedString(@"verCodeDesC", nil)];
                [self.desLabelB setText:temp afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x999999] range:serviceRange];
                    [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:pageFontName size:11.f] range:serviceRange];
                    [mutableAttributedString addAttribute:NSUnderlineStyleAttributeName value:@(1) range:serviceRange];
                    [mutableAttributedString addAttribute:NSUnderlineColorAttributeName value:[UIColor colorWithHex:0x999999] range:serviceRange];
                    return mutableAttributedString;
                }];
                [self.desLabelB addLinkToURL:[NSURL URLWithString:@""] withRange:serviceRange];
            }else {
                NSString *temp = [NSString stringWithFormat:@"%@%d%@",NSLocalizedString(@"verCodeDesBPartA", nil),second, NSLocalizedString(@"verCodeDesBPartB", nil)];
                NSRange serviceRange = [temp rangeOfString:NSLocalizedString(@"verCodeDesC", nil)];
                [self.desLabelB setText:temp afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x999999] range:serviceRange];
                    [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:pageFontName size:11.f] range:serviceRange];
                    [mutableAttributedString addAttribute:NSUnderlineStyleAttributeName value:@(1) range:serviceRange];
                    [mutableAttributedString addAttribute:NSUnderlineColorAttributeName value:[UIColor colorWithHex:0x999999] range:serviceRange];
                    return mutableAttributedString;
                }];
                [self.desLabelB addLinkToURL:[NSURL URLWithString:@""] withRange:serviceRange];
            }
            
        };
    }];
    POPBasicAnimation *anBasic = [POPBasicAnimation linearAnimation];
    anBasic.property = prop;
    anBasic.fromValue = @(60);
    anBasic.toValue = @(0);
    anBasic.duration = 60;
    anBasic.beginTime = CACurrentMediaTime();
    [self.desLabelB pop_addAnimation:anBasic forKey:@"countdown"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.desLabelB.enabled = NO;
    [self.desLabelB pop_removeAnimationForKey:@"countdown"];
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    // 2.发送注册验证码
    [self networkWithPath:@"user/register/send_code" parameters:@{@"phone" : self.phone} success:^(id responseObject) {
        NSNumber *code = responseObject[@"code"];
        if (code.intValue == 0) {
            NSString *vercode = responseObject[@"object"];
            self.vercode = vercode;
        }
        [CustomHudView showWithTip:responseObject[@"msg"]];
    } failure:^(NSError *error) {
        
    }];
    [self createCountdown];
}

- (void)valueChangedEvent:(WLUnitField *)sender {
    
    NSLog(@"-----%@-----%@",sender.text, self.vercode);
    if (sender.text.length == 4) {
        // 验证码校验
        if (sender.text.intValue == self.vercode.intValue) {
            [self.view endEditing:YES];

            PersonInfoViewController *controller = [PersonInfoViewController instantiatePersonInfoViewController];
            controller.phone = self.phone;
            [self.navigationController pushViewController:controller animated:YES];
        }else {
            self.textField.text = @"";
        }
    }
}

@end
