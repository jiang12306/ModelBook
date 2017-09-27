//
//  ProfileFollowModel.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

//{
//    code = 0;
//    msg = "\U64cd\U4f5c\U6210\U529f";
//    object =     {
//        endRow = 1;
//        firstPage = 1;
//        hasNextPage = 0;
//        hasPreviousPage = 0;
//        isFirstPage = 1;
//        isLastPage = 1;
//        lastPage = 1;
//        list =         (
//                        {
//                            bothStatus = 0;
//                            followId = 3;
//                            followTime = 1502531696000;
//                            isChat = 1;
//                            isInform = 1;
//                            targetUserId = 8;
//                            user =                 {
//                                headpic = "http://39.108.152.114:80/model//images/login/14025841314042.gif";
//                                nickname = "\U620c";
//                                phone = 124;
//                                userId = 3;
//                                userType =                     {
//                                    userTypeId = 3;
//                                    userTypeName = "\U6a21\U7279";
//                                };
//                                userTypeId = 3;
//                            };
//                            userId = 3;
//                        }
//                        );
//        navigatePages = 8;
//        navigatepageNums =         (
//                                    1
//                                    );
//        nextPage = 0;
//        pageNum = 1;
//        pageSize = 9;
//        pages = 1;
//        prePage = 0;
//        size = 1;
//        startRow = 1;
//        total = 1;
//    };
//}


#import <Foundation/Foundation.h>
@class ProfileFollowItem;
@class ProfileFollowUserItem;
@class ProfileUserType;

@interface ProfileFollowModel : NSObject

@property(nonatomic, assign)BOOL hasNextPage;
@property(nonatomic, strong)NSArray<ProfileFollowItem *> *followItemArray;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end

@interface ProfileFollowItem : NSObject

@property(nonatomic, strong)NSString *remarkName;
@property(nonatomic, strong)NSString *bothStatus;
@property(nonatomic, strong)NSString *followId;
@property(nonatomic, strong)NSString *followTime;
@property(nonatomic, strong)NSString *isChat;
@property(nonatomic, strong)NSString *isInform;
@property(nonatomic, strong)NSString *targetUserId;
@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)ProfileFollowUserItem *user;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end

@interface ProfileFollowUserItem : NSObject

@property(nonatomic, strong)NSString *headpic;
@property(nonatomic, strong)NSString *canLive;
@property(nonatomic, strong)NSString *nickname;
@property(nonatomic, strong)NSString *phone;
@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSString *userTypeId;
@property(nonatomic, strong)ProfileUserType *userType;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
