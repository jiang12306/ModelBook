//
//  ProfileInfoView.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/21.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileUserInfoModel.h"

/**
 简介类型
 
 - ProfileTypeSelf: 自己
 - ProfileTypeOther: 他人
 */
typedef NS_ENUM(NSInteger, ProfileInfoType) {
    ProfileInfoTypeSelf,
    ProfileInfoTypeOther
};

/**
 界面点击类型

 - InfoClickTypeAboutMe: 关于我
 - InfoClickTypeFollowers: 粉丝
 - InfoClickTypeChat: 聊天
 - InfoClickTypeEdit: 编辑
 */
typedef NS_ENUM(NSInteger, InfoClickType) {
    InfoClickTypeAboutMe = 1,
    InfoClickTypeFollowers,
    InfoClickTypeChat,
    InfoClickTypeEdit,
    InfoClickTypeAttention
};

typedef void(^profileInfoButtonClicked)(InfoClickType clickType);
typedef void(^profileInfoPhotoButtonClicked)(UIImageView *imageView);

@interface ProfileInfoView : UIView

/* 是否关于我界面 */
@property(nonatomic, assign)BOOL isAboutMe;
/* 用户信息 */
@property(nonatomic, strong)ProfileUserInfoModel *userInfoModel;
/* 用户类型 */
@property(nonatomic, assign)ProfileInfoType userInfoType;
/* 点击回调 */
@property(nonatomic, copy)profileInfoButtonClicked profileInfoButtonClicked;
/* 点击回调 */
@property(nonatomic, copy)profileInfoPhotoButtonClicked profileInfoPhotoButtonClicked;

@end
