//
//  MyJobsDetailRecordModel.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/23.
//  Copyright © 2017年 zdjt. All rights reserved.
//

//{
//    "code": 0,
//    "msg": "操作成功",
//    "object": {
//        "record": [
//                   {
//                       "recordId": 6,
//                       "jobId": 9,
//                       "userId": 4,
//                       "user": {
//                           "userId": 4,
//                           "phone": "126",
//                           "nickname": "丁",
//                           "userTypeId": 4,
//                           "userType": {
//                               "userTypeId": 4,
//                               "userTypeName": "网红"
//                           },
//                           "likes": 0,
//                           "headpic": "http://39.108.152.114:80/model//images/login/14025841314042.gif"
//                       },
//                       "recordCreateTime": 1502958826000,
//                       "recordUpdateTime": 1503068442000,
//                       "recordState": "3"
//                   },
//                   {
//                       "recordId": 8,
//                       "jobId": 9,
//                       "userId": 7,
//                       "user": {
//                           "userId": 7,
//                           "phone": "1801",
//                           "nickname": "贾",
//                           "userTypeId": 2,
//                           "userType": {
//                               "userTypeId": 2,
//                               "userTypeName": "化妆师"
//                           },
//                           "likes": 0,
//                           "headpic": "http://39.108.152.114:80/model//images/login/14025841314042.gif"
//                       },
//                       "recordCreateTime": 1503028671000,
//                       "recordUpdateTime": 1503028674000,
//                       "recordState": "1"
//                   }
//                   ],
//        "job": {
//            "jobId": 9,
//            "jobName": "玄武湖采光",
//            "jobAddress": "玄武湖",
//            "createUserId": 8,
//            "createTime": 1502933009000,
//            "beginTime": 1505095800000,
//            "endTime": 1505275800000,
//            "userNumber": 4,
//            "userType": "1,2,3,4,5",
//            "userSex": "m",
//            "jobState": 0,
//            "jobImage": "http://39.108.152.114:80/model//upload/job/d58c49e885ec46ffb65d3570c820e910.jpg,http://39.108.152.114:80/model//upload/job/461fde776c4a4e05868a31b883e80181.jpg,",
//            "isRecommend": 0,
//            "isDisabled": false
//        }
//    }
//}

#import <Foundation/Foundation.h>
@class ProfileUserType;
@class MyJobsDetailRecordUser;

@interface MyJobsDetailRecordModel : NSObject

@property(nonatomic, strong)NSString *jobId;
@property(nonatomic, strong)NSString *recordCreateTime;
@property(nonatomic, strong)NSString *recordId;
/* 1-等待回应，2-未通过，3-已通过 */
@property(nonatomic, strong)NSString *recordState;
@property(nonatomic, strong)NSString *recordUpdateTime;
@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)MyJobsDetailRecordUser *user;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end

@interface MyJobsDetailRecordUser : NSObject

@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSString *phone;
@property(nonatomic, strong)NSString *nickname;
@property(nonatomic, strong)NSString *userTypeId;
@property(nonatomic, strong)NSString *likes;
@property(nonatomic, strong)NSString *headpic;
@property(nonatomic, strong)ProfileUserType *userType;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
