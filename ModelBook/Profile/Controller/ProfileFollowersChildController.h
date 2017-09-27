//
//  ProfileFollowersChildController.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "BaseViewController.h"

/**
 关注类型

 - ProfileFollowersTypeFollowers: 我的粉丝
 - ProfileFollowersTypeFollowing: 我关注的
 - ProfileFollowersTypeSaved: 我收藏的
 */
typedef NS_ENUM(NSInteger, ProfileFollowType) {
    ProfileFollowTypeFollowers,
    ProfileFollowTypeFollowing,
    ProfileFollowTypeSaved
};

@interface ProfileFollowersChildController : BaseViewController

/* 用户ID */
@property(nonatomic, strong)NSString *userId;

- (instancetype)initWithTableFrame:(CGRect)frame followType:(ProfileFollowType)followType;

@end
