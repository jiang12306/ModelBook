//
//  ProfileFollowersController.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, InitialFollowTabPage) {
    InitialFollowTabPageFollowers,
    InitialFollowTabPageFollowing
};

@interface ProfileFollowersController : BaseViewController

/* 起始位置 */
@property(nonatomic, assign)InitialFollowTabPage initialTabPage;

@end
