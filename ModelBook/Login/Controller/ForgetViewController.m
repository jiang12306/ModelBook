//
//  ForgetViewController.m
//  ModelBook
//
//  Created by zdjt on 2017/9/8.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ForgetViewController.h"
#import "TTTAttributedLabel.h"
#import "WLUnitField.h"
#import <POP.h>
#import "ResetViewController.h"

@interface ForgetViewController () <TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UILabel *deslabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *codeBackgroundView;

@property (weak, nonatomic) TTTAttributedLabel *desLabelB;
@property (weak, nonatomic) WLUnitField *textField;

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.deslabel.font = [UIFont fontWithName:pageFontName size:15.f];
    self.deslabel.textColor = [UIColor colorWithHex:0x999999];
    
    self.phoneLabel.font = [UIFont fontWithName:pageFontName size:15.f];
    self.phoneLabel.textColor = [UIColor blackColor];
    self.phoneLabel.text= [NSString stringWithFormat:@"%@****%@",[self.phone substringToIndex:3], [self.phone substringFromIndex:self.phone.length - 3]];
    
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
    [self.codeBackgroundView addSubview:textField];
    
    for (int i  = 0; i < 3; i++) {
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake((i + 1) * 55 + i * 10, 0, 10, 55)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [textField addSubview:whiteView];
    }
    
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
        make.top.equalTo(self.codeBackgroundView.mas_bottom).offset(15.f);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    [self createCountdown];
    
    [self.textField becomeFirstResponder];
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
    [self networkWithPath:@"user/backpwd" parameters:@{@"phone" : self.phone} success:^(id responseObject) {
        NSNumber *code = responseObject[@"code"];
        if (code.intValue == 0) {
            NSNumber *vercode = responseObject[@"object"];
            self.vercode = [NSString stringWithFormat:@"%@",vercode];
        }else {
            [CustomHudView showWithTip:responseObject[@"msg"]];
        }
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
            
            [self performSegueWithIdentifier:@"reset" sender:nil];
        }else {
            self.textField.text = @"";
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"reset"]) {
        ResetViewController *controller = segue.destinationViewController;
        controller.phone = self.phone;
    }
}

@end
