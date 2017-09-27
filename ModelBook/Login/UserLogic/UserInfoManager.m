//
//  UserInfoManager.m
//  ModelBook
//
//  Created by zdjt on 2017/8/28.
//  Copyright © 2017年 zdjt. All rights reserved.
//

#import "UserInfoManager.h"

@implementation UserInfoManager

+ (long)userID
{
    NSNumber *uid = [[NSUserDefaults standardUserDefaults] valueForKey:@"userID"] ? [[NSUserDefaults standardUserDefaults] valueForKey:@"userID"] : @(0);
    return uid.longValue;
}
+ (void)setUserID:(long)uid
{
    [[NSUserDefaults standardUserDefaults] setValue:@(uid) forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 融云token
+ (NSString *)token
{
    NSString *token = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"token"] ? [[NSUserDefaults standardUserDefaults] valueForKey:@"token"] : @""];
    return token;
}
+ (void)setToken:(NSString *)token
{
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 用户名
+ (NSString *)userName
{
    NSString *userName = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] ? [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] : @""];
    return userName;
}
+ (void)setUserName:(NSString *)userName
{
    [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 密码
+ (NSString *)password {
    NSString *pwd = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"pwd"] ? [[NSUserDefaults standardUserDefaults] valueForKey:@"pwd"] : @""];
    return pwd;
}
+ (void)setPassword:(NSString *)pwd {
    [[NSUserDefaults standardUserDefaults] setValue:pwd forKey:@"pwd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 别名
+ (NSString *)nickName
{
    NSString *nick = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"nickName"] ? [[NSUserDefaults standardUserDefaults] valueForKey:@"nickName"] : @""];
    return nick;
}
+ (void)setNickName:(NSString *)nick
{
    [[NSUserDefaults standardUserDefaults] setValue:nick forKey:@"nickName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 头像
+ (NSString *)headpic
{
    NSString *headpic = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"headpic"] ? [[NSUserDefaults standardUserDefaults] valueForKey:@"headpic"] : @""];
    return headpic;
}
+ (void)setHeadpic:(NSString *)headpic
{
    [[NSUserDefaults standardUserDefaults] setValue:headpic forKey:@"headpic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 聊天推送
+ (NSString *)targetid
{
    NSString *headpic = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"targetid"] ? [[NSUserDefaults standardUserDefaults] valueForKey:@"targetid"] : @""];
    return headpic;
}
+ (void)setTargetid:(NSString *)targetid
{
    [[NSUserDefaults standardUserDefaults] setValue:targetid forKey:@"targetid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 是否登录
+ (NSString *)isLogin
{
    NSString *isLogin = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] ? [[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] : @"0"];
    return isLogin;
}
+ (void)setIsLogin:(NSString *)islogin
{
    [[NSUserDefaults standardUserDefaults] setValue:islogin forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 清除保存信息
+ (void)claearAllInfo
{
    // 清除登录信息
    [UserInfoManager setIsLogin:@"0"];
    // 清除保存用户信息
    [UserInfoManager setToken:@""];
    [UserInfoManager setUserID:-100000];
    [UserInfoManager setNickName:@""];
    [UserInfoManager setHeadpic:@""];
}

@end
