//
//  ProfileViewController.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/21.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "BaseViewController.h"

/**
 默认进入板块

 - InitialTabPagePhoto: 照片
 - InitialTabPageVideo: 视频
 - InitialTabPageJobs: 工作
 - InitialTabPageAboutMe: 关于我
 */
typedef NS_ENUM(NSInteger, InitialTabPage) {
    InitialTabPagePhoto = 0,
    InitialTabPageVideo,
    InitialTabPageJobs,
    InitialTabPageAboutMe
};

typedef void(^didSelectedTabPage)(NSInteger index);

@interface ProfileViewController : BaseViewController

- (instancetype)initWithUserId:(NSString *)userId;

/* 起始位置 */
@property(nonatomic, assign)InitialTabPage initialTabPage;
/* 是否从当前类进入 */
@property(nonatomic, assign)BOOL pushFromMySelf;
/* 关于我界面点击板块回调 */
@property(nonatomic, copy)didSelectedTabPage didSelectedTabPage;

@property (copy, nonatomic) NSString *controllerFrom;

@end
