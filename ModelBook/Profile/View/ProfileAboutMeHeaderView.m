//
//  ProfileAboutMeHeaderView.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/24.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileAboutMeHeaderView.h"
#import "ProfileUserInfoModel.h"
#import "UIColor+Ext.h"
#import "Const.h"
#import "Macros.h"
#import "ProgressHUD.h"

@interface ProfileAboutMeHeaderView () <UIActionSheetDelegate>

/* titleArray */
@property(nonatomic, strong)NSArray *titleArray;
/* detailArray */
@property(nonatomic, strong)NSArray *detailArray;
@property (nonatomic, strong) UILabel* authenticationLab;

//Chiang
@property (nonatomic, copy) SelectAuthorizeType type;

@end

@implementation ProfileAboutMeHeaderView

- (void)initLayout
{
    self.backgroundColor = [UIColor whiteColor];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat offset_x = 0;
    CGFloat offset_y = 0;
    for (int i = 0; i<self.titleArray.count; i++)
    {
        offset_x = 20+i%2*screenWidth/2;
        offset_y = 5+i/2*30;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offset_x, offset_y, screenWidth/2, 30)];

        if (i == self.titleArray.count-2)
        {//绑定微博
            NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self.titleArray[i] attributes:attribtDic];
            label.attributedText = attribtStr;
            label.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weiboAction:)];
            [label addGestureRecognizer:tap];
        }
#pragma mark -Chiang
        else if (i == self.titleArray.count-1)
        {//认证，具体状态根据后台返回参数来定
            NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self.titleArray[i] attributes:attribtDic];
            label.attributedText = attribtStr;
            label.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(authenticationAction:)];
            [label addGestureRecognizer:tap];
            self.authenticationLab = label;
        }
        else
        {
            label.text = [NSString stringWithFormat:@"%@：%@",self.titleArray[i],self.detailArray[i]];
        }
        
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        label.font = [UIFont fontWithName:pageFontName size:12];
        [self addSubview:label];
    }
    
    offset_y += 35;
    self.frame = CGRectMake(0, 0, screenWidth, offset_y);
}

#pragma mark - action
- (void)weiboAction:(UITapGestureRecognizer *)tap
{
    [ProgressHUD showText:@"施工中"];
}

#pragma mark -Chiang
-(void)authenticationAction:(UITapGestureRecognizer* )tapGR {
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"选择认证类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"个人认证", @"企业认证", nil];
    [sheet showInView:self];
}

//Chiang   选择认证类型
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        self.type(1);
    }else if (buttonIndex == 1) {
        self.type(2);
    }
}

//Chiang
-(void)clickedSelectAuthorizeType:(SelectAuthorizeType)type {
    self.type = type;
}


- (void)setUserInfoModel:(ProfileUserInfoModel *)userInfoModel
{
    _userInfoModel = userInfoModel;
    [self initLayout];
}

#pragma mark - lazy
- (NSArray *)titleArray
{
    if (!_titleArray) {
        
        _titleArray = @[NSLocalizedString(@"ProfileCategory", nil),NSLocalizedString(@"ProfileAddress", nil),NSLocalizedString(@"Price per posting", nil),NSLocalizedString(@"Day Rate", nil),NSLocalizedString(@"Height", nil),NSLocalizedString(@"Hour Rate", nil),NSLocalizedString(@"Weight", nil),NSLocalizedString(@"Age", nil),NSLocalizedString(@"Binding weibo", nil),NSLocalizedString(@"Profile Unauthorized", nil)];//Chiang
    }
    return _titleArray;
}

- (NSArray *)detailArray
{
    if (!_detailArray) {
        _detailArray = @[userTypeStr(_userInfoModel.userTypeId),_userInfoModel.address,@"￥2000",[NSString stringWithFormat:@"￥%@",_userInfoModel.dayRate],[NSString stringWithFormat:@"%@cm",_userInfoModel.height],[NSString stringWithFormat:@"￥%@",_userInfoModel.hourRate],[NSString stringWithFormat:@"%@Kg",_userInfoModel.weight],_userInfoModel.age,@""];
    }
    return _detailArray;
}

@end
