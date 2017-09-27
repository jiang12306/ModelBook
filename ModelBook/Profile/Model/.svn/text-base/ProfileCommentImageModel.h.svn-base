//
//  ProfileCommentImageModel.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/24.
//  Copyright © 2017年 zdjt. All rights reserved.
//

//{
//    "code": 0,
//    "msg": "操作成功",
//    "object": {
//        "pageNum": 1,
//        "pageSize": 10,
//        "size": 4,
//        "startRow": 1,
//        "endRow": 4,
//        "total": 4,
//        "pages": 1,
//        "list": [
//                 {
//                     "jobCommentId": 13,
//                     "commentTime": 1503574423000,
//                     "commentImage": "http://39.108.152.114:80/model//images/xxx.png"
//                 },
//                 {
//                     "jobCommentId": 14,
//                     "commentTime": 1503574423000,
//                     "commentImage": "http://39.108.152.114:80/model//upload/job/comment/04fc0692b64e440a9fc03c51c2aba83b.gif"
//                 },
//                 {
//                     "jobCommentId": 12,
//                     "commentTime": 1503574422000,
//                     "commentImage": "http://39.108.152.114:80/model//upload/job/comment/04fc0692b64e440a9fc03c51c2aba83b.gif"
//                 },
//                 {
//                     "jobCommentId": 6,
//                     "commentTime": 1503065373000,
//                     "commentImage": "http://39.108.152.114:80/model//upload/job/comment/04fc0692b64e440a9fc03c51c2aba83b.gif"
//                 }
//                 ],
//        "firstPage": 1,
//        "prePage": 0,
//        "nextPage": 0,
//        "lastPage": 1,
//        "isFirstPage": true,
//        "isLastPage": true,
//        "hasPreviousPage": false,
//        "hasNextPage": false,
//        "navigatePages": 8,
//        "navigatepageNums": [
//                             1
//                             ]
//    }
//}

#import <Foundation/Foundation.h>
@class ProfileCommentImageItem;

@interface ProfileCommentImageModel : NSObject

@property(nonatomic, assign)BOOL hasNextPage;
@property(nonatomic, strong)NSArray<ProfileCommentImageItem *> *commentInfo;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end

@interface ProfileCommentImageItem : NSObject

/* 评论ID */
@property(nonatomic, strong)NSString *jobCommentId;
/* 评论时间 */
@property(nonatomic, strong)NSString *commentTime;
/* 评论图片 */
@property(nonatomic, strong)NSString *commentImage;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
