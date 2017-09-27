//
//  FollowInfoModel.h
//  ModelBook
//
//  Created by HZ on 2017/9/23.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FollowInfoModel : JSONModel

/**
 头像
 */
@property (strong, nonatomic) NSString * avatarStr;

/**
 昵称
 */
@property (strong, nonatomic) NSString * nicknameStr;

/**
 操作标志
 */
@property (assign, nonatomic) NSString * handleStr;

@end
