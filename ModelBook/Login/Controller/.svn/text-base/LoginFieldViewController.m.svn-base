//
//  LoginFieldViewController.m
//  ModelBook
//
//  Created by zdjt on 2017/8/11.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "LoginFieldViewController.h"
#import "BaseTabBarViewController.h"
#import "AppDelegate.h"
#import <RongIMKit/RongIMKit.h>

@interface LoginFieldViewController ()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) NSArray *fieldImages;
@property (strong, nonatomic) NSArray *fieldTexts;
@property (strong, nonatomic) NSMutableArray *buttons;

@property (strong, nonatomic) NSMutableArray *idArray;

@end

@implementation LoginFieldViewController

- (NSMutableArray *)idArray {
    if (!_idArray) {
        _idArray = [NSMutableArray array];
    }
    return _idArray;
}

- (NSArray *)fieldImages {
    if (!_fieldImages) {
        if ([self.type isEqualToString:@"man"]) {
            _fieldImages = @[@"man00", @"man01", @"man02", @"man03", @"man04", @"man05", @"man06", @"man07", @"man08"];
        }else {
            _fieldImages = @[@"woman00", @"woman01", @"woman02", @"woman03", @"woman04", @"woman05", @"woman06", @"woman07", @"woman08"];
        }
    }
    return _fieldImages;
}

- (NSArray *)fieldTexts {
    if (!_fieldTexts) {
        _fieldTexts = @[NSLocalizedString(@"Advertisements", nil), NSLocalizedString(@"PhotoShoot", nil), NSLocalizedString(@"Swimsuite", nil), NSLocalizedString(@"RunWay", nil), NSLocalizedString(@"Outdoor", nil), NSLocalizedString(@"Underwear", nil), NSLocalizedString(@"CoverGuy", nil), NSLocalizedString(@"Street TaoBao", nil), NSLocalizedString(@"Events", nil)];
    }
    return _fieldTexts;
}

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setupBackItem];
    
    self.textLabel.text = NSLocalizedString(@"Choose Your Field", nil);
    self.textLabel.font = [UIFont fontWithName:pageFontName size:15.f];
    
    
    //三列
    int totalloc = 3;
    CGFloat margin = 35.f;
    CGFloat padding = 7.5;
    CGFloat textLabelH = 15;
    CGFloat itemW = (self.view.width - margin * 2 - padding * 2) / totalloc;
    CGFloat itemH = itemW + textLabelH;
    int count = (int)self.fieldImages.count;
    for (int i=0; i<count; i++) {
        int row=i/totalloc;//行号
        //1/3=0,2/3=0,3/3=1;
        int loc=i%totalloc;//列号
        
        CGFloat itemX = margin + (padding + itemW) * loc;
        CGFloat itemY = (padding + itemH) * row;
        
        //创建uiview控件
        UIView *itemView = [[UIView alloc]initWithFrame:CGRectMake(itemX, itemY, itemW, itemH)];
        [self.bottomView addSubview:itemView];
        
        UIImageView *itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemW, itemW)];
        itemImageView.image = [UIImage imageNamed:self.fieldImages[i]];
        [itemView addSubview:itemImageView];
        
        UIImageView *clickImageView = [[UIImageView alloc] initWithFrame:CGRectMake(itemW - 30, itemW - 30, 25, 25)];
        clickImageView.image = [UIImage imageNamed:@"image_selected"];
        clickImageView.tag = i * 10 + 1;
        clickImageView.hidden = YES;
        [itemView addSubview:clickImageView];
        
        UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        coverButton.frame = itemImageView.bounds;
        coverButton.tag = i;
        [coverButton addTarget:self action:@selector(coverButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:coverButton];
        [itemView addSubview:coverButton];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(itemImageView.frame), itemW, textLabelH)];
        textLabel.text = self.fieldTexts[i];
        textLabel.textAlignment = NSTextAlignmentCenter;
        if (IS_IPHONE5) {
            textLabel.font = [UIFont fontWithName:pageFontName size:10.f];
        }else {
            textLabel.font = [UIFont fontWithName:pageFontName size:12.f];
        }
        textLabel.textColor = [UIColor colorWithHex:0x999999];
        [itemView addSubview:textLabel];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor colorWithHex:0xA7D7FF];
    button.layer.cornerRadius = 3.f;
    button.layer.masksToBounds = YES;
    [button setTitle:NSLocalizedString(@"introTextA", nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(nextButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:button];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE5) {
            make.top.equalTo(self.bottomView.mas_top).offset(padding * 2 + itemH * 3 + 20);
        }else {
            make.top.equalTo(self.bottomView.mas_top).offset(padding * 2 + itemH * 3 + 35);
        }
        make.left.equalTo(self.bottomView.mas_left).offset(35.f);
        make.right.equalTo(self.bottomView.mas_right).offset(-35.f);
        make.height.mas_equalTo(Adapter_Y(50.f));
    }];
}

- (void)coverButtonEvent:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    UIImageView *imageView = [self.bottomView viewWithTag:sender.tag * 10 + 1];
    imageView.hidden = !sender.isSelected;
}

- (void)nextButtonEvent:(UIButton *)sender {
    int i = 0;
    for (UIButton *button in self.buttons) {
        if (button.isSelected) {
            i++;
            [self.idArray addObject:@(button.tag+1)];
        }
    }
    if (i == 0) {
        [CustomHudView showWithTip:@"请选择领域"];
        return;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:self.params];
    NSString *str= @"";
    NSArray *tempArray = [self.idArray copy];
    for (NSNumber *temp in tempArray) {
        str = [NSString stringWithFormat:@"%@,%@",str, temp];
    }
    dict[@"fieldId"] = [str substringFromIndex:1];
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
        NSLog(@"-----%@",error);
    }];
}

@end
