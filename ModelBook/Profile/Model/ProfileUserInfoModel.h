//
//  ProfileUserInfoModel.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

//{
//    code = 0;
//    msg = "\U67e5\U8be2\U6210\U529f";
//    object =     {
//        address = "\U6d4b\U8bd5\U5730\U5740";
//        age = 7;
//        birthday = 1262790388000;
//        dayRate = 2000;
//        fieldId = 2;
//        headpic = "/images/login/14025841314042.gif";
//        height = 173;
//        hourRate = 500;
//        idcardName = "\U6d4b\U8bd5\U8d26\U53f7";
//        idcardNumber = 3209948474884;
//        money = 12000;
//        nickname = "\U6d4b\U8bd5\U8d26\U53f7";
//        password = 6be530e78ade605347059701a54f996e;
//        phone = 12345678910;
//        registerTime = 1502291327000;
//        sex = f;
//        userId = 8;
//        userType =         {
//            userTypeId = 3;
//            userTypeName = "\U6a21\U7279";
//        };
//        userTypeId = 3;
//        weight = 51;
//    };
//}


#import <Foundation/Foundation.h>
@class ProfileUserType;

@interface ProfileUserInfoModel : NSObject

@property(nonatomic, strong)NSString *address;
@property(nonatomic, strong)NSString *age;
@property(nonatomic, strong)NSString *birthday;
@property(nonatomic, strong)NSString *dayRate;
@property(nonatomic, strong)NSString *fieldId;
@property(nonatomic, strong)NSString *headpic;
@property(nonatomic, strong)NSString *height;
@property(nonatomic, strong)NSString *hourRate;
@property(nonatomic, strong)NSString *idcardName;
@property(nonatomic, strong)NSString *idcardNumber;
@property(nonatomic, strong)NSString *money;
@property(nonatomic, strong)NSString *nickname;
@property(nonatomic, strong)NSString *password;
@property(nonatomic, strong)NSString *phone;
@property(nonatomic, strong)NSString *registerTime;
@property(nonatomic, strong)NSString *sex;
@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)ProfileUserType *userType;
@property(nonatomic, strong)NSString *userTypeId;
@property(nonatomic, strong)NSString *weight;
@property(nonatomic, strong)NSString *point;
/* 是否可以评论 */
@property(nonatomic, assign)BOOL canChat;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end

@interface ProfileUserType : NSObject

@property(nonatomic, strong)NSString *userTypeId;
@property(nonatomic, strong)NSString *userTypeName;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
