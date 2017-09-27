//
//  ProfileInfoView.m
//  ModelBook
//
//  Created by 高昇 on 2017/8/21.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "ProfileInfoView.h"
#import "Macros.h"
#import "UIColor+Ext.h"
#import "Const.h"
#import <UIImageView+WebCache.h>
#import "NSString+imgURL.h"
#import <HCSStarRatingView.h>

#define leftNickNameSpace 24
#define rightNickNameSpace (IS_IPHONE320?80:90)
#define leftEdge 10

static CGFloat const portraitWidth = 90;
static CGFloat const topEdge = 12;
static CGFloat const aboutTopSpace = 14;
static CGFloat const aboutWidth = 90;

@interface ProfileInfoView ()

/* 头像 */
@property(nonatomic, strong)UIImageView *imgView;
/* 昵称 */
@property(nonatomic, strong)UILabel *nickNameLabel;
/* 详情 */
@property(nonatomic, strong)UIButton *aboutBtn;
/* 箭头 */
@property(nonatomic, strong)UIImageView *nextImgView;
/* 粉丝 */
@property(nonatomic, strong)UIButton *followersBtn;
/* 聊天/编辑 */
@property(nonatomic, strong)UIButton *chatButton;
/* 评分 */
@property(nonatomic, strong)HCSStarRatingView *pointView;

@end

@implementation ProfileInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initLayout];
    }
    return self;
}

- (void)initLayout
{
    [self addSubview:self.imgView];
    [self addSubview:self.nickNameLabel];
    [self addSubview:self.aboutBtn];
    [self addSubview:self.nextImgView];
    [self addSubview:self.followersBtn];
    [self addSubview:self.chatButton];
    [self addSubview:self.pointView];
}

- (void)buttonClickAction:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"Logout", nil)])
    {
        tag = InfoClickTypeEdit;
    }
    if (_profileInfoButtonClicked) _profileInfoButtonClicked(tag);
}

- (void)headerPicAction:(UITapGestureRecognizer *)tap
{
    if (_profileInfoPhotoButtonClicked) _profileInfoPhotoButtonClicked((UIImageView *)tap.view);
}

#pragma mark - setting方法
- (void)setUserInfoModel:(ProfileUserInfoModel *)userInfoModel
{
    _userInfoModel = userInfoModel;
    _nickNameLabel.text = userInfoModel.nickname;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[userInfoModel.headpic imgURLWithSize:_imgView.frame.size]] placeholderImage:[UIImage imageNamed:@"addImage"]];
    CGFloat point = [userInfoModel.point floatValue];
    if (point<=0) point = 5;
    _pointView.value = point;
    [self checkBtnState];
}

//MARK: 如果是自己，显示粉丝，如果是别人，显示关注
- (void)setUserInfoType:(ProfileInfoType)userInfoType
{
    _userInfoType = userInfoType;
    [self.followersBtn setTitle:NSLocalizedString(@"profileAttention", nil) forState:UIControlStateNormal];
    self.followersBtn.tag = 2;
    if (_userInfoType == ProfileInfoTypeSelf)
    {
        self.followersBtn.tag = 5;
        [self.followersBtn setTitle:NSLocalizedString(@"profileFollowers", nil) forState:UIControlStateNormal];
        [self.aboutBtn setTitle:NSLocalizedString(@"profileAboutMe", nil) forState:UIControlStateNormal];
        [self.aboutBtn setTitle:NSLocalizedString(@"profileAboutMe", nil) forState:UIControlStateSelected];
    }
    [self checkBtnState];
}

- (void)setIsAboutMe:(BOOL)isAboutMe
{
    _isAboutMe = isAboutMe;
    self.aboutBtn.hidden = NO;
    self.nextImgView.hidden = NO;
    if (_isAboutMe)
    {
        self.aboutBtn.hidden = YES;
        self.nextImgView.hidden = YES;
    }
    [self checkBtnState];
}

- (void)checkBtnState
{
    self.pointView.hidden = YES;
    if (_userInfoType == ProfileInfoTypeSelf)
    {
        self.chatButton.hidden = YES;
        [self.chatButton setTitleColor:[UIColor colorWithHex:0xa7d7ff] forState:UIControlStateNormal];
        [self.chatButton setTitle:NSLocalizedString(@"profileChat", nil) forState:UIControlStateNormal];
        if (_isAboutMe)
        {
            self.pointView.hidden = NO;
            self.chatButton.hidden = NO;
            [self.chatButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            [self.chatButton setTitle:NSLocalizedString(@"Logout", nil) forState:UIControlStateNormal];
        }
    }
    else
    {
        self.chatButton.hidden = YES;
        [self.chatButton setTitleColor:[UIColor colorWithHex:0xa7d7ff] forState:UIControlStateNormal];
        [self.chatButton setTitle:NSLocalizedString(@"profileChat", nil) forState:UIControlStateNormal];
        if (_isAboutMe)
        {
            self.pointView.hidden = NO;
            [self.chatButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        }
        if (_userInfoModel.canChat)
        {
            self.chatButton.hidden = NO;
        }
    }
}

#pragma mark - lazy
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(leftEdge, topEdge, portraitWidth, portraitWidth)];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.masksToBounds = YES;
        _imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerPicAction:)];
        [_imgView addGestureRecognizer:tap];
    }
    return _imgView;
}

- (UILabel *)nickNameLabel
{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imgView.frame)+leftNickNameSpace, CGRectGetMinY(self.imgView.frame)+aboutTopSpace, screenWidth-(CGRectGetMaxX(self.imgView.frame)+leftNickNameSpace)-rightNickNameSpace, 22)];
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
        _nickNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _nickNameLabel.font = [UIFont fontWithName:pageFontName size:20];
        _nickNameLabel.text = @"";
    }
    return _nickNameLabel;
}

- (UIButton *)aboutBtn
{
    if (!_aboutBtn) {
        _aboutBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nextImgView.frame)+8, CGRectGetMinY(self.nextImgView.frame), aboutWidth, 26)];
        [_aboutBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [_aboutBtn setTitleColor:[UIColor colorWithHex:0xa7d7ff] forState:UIControlStateSelected];
        [_aboutBtn setTitle:NSLocalizedString(@"profileAbout", nil) forState:UIControlStateNormal];
        [_aboutBtn setTitle:NSLocalizedString(@"profileAbout", nil) forState:UIControlStateSelected];
        _aboutBtn.titleLabel.font = [UIFont fontWithName:pageFontName size:14];
        _aboutBtn.tag = 1;
        _aboutBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_aboutBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _aboutBtn;
}

- (UIImageView *)nextImgView
{
    if (!_nextImgView) {
        _nextImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nickNameLabel.frame), CGRectGetMaxY(self.imgView.frame)-aboutTopSpace-26+8, 26, 26)];
        _nextImgView.image = [UIImage imageNamed:@"aboutme"];
    }
    return _nextImgView;
}

- (UIButton *)followersBtn
{
    if (!_followersBtn) {
        _followersBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-rightNickNameSpace, CGRectGetMinY(self.nickNameLabel.frame), rightNickNameSpace-leftEdge, 22)];
        [_followersBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [_followersBtn setTitle:NSLocalizedString(@"profileFollowers", nil) forState:UIControlStateNormal];
        _followersBtn.titleLabel.font = [UIFont fontWithName:pageFontName size:14];
        _followersBtn.tag = 2;
        [_followersBtn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followersBtn;
}

- (UIButton *)chatButton
{
    if (!_chatButton) {
        _chatButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.followersBtn.frame), CGRectGetMinY(self.aboutBtn.frame), CGRectGetWidth(self.followersBtn.frame), 26)];
        [_chatButton setTitleColor:[UIColor colorWithHex:0xa7d7ff] forState:UIControlStateNormal];
        [_chatButton setTitle:NSLocalizedString(@"profileChat", nil) forState:UIControlStateNormal];
        _chatButton.titleLabel.font = [UIFont fontWithName:pageFontName size:14];
        [_chatButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _chatButton.tag = 3;
    }
    return _chatButton;
}

- (HCSStarRatingView *)pointView
{
    if (!_pointView) {
        _pointView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nickNameLabel.frame), CGRectGetMaxY(self.imgView.frame)-aboutTopSpace-26+9, 19*5, 19)];
        _pointView.maximumValue = 5;
        _pointView.minimumValue = 0;
        _pointView.spacing = 1;
        _pointView.value = 5;
        _pointView.allowsHalfStars = YES;
        _pointView.userInteractionEnabled = NO;
        _pointView.tintColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
    }
    return _pointView;
}

@end
