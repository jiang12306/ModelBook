//
//  UserInfoManager.h
//  ModelBook
//
//  Created by zdjt on 2017/8/28.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoManager : NSObject

// 用户ID
+ (long)userID;
+ (void)setUserID:(long)uid;

// 融云token
+ (NSString *)token;
+ (void)setToken:(NSString *)token;

// 用户名
+ (NSString *)userName;
+ (void)setUserName:(NSString *)userName;

// 密码
+ (NSString *)password;
+ (void)setPassword:(NSString *)pwd;

// 别名
+ (NSString *)nickName;
+ (void)setNickName:(NSString *)nick;

// 头像
+ (NSString *)headpic;
+ (void)setHeadpic:(NSString *)headpic;

// 聊天推送
+ (NSString *)targetid;
+ (void)setTargetid:(NSString *)targetid;

// 是否登录
+ (NSString *)isLogin;
+ (void)setIsLogin:(NSString *)islogin;

// 清除保存信息
+ (void)claearAllInfo;

@end
