//
//  ProfileCommentModel.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/24.
//  Copyright © 2017年 zdjt. All rights reserved.
//

//{
//    "code": 0,
//    "msg": "操作成功",
//    "object": [
//               {
//                   "jobCommentId": 13,
//                   "userId": 4,
//                   "user": {
//                       "userId": 4,
//                       "phone": "126",
//                       "nickname": "丁",
//                       "userTypeId": 4,
//                       "userType": {
//                           "userTypeId": 4,
//                           "userTypeName": "网红"
//                       },
//                       "likes": 0,
//                       "headpic": "http://39.108.152.114:80/model/http://39.108.152.114:80/model/http://39.108.152.114:80/model/http://39.108.152.114:80/model//images/login/14025841314042.gif"
//                   },
//                   "commentContent": "多少新市城建，包裹着蝴蝶",
//                   "commentTime": 1503574423000
//               },
//               {
//                   "jobCommentId": 14,
//                   "userId": 4,
//                   "user": {
//                       "userId": 4,
//                       "phone": "126",
//                       "nickname": "丁",
//                       "userTypeId": 4,
//                       "userType": {
//                           "userTypeId": 4,
//                           "userTypeName": "网红"
//                       },
//                       "likes": 0,
//                       "headpic": "http://39.108.152.114:80/model/http://39.108.152.114:80/model/http://39.108.152.114:80/model/http://39.108.152.114:80/model//images/login/14025841314042.gif"
//                   },
//                   "commentContent": "转眼秋天，风筝沉默的瞬间，谁对谁说誓言，想那个春天，无边灿烂，随着那少年贴身香甜，然后他",
//                   "commentTime": 1503574423000
//               },
//               {
//                   "jobCommentId": 12,
//                   "userId": 4,
//                   "user": {
//                       "userId": 4,
//                       "phone": "126",
//                       "nickname": "丁",
//                       "userTypeId": 4,
//                       "userType": {
//                           "userTypeId": 4,
//                           "userTypeName": "网红"
//                       },
//                       "likes": 0,
//                       "headpic": "http://39.108.152.114:80/model/http://39.108.152.114:80/model/http://39.108.152.114:80/model/http://39.108.152.114:80/model//images/login/14025841314042.gif"
//                   },
//                   "commentContent": "我性空山",
//                   "commentTime": 1503574422000
//               },
//               {
//                   "jobCommentId": 6,
//                   "userId": 4,
//                   "user": {
//                       "userId": 4,
//                       "phone": "126",
//                       "nickname": "丁",
//                       "userTypeId": 4,
//                       "userType": {
//                           "userTypeId": 4,
//                           "userTypeName": "网红"
//                       },
//                       "likes": 0,
//                       "headpic": "http://39.108.152.114:80/model/http://39.108.152.114:80/model/http://39.108.152.114:80/model/http://39.108.152.114:80/model//images/login/14025841314042.gif"
//                   },
//                   "commentContent": "好评 测试",
//                   "commentTime": 1503065373000
//               }
//               ]
//}

#import <Foundation/Foundation.h>
#import "MyJobsDetailRecordModel.h"

@interface ProfileCommentModel : NSObject

/* 评论ID */
@property(nonatomic, strong)NSString *jobCommentId;
/* 用户ID */
@property(nonatomic, strong)NSString *userId;
/* 评论内容 */
@property(nonatomic, strong)NSString *commentContent;
/* 评论时间 */
@property(nonatomic, strong)NSString *commentTime;
/* 评论图片 */
@property(nonatomic, strong)NSString *commentImage;
/* 评论图片 */
@property(nonatomic, strong)NSString *commentTag;
/* 评论评分 */
@property(nonatomic, strong)NSString *point;
/* 用户模型 */
@property(nonatomic, strong)MyJobsDetailRecordUser *user;

/* 评论是否展开 */
@property(nonatomic, assign)BOOL isUnfold;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
