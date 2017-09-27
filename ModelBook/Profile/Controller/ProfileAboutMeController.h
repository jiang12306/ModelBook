//
//  ProfileAboutMeController.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "BaseViewController.h"
@class ProfileUserInfoModel;

@interface ProfileAboutMeController : BaseViewController

/* 用户ID */
@property(nonatomic, strong)NSString *userId;
/* 用户模型数据 */
@property(nonatomic, strong)ProfileUserInfoModel *userInfoModel;

- (instancetype)initWithTableFrame:(CGRect)frame;

@end
