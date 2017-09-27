//
//  MyJobsListModel.h
//  ModelBook
//
//  Created by 高昇 on 2017/8/22.
//  Copyright © 2017年 zdjt. All rights reserved.
//

//{
//    code = 0;
//    msg = "\U64cd\U4f5c\U6210\U529f";
//    object =     {
//        endRow = 2;
//        firstPage = 1;
//        hasNextPage = 0;
//        hasPreviousPage = 0;
//        isFirstPage = 1;
//        isLastPage = 1;
//        lastPage = 1;
//        list =         (
//                        {
//                            job =                 {
//                                beginTime = 1505095800000;
//                                createTime = 1502933009000;
//                                createUserId = 8;
//                                endTime = 1505275800000;
//                                isDisabled = 0;
//                                isRecommend = 0;
//                                jobAddress = "\U7384\U6b66\U6e56";
//                                jobId = 9;
//                                jobImage = "http://39.108.152.114:80/model//upload/job/d58c49e885ec46ffb65d3570c820e910.jpg";
//                                jobName = "\U7384\U6b66\U6e56\U91c7\U5149";
//                                jobState = 0;
//                                userNumber = 4;
//                                userSex = m;
//                                userType = "1,2,3,4,5";
//                            };
//                            jobId = 9;
//                            recordCreateTime = 1502960263000;
//                            recordId = 7;
//                            recordState = 0;
//                            recordUpdateTime = 1502960265000;
//                            userId = 8;
//                        },
//                        {
//                            job =                 {
//                                beginTime = 1505095800000;
//                                createTime = 1502932958000;
//                                createUserId = 8;
//                                endTime = 1505275800000;
//                                isDisabled = 0;
//                                isRecommend = 0;
//                                jobAddress = "\U554a\U60dc\U8d25\U6d4b\U8bd5";
//                                jobId = 7;
//                                jobImage = "http://39.108.152.114:80/model//upload/job/6b3da08a6d99446bbbdd1f0606d00e0e.jpg";
//                                jobName = "C\U6b27\U7f8e";
//                                jobState = 0;
//                                userNumber = 4;
//                                userSex = f;
//                                userType = "1,2";
//                            };
//                            jobId = 7;
//                            recordCreateTime = 1502932962000;
//                            recordId = 2;
//                            recordState = 0;
//                            recordUpdateTime = 1502932962000;
//                            userId = 8;
//                        }
//                        );
//        navigatePages = 8;
//        navigatepageNums =         (
//                                    1
//                                    );
//        nextPage = 0;
//        pageNum = 1;
//        pageSize = 7;
//        pages = 1;
//        prePage = 0;
//        size = 2;
//        startRow = 1;
//        total = 2;
//    };
//}


#import <Foundation/Foundation.h>
@class jobItem;
@class jobInfo;

@interface MyJobsListModel : NSObject

@property(nonatomic, assign)BOOL hasNextPage;
@property(nonatomic, strong)NSArray<jobInfo *> *jobInfo;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end

@interface jobInfo : NSObject

@property(nonatomic, strong)NSString *jobId;
@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSString *recordId;
@property(nonatomic, strong)NSString *recordState;
@property(nonatomic, strong)NSString *showState;
@property(nonatomic, strong)NSString *recordUpdateTime;
@property(nonatomic, strong)NSString *requestNum;
@property(nonatomic, assign)BOOL isHide;
@property(nonatomic, strong)jobItem *job;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end

@interface jobItem : NSObject

@property(nonatomic, strong)NSString *jobId;
@property(nonatomic, strong)NSString *jobImage;
@property(nonatomic, strong)NSString *jobName;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
